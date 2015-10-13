//
//  NBOrderTakeTimeView.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderTakeTimeView.h"
#import "NBCommon.h"

@interface NBOrderTakeTimeView()
@property(nonatomic, weak) UILabel *statusLabel;
@property(nonatomic, weak) UILabel *timeLabel;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation NBOrderTakeTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *tokeTimeCell = [[UIView alloc] initForAutoLayout];
    tokeTimeCell.backgroundColor = HEX_COLOR(0xf3f3f3);
    [self addSubview:tokeTimeCell];
    [tokeTimeCell autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [tokeTimeCell autoSetDimension:ALDimensionHeight toSize:39.f];
    [tokeTimeCell autoCenterInSuperview];
    
    // 中心分割线
    UIView *centerDivider = [[UIView alloc] initForAutoLayout];
    centerDivider.backgroundColor = HEX_COLOR(0x464646);
    [tokeTimeCell addSubview:centerDivider];
    [centerDivider autoSetDimensionsToSize:CGSizeMake(1.f, 17.f)];
    [centerDivider autoCenterInSuperview];
    
    // 左边状态栏
    UIView *statusView = [[UIView alloc] initForAutoLayout];
    [tokeTimeCell addSubview:statusView];
    [statusView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:statusView.superview withMultiplier:.5];
    [statusView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:statusView.superview];
    [statusView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
    // 左边状态栏文字
    UILabel *statusLabel = [[UILabel alloc] initForAutoLayout];
    statusLabel.font = [UIFont systemFontOfSize:15.f];
    statusLabel.textColor = HEX_COLOR(0x464646);
    [statusView addSubview:statusLabel];
    _statusLabel = statusLabel;
    [statusLabel autoCenterInSuperview];
    
    // 右边时间栏
    UIView *timeView = [[UIView alloc] initForAutoLayout];
//    timeView.backgroundColor = [UIColor redColor];
    [tokeTimeCell addSubview:timeView];
    [timeView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:statusView.superview withMultiplier:.5];
    [timeView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:statusView.superview];
    [timeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
    
    // 右边时间栏时间
    UILabel *timeLabel = [[UILabel alloc] initForAutoLayout];
    timeLabel.font = [UIFont systemFontOfSize:15.f];
    timeLabel.textColor = HEX_COLOR(0xf56800);
    [timeView addSubview:timeLabel];
    _timeLabel = timeLabel;
    [timeLabel autoCenterInSuperview];
    
}
- (void)setStatusType:(NBOrderStatusType)statusType
{
    _statusType = statusType;
    NSString *statusStr = nil;
    switch (statusType) {
        case NBOrderStatusTypeJustPay:
            statusStr = @"已等待";
            break;
        case NBOrderStatusTypeInMaking:
            statusStr = @"预计取餐时间";
            break;
        case NBOrderStatusTypeWaitingForTaking:
            statusStr = @"预计取餐时间";
            break;
        default:
            break;
    }
    _statusLabel.text = statusStr;
}

- (void)setTime:(NSString *)time
{
    _time = time;
    _timeLabel.text = time;
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timerIncrease) userInfo:nil repeats:YES];
////    [NSRunLoop mainRunLoop]
//    switch (_statusType) {
//        case NBOrderStatusTypeJustPay:
//            statusStr = @"已等待";
//            break;
//        case NBOrderStatusTypeInMaking:
//            statusStr = @"预计取餐时间";
//            break;
//        case NBOrderStatusTypeWaitingForTaking:
//            statusStr = @"预计取餐时间";
//            break;
//        default:
//            break;
}

@end
