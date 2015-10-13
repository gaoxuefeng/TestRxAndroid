//
//  NBLoginResponseDataModel.h
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBLoginResponseDataModel : NSObject
@property(nonatomic, copy) NSString *userid;
@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *sendtime;
@property(nonatomic, copy) NSString *sendmobile;
@property(nonatomic, copy) NSString *token;
@end
