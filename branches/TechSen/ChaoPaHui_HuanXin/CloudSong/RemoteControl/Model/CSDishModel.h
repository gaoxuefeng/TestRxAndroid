//
//  CSDishModel.h
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSDishModel : NSObject
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, assign) float price;
@property(nonatomic, assign) NSInteger amount;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *gUnit;
@end
