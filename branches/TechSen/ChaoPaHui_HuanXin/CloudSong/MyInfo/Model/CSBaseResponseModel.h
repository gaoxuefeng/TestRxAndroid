//
//  CSBaseResponseModel.h
//  CloudSong
//
//  Created by Ronnie on 15/6/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSBaseResponseModel : NSObject
@property(nonatomic) int code;
@property(nonatomic, copy) NSString *message;
@end
