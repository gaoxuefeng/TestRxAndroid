//
//  NBOrderDetailJsonString.h
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBOrderDetailJsonString : NSObject
@property(nonatomic, copy) NSString *dishid;
@property(nonatomic, copy) NSString *unitprice;
@property(nonatomic, copy) NSString *dishtype;
@property(nonatomic, assign) int dishnum;
@property(nonatomic, copy) NSString *dishname;
@property(nonatomic, copy) NSString *starttime;
@property(nonatomic, copy) NSString *getdishtime;
@end
