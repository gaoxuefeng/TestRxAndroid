//
//  CSSubmitDishOrderResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/2.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"

@interface CSSubmitDishOrderResponseModel : CSBaseResponseModel
@property(nonatomic, strong) NSArray *goodsList;
@property(nonatomic, copy) NSString *reserveGoodsId;
@property(nonatomic, strong) NSNumber *sumPrice;
@end
