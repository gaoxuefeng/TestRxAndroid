//
//  CSNoNetworkView.m
//  CloudSong
//
//  Created by sen on 8/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSNoNetworkView.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSNoNetworkView ()
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(weak, nonatomic) UIImageView *noNetworkImageView;
@property(weak, nonatomic) UIImageView *backgroundView;
@property(weak, nonatomic) UIButton *refreshButton;
@end

@implementation CSNoNetworkView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubviews
{

    UIImageView *backgroundView = [[UIImageView alloc] init];
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    UIImageView *noNetworkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unconnected_bg"]];
    _noNetworkImageView = noNetworkImageView;
    [self addSubview:noNetworkImageView];
    
    
//    UIButton *refreshButton = [[UIButton alloc] init];
}


- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backgroundView.superview);
        }];
        
        [_noNetworkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noNetworkImageView.superview);
            make.centerY.equalTo(_noNetworkImageView.superview).offset(-TRANSFER_SIZE(50.0));
        }];
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundView.image = backgroundImage;
}


@end
