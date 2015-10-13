//
//  CSKTVModel.h
//  CloudSong
//
//  Created by youmingtaizi on 5/5/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CSKTVModel : NSObject

@property (nonatomic, strong)NSString* BLDKTVId;
@property (nonatomic, strong)NSString* KTVName;
@property (nonatomic, strong)NSString* address;
@property (nonatomic, strong)NSString* circleName;
/**
 *  团：1 << 0
 *  促：1 << 1
 *  卡：1 << 2
 *  惠：1 << 3
 */
@property (nonatomic, strong)NSNumber*  discountIconMeg;
@property (nonatomic, strong)NSString*  discountMeg;
@property (nonatomic, strong)NSNumber*  distance;
@property (nonatomic, strong)NSString*  imageUrl;
@property (nonatomic, strong)NSNumber*  isBLD;
@property (nonatomic, strong)NSString*  phoneNum;
@property (nonatomic, strong)NSNumber*  price;
@property (nonatomic, strong)NSNumber*  rating;
@property (nonatomic, strong)NSString*  shopUrl;
@property (nonatomic, strong)NSArray*   imageUrlList;
@property (nonatomic, strong)NSString*  businessHoursStart;
@property (nonatomic, strong)NSString*  businessHoursEnd;
@property (nonatomic, strong)NSNumber*  lat;
@property (nonatomic, strong)NSNumber*  lng;
@end
