//
//  CSCollectionHeaderView.h
//  CloudSong
//
//  Created by EThank on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSDefine.h"

@class CSCollectionHeaderView ;

@protocol CollectionHeaderViewDelegate <NSObject>

@optional

/**
 *  响应collectionHeaderView中的进入房间按钮的点击
 */
- (void)collectionHeaderView:(CSCollectionHeaderView *)headerView didClickRoomBtn:(UIButton *)roomButton ;

/**
 *  响应collectionHeaderView中的进入房间按钮的点击
 */
- (void)collectionHeaderView:(CSCollectionHeaderView *)headerView didTapViewWithType:(CSHomeActivityType )viewType ;

@end

@interface CSCollectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id <CollectionHeaderViewDelegate> delegate ;

// 设置进入包厢按钮的文字，显示当前房间号
@property (nonatomic, copy) NSString *roomBtnTitle ;
@property (nonatomic, copy) NSString *descInfo ;

- (void)headerViewAnimateWithTimeInterval:(NSTimeInterval)interval ;

@end
