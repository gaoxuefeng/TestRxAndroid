//
//  CSUserIconContainer.m
//  CloudSong
//
//  Created by sen on 15/7/2.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSUserIconContainer.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "CSDefine.h"
@implementation CSUserIconContainer




- (void)setItems:(NSArray *)items
{
    _items = items;
    
    NSInteger col = 6;
    if (iPhone6) {
        col = 7;
    }else if (iPhone6Plus)
    {
        col = 8;
    }
    
    NSInteger itemCount = items.count;
    CGFloat radius = 16.5;
    CGSize iconSize = CGSizeMake(2 * radius, 2 * radius);
    CGFloat margin = radius * 2 + 12;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < itemCount; i++) {
        NSString *imageUrl = items[i];
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.layer.cornerRadius = radius;
        iconView.layer.masksToBounds = YES;
        [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == itemCount - 1) // 最后一个
            {
                make.bottom.equalTo(iconView.superview);
            }
            
            if (itemCount < col) { // 如果总数小于 最大列数
                if (i == itemCount - 1) // 最后一个
                {
                    make.right.equalTo(iconView.superview);
                }
                
            }else
            {
                if ((i / col == 0) && (i % col == col - 1)) {
                    make.right.equalTo(iconView.superview);
                }
            }
            

            
            make.left.equalTo(iconView.superview).offset(margin * (i % col));
            make.top.equalTo(iconView.superview).offset(margin * (i / col));
            make.size.mas_equalTo(iconSize);
        }];
    }
    
}


@end
