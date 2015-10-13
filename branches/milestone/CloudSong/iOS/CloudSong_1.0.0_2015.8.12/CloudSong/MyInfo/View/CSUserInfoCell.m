//
//  CSUserInfoCell.m
//  CloudSong
//
//  Created by sen on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSUserInfoCell.h"
#import "CSDefine.h"
#import <Masonry.h>
@interface CSUserInfoCell ()
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIImageView *arrawView;
@property(nonatomic, weak) UILabel *placeHolderLabel;
@property(nonatomic, assign) BOOL didSetupConstraint;

@end

@implementation CSUserInfoCell

- (instancetype)initWithTitle:(NSString *)title
{
    _title = title;
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
        self.backgroundColor = HEX_COLOR(0x222126);
    
    }
    return self;
}


#pragma mark - Setup
- (void)setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.textColor = HEX_COLOR(0x4c4c53);
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    subTitleLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self addSubview:subTitleLabel];
    _subTitleLabel = subTitleLabel;
    
    
    UIImageView *arrawView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    [self addSubview:arrawView];
    _arrawView = arrawView;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
    if (_placeHolderLabel) {
        _placeHolderLabel.hidden = subTitle.length > 0;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    if (placeHolder.length > 0) {
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
        placeHolderLabel.textColor = HEX_COLOR(0x4c4c53);
        placeHolderLabel.text = placeHolder;
        [self addSubview:placeHolderLabel];
        [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(placeHolderLabel.superview);
            make.left.equalTo(placeHolderLabel.superview).offset(TRANSFER_SIZE(95.0));
        }];
        _placeHolderLabel = placeHolderLabel;
    }
}



- (void)addTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGr];
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.superview);
            make.left.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(19.0));
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_subTitleLabel.superview);
            make.left.equalTo(_subTitleLabel.superview).offset(TRANSFER_SIZE(94.0));
            make.width.mas_lessThanOrEqualTo(AUTOLENGTH(190));
        }];
        
        [_arrawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_arrawView.superview);
            make.right.equalTo(_arrawView.superview).offset(-TRANSFER_SIZE(26.0));
        }];
        
        _didSetupConstraint = YES;
    }

    [super updateConstraints];
}
@end
