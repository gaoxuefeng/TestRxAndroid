//
//  NBOrderModel.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderModel.h"
#import "NBDishModel.h"
#import <MJExtension.h>
#import "NBDateTool.h"
#import "NSDate+YS.h"
@implementation NBOrderModel

//+ (NSDictionary *)objectClassInArray
//{
//    return @{@"dishes":[NBDishModel class]};
//}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"orderID":@"orderid",@"orderTime":@"ordertime",@"price":@"money",@"status":@"orderstatus",@"merchant":@"businessname",@"merchantID":@"businessid",@"payMethod":@"paytype",@"merchantImage":@"picurl",@"phone":@"phonenum",@"takeCode":@"queueid"};
}
- (void)setOrderTime:(NSString *)orderTime
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[orderTime doubleValue] / 1000];
    _orderTime = [[NBDateTool dateFormatter] stringFromDate:date];
    if ([date isToday]) {
        _autoOrderTime = [NSString stringWithFormat:@"今天 %@",[date timeString]];
    }else if ([date isYesterday])
    {
        _autoOrderTime = [NSString stringWithFormat:@"昨天 %@",[date timeString]];
    }else
    {
        _autoOrderTime = [[NBDateTool dateFormatter] stringFromDate:date];
    }
}



- (void)setPromotdetail:(NSString *)promotdetail
{
    _promotdetail = promotdetail;
    if (!_promot) {
        NBMerchantPromotModel *promot = [[NBMerchantPromotModel alloc] init];
        NSRange reduceStrRange = [promotdetail rangeOfString:@"减"];
        NSString *enoughmoney = [promotdetail substringWithRange:NSMakeRange(1, reduceStrRange.location - 1)];
        NSString *discountmoney = [promotdetail substringFromIndex:reduceStrRange.location + 1];
        NBPromotType promottype = NBPromotTypeReduce;
        
        promot.enoughmoney = enoughmoney;
        promot.discountmoney = discountmoney;
        promot.promottype = promottype;
        _promot = promot;
    }
    
}


@end
