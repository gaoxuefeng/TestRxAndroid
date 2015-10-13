//
//  NBGetMerchantAdResponseDataModel.h
//  NoodleBar
//
//  Created by sen on 6/2/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBMerchantPromotModel.h"
#import "NBMerchantPictureModel.h"
@interface NBGetMerchantAdResponseDataModel : NSObject
@property(nonatomic, strong) NSArray *pictureurlList;
@property(nonatomic, strong) NSArray *promots;
@end
