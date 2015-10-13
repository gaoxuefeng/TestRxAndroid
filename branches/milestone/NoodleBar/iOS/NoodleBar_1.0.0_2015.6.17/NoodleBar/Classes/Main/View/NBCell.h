//
//  NBCell.h
//  NoodleBar
//
//  Created by sen on 15/4/17.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void (^optionBlcok)();

@interface NBCell : UIView
/**
 *  the bottomDividerLine default is hidden
 */
@property(nonatomic, assign,getter=isShowBottomDivider) BOOL showBottomDivider;
@property(nonatomic, assign,getter=isTextCenterHorizontally) BOOL textCenterHorizontally;
- (void)setText:(NSString *)text withColor:(UIColor *)color Font:(UIFont *)font;
- (void)setText:(NSString *)text;
- (void)setImage:(UIImage *)image;
- (NSString *)text;
/**
 *  定义block保存将来要执行的代码
 */
@property (nonatomic, copy) optionBlcok option;
@end
