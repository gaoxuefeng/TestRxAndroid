//
//  NBAccountDataResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBAccountModel.h"
#import "NBAddressModel.h"
@interface NBAccountDataResponseModel : NSObject
@property(nonatomic, strong) NBAccountModel *account;
@property(nonatomic, strong) NSMutableArray *addresses;
@end
