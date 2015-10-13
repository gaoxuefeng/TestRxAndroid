//
//  CSDishCartTool.m
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDishCartTool.h"

@implementation CSDishCartTool
/**
 *  购物车数组
 */
static NSMutableArray *_dishes;

+ (void)initialize
{
    _dishes = [NSMutableArray array];
}

/**
 *  修改菜
 *
 *  @param dish 菜
 */
+ (void)alterDish:(CSDishModel *)dish
{
    for (CSDishModel *dishModel in _dishes) {
        if ([dishModel.name isEqualToString:dish.name]) { // 如果找到名字 则修改数量
            if (dish.amount == 0) { //如果设置数量为0,则从购物车清除
//                NSInteger index = [_dishes indexOfObject:dishModel];
                [_dishes removeObject:dishModel];
                [self postCartContentChangeNotification];
                return;
            }
            // 否则直接修改数量
            dishModel.amount = dish.amount;
            [self postCartContentChangeNotification];
            return;
        }
    }
    // 否则 购物车增加该道菜
    [_dishes addObject:dish];
    [self postCartContentChangeNotification];
}


+ (void)postCartContentChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CART_CONTENT_CHANGED object:nil];
}


/** 清空购物车 */
+ (void)emptyCart
{
    for (CSDishModel *data in _dishes) {
    data.amount = 0;
}
    [_dishes removeAllObjects];
    [self postCartContentChangeNotification];
}

/** 获取所有菜的数量和 */
+ (int)dishesAmount
{
    NSNumber *count = [_dishes valueForKeyPath:@"@sum.amount"];
    return [count intValue];
}

/** 获取所有购物车中的所有菜 */
+ (NSArray *)dishes
{
    return _dishes;
}

+ (float)totalPrice
{
    float price = 0.0;
    for (CSDishModel *model in _dishes) {
        price += model.amount * model.price;
    }
    return price;
}

+ (BOOL)isEmpty
{
    return _dishes.count?NO:YES;
}
@end
