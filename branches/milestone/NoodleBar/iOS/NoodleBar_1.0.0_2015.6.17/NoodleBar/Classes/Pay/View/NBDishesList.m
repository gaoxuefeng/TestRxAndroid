//
//  NBDishesList.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBDishesList.h"
#import "NBCommon.h"
@implementation NBDishesList


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        self.backgroundColor = HEX_COLOR(0xf3f3f3);
//        self.bounces = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = 39.5f;
    }
    return self;
    
}
@end
