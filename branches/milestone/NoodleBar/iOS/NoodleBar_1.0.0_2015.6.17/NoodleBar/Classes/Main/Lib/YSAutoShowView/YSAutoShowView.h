//
//  YSAutoShowView.h
//  YSAutoShowView
//
//  Created by Sen on 15/3/23.
//  Copyright (c) 2015年 Sen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSAutoShowView : UIView
/**
 *  对象数组
 */
@property (strong, nonatomic) NSArray *items;


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;
@end
