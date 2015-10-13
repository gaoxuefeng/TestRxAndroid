//
//  NBMenuView.h
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    NBMenuViewMoveTypeUp, // 上移
    NBMenuViewMoveTypeDown // 下移
}NBMenuViewMoveType;

@protocol NBMenuViewDelegate <NSObject>
@optional
- (void)menuViewshouldMove:(NBMenuViewMoveType)moveType;

@end


@interface NBMenuView : UIView
/**
 *  全部分类按钮点击
 */
- (void)totalCategoryBtnClick;

@property(nonatomic, weak) id<NBMenuViewDelegate> delegate;

@property(nonatomic, strong) NSMutableArray *dishesData;

- (void)reload;

@end
