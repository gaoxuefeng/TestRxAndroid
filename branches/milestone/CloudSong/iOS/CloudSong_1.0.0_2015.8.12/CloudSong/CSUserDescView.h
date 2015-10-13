//
//  CSUserDescView.h
//  CloudSong
//
//  Created by EThank on 15/6/13.
//  Copyright (c) 2015年 ethank. All rights reserved.
//   下面描述用户头像，昵称，分享的View

#import <UIKit/UIKit.h>
@class CSUserDescView ;
@class CSPlayingModel ;

@protocol UserDescViewDelegate <NSObject>
@optional
- (void)userDescView:(CSUserDescView *)userDescView didSelectShareBtnIndex:(NSInteger)index ;

@end

@interface CSUserDescView : UIView

// 传递一个模型
@property (nonatomic, strong) CSPlayingModel *playerModel ;

@property (nonatomic, weak) id <UserDescViewDelegate> delegate ;

@end
