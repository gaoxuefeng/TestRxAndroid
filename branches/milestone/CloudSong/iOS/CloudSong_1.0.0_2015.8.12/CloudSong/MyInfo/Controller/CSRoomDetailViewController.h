//
//  CSRoomDetailViewController.h
//  CloudSong
//
//  Created by sen on 15/6/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSRoomDetailViewController : CSBaseViewController
- (instancetype)initWithOrderId:(NSString *)orderId;
@property(nonatomic, strong) NSString *orderId;
@end
