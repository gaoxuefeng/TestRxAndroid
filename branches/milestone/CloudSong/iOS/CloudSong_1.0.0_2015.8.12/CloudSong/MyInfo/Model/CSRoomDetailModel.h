//
//  CSRoomDetailModel.h
//  CloudSong
//
//  Created by sen on 15/7/6.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSRoomDetailModel : NSObject
@property(nonatomic, copy) NSString *ktvName;
@property(nonatomic, copy) NSString *KTVName;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *useName;
@property(nonatomic, copy) NSString *payState;
@property(nonatomic, copy) NSString *phoneNum;
@property(nonatomic, strong) NSNumber *price;
@property(nonatomic, strong) NSString *rbEndTime;
@property(nonatomic, strong) NSString *rbStartTime;
@property(nonatomic, copy) NSString *reserveBoxId;
@property(nonatomic, copy) NSString *roomNum;
@property(nonatomic, copy) NSString *time;
/** 酒水下单时间 */
@property(nonatomic, copy) NSString *orderTime;
//@property(nonatomic, copy) NSString *theme;
@property(nonatomic, strong) NSArray *goodsList;
/** 总消费 */
@property(nonatomic, copy) NSNumber *sumPrice;

@end
