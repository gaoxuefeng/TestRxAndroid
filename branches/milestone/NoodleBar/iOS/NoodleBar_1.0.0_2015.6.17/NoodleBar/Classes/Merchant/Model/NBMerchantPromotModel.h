//
//  NBMerchantPromotModel.h
//  NoodleBar
//
//  Created by sen on 6/3/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    NBPromotTypeNone,           // 无优惠信息
    NBPromotTypeReduce = 1,     // 满减
    NBPromotTypeNew,            // 新品
    NBPromotTypePromotion,      // 促销
    NBPromotTypeFreeFreight     // 免运费

}NBPromotType;
@interface NBMerchantPromotModel : NSObject
/** 优惠金额 */
@property(nonatomic, copy) NSString *discountmoney;
/** 满足金额 */
@property(nonatomic, copy) NSString *enoughmoney;
/** 优惠类型 */
@property(nonatomic, assign) NBPromotType promottype;
@end
