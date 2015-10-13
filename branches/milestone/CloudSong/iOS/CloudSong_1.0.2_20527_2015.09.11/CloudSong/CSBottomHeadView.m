//
//  CSBottomHeadView.m
//  CloudSong
//
//  Created by EThank on 15/6/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBottomHeadView.h"
#import "CSDefine.h"
#import "CSPlayingModel.h"
#import <UIImageView+WebCache.h>
#import "CSHttpTool.h"
#import "GlobalVar.h"

@interface CSBottomHeadView  ()

/** 赞按钮 */
@property (nonatomic, weak) UIButton *likeBtn ;

/** 存放底部头像 */
@property (nonatomic, strong) NSMutableArray *headViewArray ;

@end

@implementation CSBottomHeadView

#pragma mark - 懒加载
- (NSMutableArray *)headViewArray
{
    if (_headViewArray == nil) {
        _headViewArray = [NSMutableArray array] ;
    }
    return _headViewArray ;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        
        // 1. 点赞按钮
        UIButton *likeBtn = [[UIButton alloc] init] ;
        [likeBtn setImage:[UIImage imageNamed:@"player_not_like_btn"] forState:UIControlStateNormal] ;
        [likeBtn setImage:[UIImage imageNamed:@"player_like_btn"] forState:UIControlStateSelected];
        likeBtn.selected = NO;
        //find_like_icon
        likeBtn.titleLabel.font = [UIFont systemFontOfSize:14] ;
        [likeBtn setTitleColor:Color_168_168_165 forState:UIControlStateNormal] ;
        likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10) ;
        [self addSubview:likeBtn] ;
        [likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside] ;
        self.likeBtn = likeBtn ;
        
        
        // 3. 循环创建5个头像
        for (int i = 0 ; i < 5; i++) {
            UIImageView *headView = [[UIImageView alloc] init] ;
            [self addSubview:headView] ;
            [self.headViewArray addObject:headView] ;
        }
    }
    return self ;
}
//- (void)refreshData
//{
//    if ([self.delegate respondsToSelector:@selector(bottomHeadViewDidChangePraiseState:)]) {
//        [self.delegate bottomHeadViewDidChangePraiseState:self];
//    }
//}
- (void)prepareForInterfaceBuilder
{
    for (int i = 0 ; i < 5; i++) {
        UIImageView *headView = [[UIImageView alloc] init] ;
        //            headView.image = [UIImage imageNamed:@"player_like_btn"] ;
        [self addSubview:headView] ;
        [self.headViewArray addObject:headView] ;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. 点赞按钮frame
    CGFloat likeBtnX = TRANSFER_SIZE(6) ;
    CGFloat likeBtnY = TRANSFER_SIZE(12) ;
    CGFloat likeBtnHW = TRANSFER_SIZE(30) ;
    CGFloat likeBtnW = TRANSFER_SIZE(60) ;
    self.likeBtn.frame = CGRectMake(likeBtnX, likeBtnY, likeBtnW, likeBtnHW) ;
    self.likeBtn.layer.cornerRadius = likeBtnHW / 2 ;
    self.likeBtn.layer.masksToBounds = YES ;
    
    // 5 个头像frame 从后往前算
    CGFloat headViewX = SCREENWIDTH - TRANSFER_SIZE(45) ;
    CGFloat headViewY = likeBtnY ;
    CGFloat headViewWH = TRANSFER_SIZE(30) ;
    
    for (int i = 0; i < 5; i++) {
        UIImageView *headView = self.headViewArray[i] ;
        headView.frame = CGRectMake(headViewX - i*(headViewWH + 10), headViewY, headViewWH, headViewWH) ;
        headView.layer.cornerRadius =  TRANSFER_SIZE(30)/2;
        headView.layer.masksToBounds = YES;
    }
}

- (void)judgeUserPressFavourBtn:(BOOL)hasPraised
{
    if (GlobalObj.isLogin) {
        if (hasPraised == YES) {
            self.likeBtn.selected = YES;
        }else{
            self.likeBtn.selected = NO;
        }
    }else{
        self.likeBtn.selected = NO;
    }
}
#pragma mark - 点击 点赞按钮
- (void)likeBtnClick
{
    if (![[GlobalVar sharedSingleton] isLogin]) {
        // 如果没有登录、先登录
        if ([self.delegate respondsToSelector:@selector(bottomHeadView:didClickLikeBtn:)]) {
            [self.delegate bottomHeadView:self didClickLikeBtn:self.likeBtn] ;
        }
    }else{
        [self getInfoFromServe];
    }
}
- (void)getInfoFromServe
{
    NSString *token = [GlobalVar sharedSingleton].token ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", self.discoverId, @"discoveryId", nil] ;
    [CSHttpTool get:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, DiscoveryPraiseProtocol]
             params:params
            success:^(id responseObj) {
                if ([[responseObj objectForKey:@"code"] integerValue] == ResponseStateSuccess) {
                    NSDictionary *data = responseObj[@"data"];
                    if (data) {
                        NSNumber *praiseCount = data[@"praiseCount"];
                        if (self.praiseBlock) {
                            self.praiseBlock(praiseCount);
                        }
                        [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", [praiseCount intValue]] forState:UIControlStateNormal] ;
                        
                        NSNumber *hasPraised = data[@"hasPraised"];
                        self.likeBtn.selected = [hasPraised boolValue]?YES:NO;
#warning 点赞修改
                        if ([self.delegate respondsToSelector:@selector(bottomHeadViewDidChangePraiseState:)]) {
                            [self.delegate bottomHeadViewDidChangePraiseState:self];
                        }
                    }
                }
            } failure:^(NSError *error) {
                CSLog(@"error = %@", error) ;
            }] ;
}
- (void)setPlayerModel:(CSPlayingModel *)playerModel{
    _playerModel = playerModel ;
    // 清空之前的头像
    for (UIImageView *imgView in self.headViewArray) {
        imgView.image = nil;
    }

    NSInteger headIconCount = playerModel.praiseAvatarUrls.count ;
        if (headIconCount != 0) {
            // playerModel.praiseAvatarUrls 时常为空,可能一个赞的人都没有
            NSInteger minIndex = MIN(headIconCount, self.headViewArray.count) ;
            
            for (int i = 0; i < minIndex; i++) { // 设置前5个点赞用户的头像
                NSString *avatarUrlStr = [playerModel.praiseAvatarUrls[i] objectForKey:@"praiseAvatarUrl"] ;
                UIImageView *headerView = self.headViewArray[i] ;// 取出一个头像
                [headerView sd_setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"mine_default_user_icon"]] ;//当用户没有上传头像，用默认图替换
            }
    }
    // 设置点赞
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@", playerModel.praiseCount] forState:UIControlStateNormal] ;
    
    // 设置点赞按钮状态
#warning 设置点赞按钮状态
    [self judgeUserPressFavourBtn:playerModel.praised];
    
}

- (void)dealloc
{
    CSLog(@"CSBottomHeadView...dealloc") ;
}
@end
