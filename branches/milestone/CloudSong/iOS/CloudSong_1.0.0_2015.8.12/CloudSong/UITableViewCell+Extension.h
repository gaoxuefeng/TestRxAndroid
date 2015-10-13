//
//  UITableViewCell+Extension.h
//  CloudSong
//
//  Created by EThank on 15/6/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Extension)

// 为tableViewCell 设置背景图片
- (void)setBackgroundImage:(UIImage *)image ;
- (void)setBackgroundImageByName:(NSString *)imageName ;

@end
