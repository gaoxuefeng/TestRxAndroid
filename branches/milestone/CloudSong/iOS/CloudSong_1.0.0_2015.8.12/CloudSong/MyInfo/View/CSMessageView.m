//
//  CSMessageView.m
//  CloudSong
//
//  Created by sen on 15/6/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMessageView.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "UIImage+Extension.h"
@interface CSMessageView ()
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) UILabel *contentLabel;
@property(nonatomic, weak) UIImageView *backgroundImageView;

@end

@implementation CSMessageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = HEX_COLOR(0xbebec0);
    contentLabel.font = [UIFont systemFontOfSize:13.0];
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [[UIImage imageNamed:@"mine_chat_bg"] resizedImage];
    [self addSubview:backgroundImageView];
    _backgroundImageView = backgroundImageView;
}

#pragma mark - Public Methods
- (void)setContent:(NSString *)content
{
    _content = content;
    _contentLabel.text = content;
    
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentLabel.superview).insets(UIEdgeInsetsMake(11.0, 11.0, 11.0, 11.0));
        }];
        
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backgroundImageView.superview);
        }];
        

        
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}

@end
