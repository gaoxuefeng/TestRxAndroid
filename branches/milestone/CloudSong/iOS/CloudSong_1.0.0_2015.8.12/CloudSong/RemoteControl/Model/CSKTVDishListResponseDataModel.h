//
//  CSKTVDishListResponseDataModel.h
//  CloudSong
//
//  Created by sen on 15/7/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSKTVDishListResponseDataModel : NSObject
@property(nonatomic, strong) NSArray *goodsList;
@property(nonatomic, copy) NSString *reserveGoodsId;
@property(nonatomic, strong) NSNumber *sumPrice;
@property(nonatomic, copy) NSString *roomName;
@end
