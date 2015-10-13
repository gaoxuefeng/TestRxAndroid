//
//  NBMerchantModel.h
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBMerchantPromotModel.h"
@interface NBMerchantModel : NSObject
/** 商户ID */
@property(nonatomic, copy) NSString *businessid;
/** 商户名称 */
@property(nonatomic, copy) NSString *name;
/** 商户地址 */
@property(nonatomic, copy) NSString *address;
/** 商户联系号码 */
@property(nonatomic, copy) NSString *phonenum;
/** 商户图片 */
@property(nonatomic, copy) NSString *pictureuri;
/** 商户营业时间 */
@property(nonatomic, copy) NSString *bussinesstime;
/** 商户介绍 */
@property(nonatomic, copy) NSString *brief;
/** 广告 */
@property(nonatomic, copy) NSString *aduri;
/** 商户评分 */
@property(nonatomic, copy) NSString *level;
/** 是否营业 */
@property(nonatomic, assign) BOOL available;

#pragma mark - 新增/** 月销量 */
@property(nonatomic, copy) NSString *monthordernum;
/** 起送价 */
@property(nonatomic, copy) NSString *startprice;
/** 运费 */
@property(nonatomic, copy) NSString *packingfee;
/** 送达时间 */
@property(nonatomic, copy) NSString *deliverytime;

@property(nonatomic, strong) NSMutableArray *promots;

@end
