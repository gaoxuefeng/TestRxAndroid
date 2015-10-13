//
//  CSBottomHeadView.h
//  CloudSong
//
//  Created by EThank on 15/6/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  底部点赞的用户的头像

#import <UIKit/UIKit.h>
@class CSBottomHeadView ;
@class CSPlayingModel ;

typedef void(^PraiseBlock)(NSNumber * count);

@protocol BottomHeadViewDelegate <NSObject>
@optional
- (void)bottomHeadView:(CSBottomHeadView *)bottomHeadView didClickLikeBtn:(UIButton *)likeBtn ;
- (void)bottomHeadViewDidChangePraiseState:(CSBottomHeadView *)bottomHeadView ;
@end
@interface CSBottomHeadView : UIView

// 传递一个模型
@property (nonatomic, strong) CSPlayingModel *playerModel ;

@property (nonatomic, weak) id <BottomHeadViewDelegate> delegate ;

@property (nonatomic, copy) NSString *discoverId ;
@property (nonatomic,copy) PraiseBlock praiseBlock;

@end
