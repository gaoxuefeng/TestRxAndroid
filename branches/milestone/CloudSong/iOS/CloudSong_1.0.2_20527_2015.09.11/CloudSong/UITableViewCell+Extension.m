//
//  UITableViewCell+Extension.m
//  CloudSong
//
//  Created by EThank on 15/6/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)

- (void)setBackgroundImageByName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName] ;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image] ;
    imageView.alpha = 0.4 ;
    imageView.contentMode = UIViewContentModeScaleToFill ;
    self.backgroundView = imageView ;
}

- (void)setBackgroundImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image] ;
    imageView.contentMode = UIViewContentModeScaleToFill ;
    imageView.alpha = 0.4 ;
    self.backgroundView = imageView ;
}

@end
