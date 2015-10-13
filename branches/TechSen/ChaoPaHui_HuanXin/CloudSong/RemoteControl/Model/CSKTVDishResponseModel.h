//
//  CSKTVDishResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSKTVDishResponseModel : NSObject
@property(nonatomic, assign) float price;
@property(nonatomic, assign) NSInteger amount;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *gUnit;
@property(nonatomic, copy) NSString *imgUrl;
@end
