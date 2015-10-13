//
//  QuickMarkImageVIew.h
//  CloudSong
//
//  Created by Ethank on 15/8/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickMarkImageVIew : UIView
{
    UIView *        _bgView;
    UILabel *       _titleLabel;
    UIImageView *   _quickMarkImg;
    UILabel *       _tipLabel;
    UITapGestureRecognizer * tapGesture;
}
- (instancetype)initWithTitle:(NSString *)titleStr image:(UIImage *)image tip:(NSString*)tipStr;
- (void)show;
@end
