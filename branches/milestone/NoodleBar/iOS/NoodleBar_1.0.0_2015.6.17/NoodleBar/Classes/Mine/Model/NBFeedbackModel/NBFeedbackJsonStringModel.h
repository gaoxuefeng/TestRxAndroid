//
//  NBFeedbackJsonStringModel.h
//  NoodleBar
//
//  Created by sen on 15/5/7.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBFeedbackJsonStringModel : NSObject
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *appver;
@property(nonatomic, copy) NSString *did;
@property(nonatomic, copy) NSString *t_time;
@end
