//
//  RTLogTableViewCell.m
//  RecordTime
//
//  Created by sen on 9/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTLogTableViewCell.h"
#import "RTDatePointModel.h"
#import "Header.h"
@interface RTLogTableViewCell ()
@property(weak, nonatomic) UILabel *logLabel;
@property(assign, nonatomic) BOOL didUpdateConstraint;

@end


@implementation RTLogTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"logCell";
    RTLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RTLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}





- (void)setupSubviews
{
    UILabel *logLabel = [[UILabel alloc] init];
    [self addSubview:logLabel];
    _logLabel = logLabel;
    
    [self updateConstraintsIfNeeded];
    
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraint) {
        
        [_logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_logLabel.superview);
            make.left.equalTo(_logLabel.superview).offset(20.0);
        }];
        
        self.didUpdateConstraint = YES;
    }
    [super updateConstraints];
    
}

#pragma mark - Public Methods
- (void)setItems:(RTDatePointModel *)items
{
    _items = items;
    
    NSString *dateType = nil;
    switch (items.dateType) {
        case RTDatePointTypeEnterCompany:
            dateType = @"进入公司";
            break;
        case RTDatePointTypeExitCompany:
            dateType = @"离开公司";
            break;
        case RTDatePointTypeEnterHome:
            dateType = @"进入房间";
            break;
        case RTDatePointTypeExitHome:
            dateType = @"离开房间";
            break;
        default:
            break;
    }
    
    _logLabel.text = [NSString stringWithFormat:@"你在%@,%@",[[RTDateTool dateFormatter] stringFromDate:items.date],dateType];
}



@end
