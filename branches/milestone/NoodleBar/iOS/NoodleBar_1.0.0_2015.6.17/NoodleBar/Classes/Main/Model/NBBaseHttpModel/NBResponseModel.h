//
//  NBResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBResponseModel : NSObject
@property(nonatomic, assign) int code;
@property(nonatomic, copy) NSString *message;
@end
