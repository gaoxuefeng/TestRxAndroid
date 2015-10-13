//
//  NBCartTool.m
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBCartTool.h"
#import "NBCommon.h"
@implementation NBCartTool
/**
 *  购物车数组
 */
static NSMutableArray *_dishes;

static NSArray *_promots;

static NBMerchantPromotModel *_promot;
+ (void)initialize
{
    _dishes = [NSMutableArray array];
}

/**
 *  修改菜
 *
 *  @param dish 菜
 */
+ (void)alterDish:(NBDishModel *)dish
{
    
    for (NBDishModel *dishModel in _dishes) {
        if ([dishModel.dishID isEqualToString:dish.dishID]) { // 如果找到名字 则修改数量
            if (dish.amount == 0) {
//                NSInteger index = [_dishes indexOfObject:dishModel];
                [_dishes removeObject:dishModel];
//                [self postCartContentChangedNotification];
//                [[NSNotificationCenter defaultCenter] postNotificationName:CART_CONTENT_CHANGED object:[NSNumber numberWithInteger:index]];
                if (_dishes.count == 0) { // 如果无菜,则清空优惠
                    _promot = nil;
                }
                [self postCartContentChangedNotification];
                return;
            }
            dishModel.amount = dish.amount;
            [self postCartContentChangedNotification];
            return;
        }
    }
    // 否则 购物车增加该道菜
    [_dishes addObject:dish];
    [self postCartContentChangedNotification];
}



/**
 *  清空购物车
 */
+ (void)emptyShoppingCart
{
    for (NBDishModel *data in _dishes) {
        data.amount = 0;
    }
    [_dishes removeAllObjects];
    _promot = nil;
    [self postCartContentChangedNotification];
    
}

+ (void)postCartContentChangedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CART_CONTENT_CHANGED object:nil];
}



/**
 *  获取所有购物车中的所有菜
 *
 *  @return 然会菜数组
 */
+ (NSArray *)dishes
{
    return _dishes;
}

/**
 *  获取所有菜的数量和
 *
 *  @return 返回菜的数量和
 */
+ (int)dishesCount
{
    NSNumber *count = [_dishes valueForKeyPath:@"@sum.amount"];
    return [count intValue];
}


+ (float)dishesPrice
{
    float price = 0.f;
    for (NBDishModel *data in _dishes) {
        price += data.amount * data.price;
    }
    if (_promots) {
        for (int i = 0; i < _promots.count; i++) {
            NBMerchantPromotModel *promot = _promots[i];
            if (price >= [promot.enoughmoney floatValue]) { // 如果满足
                price -= [promot.discountmoney floatValue];
                _promot = promot;
                break;
            }
            if (i == _promots.count - 1) {
                _promot = nil;
            }
        }
    }
    return price;
}

+ (float)originalPrice
{
    float price = 0.f;
    for (NBDishModel *data in _dishes) {
        price += data.amount * data.price;
    }
    return price;
}

/**
 *  设置优惠规则数组
 */
+ (void)setPromots:(NSArray *)promots
{
    _promots = [promots sortedArrayUsingComparator:^NSComparisonResult(NBMerchantPromotModel *p1, NBMerchantPromotModel *p2){
        return [[NSNumber numberWithFloat:[p1.enoughmoney floatValue]] compare:[NSNumber numberWithFloat:[p2.enoughmoney floatValue]]]  ==  NSOrderedAscending;
    }];
    
}

+ (NBMerchantPromotModel *)promot
{
    return _promot;
}

@end
