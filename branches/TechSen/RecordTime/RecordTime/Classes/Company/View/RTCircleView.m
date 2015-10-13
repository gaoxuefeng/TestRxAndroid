//
//  RTCircleView.m
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTCircleView.h"
#import "Header.h"
#define BORDER_COLOR [UIColor grayColor]

#define BORDER_WIDTH 3.0


@interface RTCircleView ()
@property(assign, nonatomic) BOOL didUpdateConstraint;
@property(weak, nonatomic) UILabel *yesterdayLabel;
@property(weak, nonatomic) UILabel *timeLabel;
@property(weak, nonatomic) UIView *topLine;
@property(weak, nonatomic) UIView *bottomLine;
@end


@implementation RTCircleView

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
        
        self.layer.borderColor = BORDER_COLOR.CGColor;
        self.layer.borderWidth = BORDER_WIDTH;
    }
    return self;
}

#pragma mark - SetupSubviews
- (void)setupSubviews
{
    UILabel *yesterdayLabel = [[UILabel alloc] init];
    yesterdayLabel.font = [UIFont systemFontOfSize:20.0];
    yesterdayLabel.textColor = [UIColor grayColor];
    yesterdayLabel.text = @"昨日上班";
    [self addSubview:yesterdayLabel];
    _yesterdayLabel = yesterdayLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont boldSystemFontOfSize:30.0];
    timeLabel.text = @"9小时20分";
    timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = BORDER_COLOR;
    [self addSubview:topLine];
    _topLine = topLine;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = topLine.backgroundColor;
    [self addSubview:bottomLine];
    _bottomLine = bottomLine;

}



- (void)updateConstraints
{
    if (!self.didUpdateConstraint) {
        [_yesterdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_yesterdayLabel.superview);
            make.top.equalTo(_yesterdayLabel.superview).offset(AUTOLENGTH(20.0));
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_timeLabel.superview);
        }];
        
        CGFloat lineHeight = BORDER_WIDTH;
        CGFloat padding = AUTOLENGTH(50.0);
        
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(lineHeight);
            make.left.right.equalTo(_topLine.superview);
            make.centerY.equalTo(_topLine.superview).offset(-padding);
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(lineHeight);
            make.left.right.equalTo(_bottomLine.superview);
            make.centerY.equalTo(_bottomLine.superview).offset(padding);
        }];
        
        self.didUpdateConstraint = YES;
    }
    [super updateConstraints];
    
}

@end
