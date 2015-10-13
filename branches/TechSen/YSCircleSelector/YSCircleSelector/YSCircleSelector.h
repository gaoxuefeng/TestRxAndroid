//
//  YSCircleSelector.h
//  YSCircleSelector
//
//  Created by sen on 15/6/1.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCircleSelectorItem : NSObject
/** 当被选中时展示在圆形中间的图片 */
@property(nonatomic, strong) UIImage *centerImage;
/** 在圆边上的图片 */
@property(nonatomic, strong) UIImage *aroundImage;
/** 在圆边上的高亮的图片 */
@property(nonatomic, strong) UIImage *highlightAroundImage;
/** 被选中时的标题 */
@property(nonatomic, copy) NSString *title;
@end



@interface YSCircleSelector : UIView
- (instancetype)initWithCircleSelectorItems:(NSArray *)items;
@end
