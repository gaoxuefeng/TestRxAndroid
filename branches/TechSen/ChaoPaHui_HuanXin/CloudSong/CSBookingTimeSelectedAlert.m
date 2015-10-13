//
//  CSBookingTimeSelectedAlert.m
//  CloudSong
//
//  Created by youmingtaizi on 7/23/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBookingTimeSelectedAlert.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSUtil.h"

#define kMaxBookingDuration 8

@interface CSBookingTimeSelectedAlert () <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView*           _picker;
    NSMutableArray*         _dates;
    NSDictionary*           _startTimes;
    NSMutableArray*         _durations;
    // YES代码表营业时间不隔天，否则营业时间隔天
    BOOL                    _openTimeInOneDay;
    // 用于保存营业时间隔天的情况下，第二天上午的可预订时长。考虑到营业结束时间有可能是半点得情况，所以用float类型
    CGFloat                 _numOfHoursInSecondDay;
    NSDate*                 _closeTime;
//    NSInteger               _currentMonth;//可预订时长
}
@end

@implementation CSBookingTimeSelectedAlert

#pragma mark - Life Cycle

// 传入的date参数需要确保是在KTV营业的最晚时间之前1小时，这样才可以预定
- (instancetype)initWithDate:(NSDate *)date openTime:(NSDate *)openTime closeTime:(NSDate *)closeTime {
    if (self = [super init]) {
        _closeTime = closeTime;
        
        // 生成日期
        _dates = [NSMutableArray array];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM月dd日";
        for (int i = 0; i < 30; ++i) {
            NSDate *newDate = [NSDate dateWithTimeInterval:3600 * 24 * i sinceDate:date];
            NSString *dateStr = [formatter stringFromDate:newDate];
            [_dates addObject:dateStr];
        }
        
        // 生成可以预定的时间
        NSDateComponents *open = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:openTime];
        NSDateComponents *close = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:closeTime];
        _openTimeInOneDay = [open hour] < [close hour];
        // 营业时间不隔天情况下计算可预订时间，例如 08:00~23:00
        if (_openTimeInOneDay) {
            _startTimes = [self availableTimesInCurrentDayWithDate:date openTime:openTime closeTime:closeTime];
        }
        // 营业时间隔天情况下计算可预订时间，例如 14:00~05:00
        else {
            _startTimes = [self availableTimesInTwoDaysWithDate:date openTime:openTime closeTime:closeTime];
            _numOfHoursInSecondDay = [close hour] + ([close minute] == 30 ? 0.5 : 0);
        }

        // 生成时长
        _durations = [NSMutableArray array];
        [self refreshDurations];

        [self setupSubviews];
        self.hidden = YES;
    }
    return self;
}

#pragma mark - Public Methods

- (void)show {
    self.hidden = NO;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    // 全屏半透明遮罩层
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.04];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview);
    }];
    
    // 内容的容器
    UIView *container = [[UIView alloc] init];
    [self addSubview:container];
    container.backgroundColor = HEX_COLOR(0x321d4e);
    container.layer.cornerRadius = 10;
    container.layer.masksToBounds = YES;
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(container.superview);
//        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(300), TRANSFER_SIZE(250)));
        make.left.equalTo(self.superview).offset(TRANSFER_SIZE(15)) ;
        make.right.equalTo(self.superview).offset(-TRANSFER_SIZE(15)) ;
        make.height.mas_equalTo(@250) ;
    }];
    
    // 顶部title
    UILabel *title = [[UILabel alloc] init];
    [container addSubview:title];
    title.backgroundColor = HEX_COLOR(0x43246b);
    title.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    title.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.8];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"选择预约时间";
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(title.superview);
        make.top.equalTo(title.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(50));
    }];
    
    // picker
    _picker = [[UIPickerView alloc] init];
    [container addSubview:_picker];
    _picker.dataSource = self;
    _picker.delegate = self;
    [_picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_picker.superview);
        make.top.equalTo(_picker.superview).offset(TRANSFER_SIZE(50));
        make.bottom.equalTo(_picker.superview).offset(TRANSFER_SIZE(-50));
    }];
    
    // 唱
    UILabel *singLabel = [[UILabel alloc] init];
    [container addSubview:singLabel];
    singLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    singLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
    singLabel.textAlignment = NSTextAlignmentCenter;
    singLabel.text = @"唱";
    [singLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat rightOffset = (SCREENWIDTH - TRANSFER_SIZE(30)) / 3.0 - TRANSFER_SIZE(15) ;
        make.right.equalTo(singLabel.superview).offset(-TRANSFER_SIZE(rightOffset));
        make.top.equalTo(singLabel.superview) ;
        make.bottom.equalTo(singLabel.superview) ;
    }];
    
    // cancel button
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [container addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    [cancelBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.8] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = HEX_COLOR(0x43246b);
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(cancelBtn.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(50));
        make.width.equalTo(cancelBtn.superview).multipliedBy(.5).offset(-1);
    }];
    
    // confirm button
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [container addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    [confirmBtn setTitleColor:HEX_COLOR(0xff00ab) forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.backgroundColor = HEX_COLOR(0x43246b);
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(confirmBtn.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(50));
        make.width.equalTo(confirmBtn.superview).multipliedBy(.5);
    }];
}

// 营业时间不跨天
- (NSDictionary *)availableTimesInCurrentDayWithDate:(NSDate *)date openTime:(NSDate *)openTime closeTime:(NSDate *)closeTime {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    BOOL firstDay = YES;
    for (NSString *dateString in _dates) {
        if (firstDay) {
            firstDay = NO;
            result[dateString] = [self availableTimesWithCurrentTime:date openTime:openTime closeTime:closeTime];
        }
        else
            result[dateString] = [self availableTimesWithCurrentTime:openTime openTime:openTime closeTime:closeTime];
    }
    return result;
}

// 营业时间跨天
- (NSDictionary *)availableTimesInTwoDaysWithDate:(NSDate *)date openTime:(NSDate *)openTime closeTime:(NSDate *)closeTime {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    BOOL firstDay = YES;
    for (NSString *dateString in _dates) {
        if (firstDay) {
            firstDay = NO;
            NSMutableArray *times = [NSMutableArray array];
            [times addObjectsFromArray:[self availableTimesWithCurrentTime:date openTime:[[CSUtil defaultTimeFormattor] dateFromString:@"00:00"] closeTime:closeTime]];
            [times addObjectsFromArray:[self availableTimesWithCurrentTime:date openTime:openTime closeTime:[[CSUtil defaultTimeFormattor] dateFromString:@"23:59"]]];
            result[dateString] = times;
        }
        else {
            NSMutableArray *times = [NSMutableArray array];
            [times addObjectsFromArray:[self availableTimesWithCurrentTime:[[CSUtil defaultTimeFormattor] dateFromString:@"00:00"]
                                                                  openTime:[[CSUtil defaultTimeFormattor] dateFromString:@"00:00"]
                                                                 closeTime:closeTime]];
            [times addObjectsFromArray:[self availableTimesWithCurrentTime:openTime openTime:openTime closeTime:[[CSUtil defaultTimeFormattor] dateFromString:@"23:59"]]];
            result[dateString] = times;
        }
    }
    return result;
}

// 根据当前时间、开始营业时间、结束营业时间来返回当天可预订的时间段
- (NSArray *)availableTimesWithCurrentTime:(NSDate *)currentTime openTime:(NSDate *)openTime closeTime:(NSDate *)closeTime {
    NSDate *laterDate = [currentTime laterDate:openTime];
    NSDateComponents *later = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:laterDate];
    NSDateComponents *close = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:closeTime];
    NSInteger closeHour = [close hour];
    NSInteger closeMinute = [close minute];
    
    // 营业时间是否隔天的标记
    BOOL twoDays = NO;
    if (closeMinute == 59) {
        twoDays = YES;
        closeHour = 24;
        closeMinute = 0;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    NSInteger hour = [later hour];
    NSInteger minuter = [later minute];
    while ((closeHour * 100 + closeMinute) - (hour * 100 + minuter) >= 100) {
        NSString *time = [NSString stringWithFormat:@"%02ld:%02ld", hour, minuter];
        [result addObject:time];
        if (minuter == 0)
            minuter = 30;
        else {
            minuter = 0;
            ++ hour;
        }
    }
    
    // 如果是隔天的话，当天的可预订时间应该到23：30
    if (twoDays) {
        [result addObject:@"23:30"];
    }
    return result;
}

// 根据当前选择的日期和时间，重新计算可预订时长
- (void)refreshDurations {
    // 考虑到有半小时的可能性，numOfHours应该去float
    CGFloat numOfHours = 0;
    NSInteger index0 = [_picker selectedRowInComponent:0];
    NSInteger index1 = [_picker selectedRowInComponent:1];

    // 如果营业时间在一天之内
    if (_openTimeInOneDay) {
        // 通过计算有多少个半小时来计算可预订时长
        numOfHours = MIN(kMaxBookingDuration, ([_startTimes[_dates[index0]] count] - index1) * .5);
    }
    // 如果营业时间跨天
    else {
        NSString *selectedTimeString = _startTimes[_dates[index0]][index1];
        NSDate *selectedTime = [[CSUtil defaultTimeFormattor] dateFromString:selectedTimeString];
        NSDateComponents *selectedTimeCom = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:selectedTime];
        NSDateComponents *closeTimeCom = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:_closeTime];
        // 如果选择的时间在当天的00:00到结束营业时间之前一小时时间段内
        if ([selectedTimeCom hour] <= [closeTimeCom hour] && [selectedTimeCom minute] <= [closeTimeCom minute]) {
            numOfHours = MIN(kMaxBookingDuration, [closeTimeCom hour] - [selectedTimeCom hour] + ([closeTimeCom minute] - [selectedTimeCom minute])/30 * .5);
        }
        // 如果选择的时间在开始营业时间到24:00的时间段之内
        else {
            numOfHours = MIN(kMaxBookingDuration, ([_startTimes[_dates[index0]] count] - index1) * .5 + _numOfHoursInSecondDay);
        }
    }
    
    [_durations removeAllObjects];
    NSInteger numOfDurations = (NSInteger)floor(numOfHours + .1);
    for (int i = 1; i <= numOfDurations; ++i) {
        [_durations addObject:[NSNumber numberWithInt:i]];
    }
}

- (void)close {
    [self removeFromSuperview];
}

#pragma mark - Action Methods

- (void)cancelBtnPressed {
    [self close];
}

- (void)confirmBtnPressed {
    if ([self.delegate respondsToSelector:@selector(bookingTimeSelectedAlert:didSelectDate:duration:)]) {
        NSString *dateString = _dates[[_picker selectedRowInComponent:0]];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"日" withString:@""];
        NSArray *dateComponents = [dateString componentsSeparatedByString:@"月"];
//        _currentMonth = [dateComponents[0] integerValue];
        NSString *timeString = _startTimes[_dates[[_picker selectedRowInComponent:0]]][[_picker selectedRowInComponent:1]];
        NSArray *timeComponents = [timeString componentsSeparatedByString:@":"];
        NSString *fullDateString = [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld",
                                    [dateComponents[0] integerValue], [dateComponents[1] integerValue],
                                    [timeComponents[0] integerValue], [timeComponents[1] integerValue]];
        NSDate *date = [[CSUtil defaultFullDateFormattor] dateFromString:fullDateString];
        [self.delegate bookingTimeSelectedAlert:self didSelectDate:date duration:[_picker selectedRowInComponent:2] + 1];
    }
    [self close];
}
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return 30;
    else if (component == 1) {
        NSInteger dateIndex = [pickerView selectedRowInComponent:0];
        return [_startTimes[_dates[dateIndex]] count];
    }
    else
        return _durations.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _dates[row];
    }
    else if (component == 1) {
        if (row < [_startTimes[_dates[[pickerView selectedRowInComponent:0]]] count]) {
            return _startTimes[_dates[[pickerView selectedRowInComponent:0]]][row];
        }
    }
    else
        return [NSString stringWithFormat:@"%d小时", [(NSNumber *)_durations[row] intValue]];
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component];
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat result;
    if (component == 0)
        result = self.width * .3;
    else if (component == 1)
        result = self.width * .3;
    else
        result = self.width * .3;
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
        [self refreshDurations];
        [pickerView reloadComponent:2];
    }
    else if (component == 1) {
        [self refreshDurations];
        [pickerView reloadComponent:2];
    }
}

@end
