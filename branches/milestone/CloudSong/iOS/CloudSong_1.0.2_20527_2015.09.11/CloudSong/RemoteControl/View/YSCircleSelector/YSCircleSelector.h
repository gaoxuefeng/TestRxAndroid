//
//  YSCircleSelector.h
//  YSCircleSelector
//
//  Created by sen on 15/6/1.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCircleSelectorItem : NSObject
/** 当被选中时展示在中间的圆形图片 */
@property(nonatomic, strong) UIImage *centerCircleImage;
/** 当被选中时展示在圆形中间的图片 */
@property(nonatomic, strong) UIImage *centerImage;
/** 在圆边上的图片 */
@property(nonatomic, strong) UIImage *aroundImage;
/** 在圆边上的高亮的图片 */
@property(nonatomic, strong) UIImage *highlightAroundImage;
/** 被选中时的标题 */
@property(nonatomic, copy) NSString *title;
/** 背景图 */
@property(nonatomic, strong) UIImage *backgroundImage;
/** 确认按钮背景色 如果不传 则默认取centerCircleImage中心点颜色*/
@property(nonatomic, strong) UIColor *confirmColor;
@end

@class YSCircleSelector;
@protocol YSCircleSelectorDelegate <NSObject>

@optional
- (void)circleSelector:(YSCircleSelector *)circleSelector itemDidPickUp:(YSCircleSelectorItem *)item;

- (void)circleSelectorDidClosed;

@end


@interface YSCircleSelector : UIView
@property(nonatomic, weak) id<YSCircleSelectorDelegate> delegate;
/** 背景图 默认为空,如果设置背景图,则item中的背景图切换将失效 */
@property(nonatomic, strong) UIImage *backgroundImage;

- (instancetype)initWithCircleSelectorItems:(NSArray *)items;



/** 展开 */
- (void)spread;

///** 收缩 */
//- (void)shrink;

@end
