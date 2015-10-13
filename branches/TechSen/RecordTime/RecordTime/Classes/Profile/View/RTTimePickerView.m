//
//  RTTimePickerView.m
//  RecordTime
//
//  Created by sen on 8/31/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTTimePickerView.h"
#import "Header.h"

#define ANIMATION_DURATION 0.3
#define TOOL_BAR_HEIGHT 40.0

@interface RTTimePickerView ()
@property(assign, nonatomic) BOOL didUpdateConstraint;
@property(weak, nonatomic) UIDatePicker *picker;
@property(weak, nonatomic) UIButton *cover;
@property(weak, nonatomic) UIView *toolBar;
@property(weak, nonatomic) UIButton *cancelButton;
@property(weak, nonatomic) UIButton *confirmButton;
@end

@implementation RTTimePickerView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    
    UIButton *cover = [[UIButton alloc] init];
    [cover addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    cover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    [self addSubview:cover];
    _cover =cover;
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.backgroundColor = DEFAULT_BG_COLOR;
    [self addSubview:toolBar];
    _toolBar = toolBar;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    _cancelButton = cancelButton;
    
    [toolBar addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    _confirmButton = confirmButton;
    
    [toolBar addSubview:confirmButton];
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.backgroundColor = DEFAULT_BG_COLOR;
    picker.locale = [NSLocale currentLocale];
    picker.datePickerMode = UIDatePickerModeTime;
    [self addSubview:picker];
    _picker = picker;
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraint) {
        [_cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_cover.superview);
        }];
        
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_picker);
            make.height.mas_equalTo(TOOL_BAR_HEIGHT);
            make.bottom.equalTo(_picker.mas_top);
            make.centerX.equalTo(_toolBar.superview);
        }];
        
        
        CGFloat h_padding = 15.0;
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cancelButton.superview).offset(h_padding);
            make.centerY.equalTo(_cancelButton.superview);
        }];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_confirmButton.superview).offset(-h_padding);
            make.centerY.equalTo(_confirmButton.superview);
        }];
        
        [_picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picker.superview.mas_bottom).offset(TOOL_BAR_HEIGHT);
            make.centerX.equalTo(_picker.superview);
        }];
        
        self.didUpdateConstraint = YES;
    }
    [super updateConstraints];
    
}

#pragma mark - Action
- (void)confirmButtonPressed
{
    if (self.delegate || [self.delegate respondsToSelector:@selector(timePickerDidGetDate:)]) {
        [self.delegate timePickerDidGetDate:_picker.date];
        [self dismiss];
    }
}

#pragma mark - Public Methods
- (void)show
{
    self.hidden = NO;
    [self layoutIfNeeded];
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [_picker mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_picker.superview.mas_bottom);
            make.centerX.equalTo(_picker.superview);
        }];
        _cover.alpha = 1.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}



- (void)dismiss
{
    [self layoutIfNeeded];
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [_picker mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picker.superview.mas_bottom).offset(TOOL_BAR_HEIGHT);
            make.centerX.equalTo(_picker.superview);
        }];
        _cover.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


@end
