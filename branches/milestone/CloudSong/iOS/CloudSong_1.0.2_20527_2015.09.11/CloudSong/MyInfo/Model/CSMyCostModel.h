//
//  CSMyCostModel.h
//  CloudSong
//
//  Created by sen on 15/6/16.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    CSMyCostTypeRoom,                       // 包厢订单
    CSMyCostTypeCloudDish,                  // 云酒水订单
    CSMyCostTypeRoomDish                    // 包厢酒水订单

}CSMyCostType;

@interface CSMyCostModel : NSObject
@property(nonatomic, copy) NSString *hours;
@property(nonatomic, copy) NSString *day;
@property(nonatomic, copy) NSString *content;
/** KTV名称 */
@property(nonatomic, copy) NSString *KTVName;
/** 支付状态 */
@property(nonatomic, copy) NSNumber *payState;
/** 包厢结束时间 */
@property(nonatomic, copy) NSString *rbEndTime;
/** 包厢开始时间 */
@property(nonatomic, copy) NSString *rbStartTime;
/** 包厢订单ID */
@property(nonatomic, copy) NSString *reserveBoxId;
/** 酒水订单ID */
@property(nonatomic, copy) NSString *reserveGoodsId;
/** 订单类型 0:包厢订单 1:云端酒水订单 2:包厢酒水订单*/
@property(nonatomic, strong) NSNumber *orderType;

#pragma mark - dishModel
@property(nonatomic, strong) NSArray *goodsList;
@end
