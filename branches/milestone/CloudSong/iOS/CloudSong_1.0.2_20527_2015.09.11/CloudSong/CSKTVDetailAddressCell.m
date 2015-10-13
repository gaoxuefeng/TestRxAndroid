//
//  CSKTVDetailAddressCell.m
//  CloudSong
//
//  Created by youmingtaizi on 7/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVDetailAddressCell.h"
#import "CSDefine.h"
#import <Masonry.h>


@interface CSKTVDetailAddressCell () <UIGestureRecognizerDelegate, UIAlertViewDelegate> {
    UILabel*    _addressLabel;
    NSString*   _phoneNumber;
    UIButton*   _callBtn;
}
@end

@implementation CSKTVDetailAddressCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = WhiteColor_Alpha_4;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setAddress:(NSString *)address phoneNum:(NSString *)phoneNum {
    _addressLabel.text = address;
    _phoneNumber = phoneNum;
}

#pragma mark - Private Methods
- (void)setupSubviews {
    // location image
    UIImageView *location = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_location_icon"]];
    [self.contentView addSubview:location];
    [location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(location.superview).offset(TRANSFER_SIZE(12));
        make.centerY.equalTo(location.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(10), TRANSFER_SIZE(12)));
    }];
    
    // call button
    _callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_callBtn];
    [_callBtn setImage:[UIImage imageNamed:@"schedule_phone-number_icon"] forState:UIControlStateNormal];
    [_callBtn addTarget:self action:@selector(callBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_callBtn.superview);
        make.top.bottom.equalTo(_callBtn.superview);
        make.width.mas_equalTo(TRANSFER_SIZE(41));
    }];
    
    // address label
    _addressLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_addressLabel];
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.numberOfLines = 2;
    _addressLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.8];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(location).offset(TRANSFER_SIZE(15));
        make.right.equalTo(_callBtn.mas_left).offset(TRANSFER_SIZE(-2));
        make.top.bottom.equalTo(_addressLabel.superview);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self.contentView addGestureRecognizer:tap];
}

#pragma mark - Action Methods

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(KTVDetailAddressCellDidPressLocateBtn:)]) {
        [self.delegate KTVDetailAddressCellDidPressLocateBtn:self];
    }
}

- (void)callBtnPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"呼叫"
                                                    message:_phoneNumber
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"呼叫", nil];
    [alert show];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.contentView];
    return !CGRectContainsPoint(_callBtn.frame, point);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        NSString *telURLString = [NSString stringWithFormat:@"tel:%@", _phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURLString]];
    }
}

@end
