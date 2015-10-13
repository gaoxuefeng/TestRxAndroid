//
//  NBOrderList.m
//  NoodleBar
//
//  Created by sen on 15/5/4.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderList.h"
#import "NBCommon.h"
@implementation NBOrderList



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = HEX_COLOR(0xf3f3f3);
        self.rowHeight = 126.f;
        
//        // 无订单提示
//        UIView *bgView = [[UIView alloc] init];
//        UIImageView *noOrderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_empty"]];
//        [bgView addSubview:noOrderImageView];
//        [noOrderImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [noOrderImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:AUTOLENGTH(90.f)];
//        UILabel *noOrderWarning = [[UILabel alloc] init];
//        [bgView addSubview:noOrderWarning];
//        noOrderWarning.textAlignment = NSTextAlignmentCenter;
//        noOrderWarning.text = @"现在还没有订单,赶紧点一份!";
//        noOrderWarning.font = [UIFont systemFontOfSize:15.f];
//        noOrderWarning.textColor = UICOLOR_FROM_HEX(0xc0c0c0);
//        [noOrderWarning autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [noOrderWarning autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noOrderImageView withOffset:AUTOLENGTH(60.f)];
//        self.backgroundView = bgView;
//        self.backgroundView.hidden = YES;
    }
    return self;
}

@end
