//
//  CSRoomDetailViewController.h
//  CloudSong
//
//  Created by sen on 15/6/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
typedef void (^payStatusChanged)(CSMyCostStatusType payStatus);

@interface CSRoomDetailViewController : CSBaseViewController

- (instancetype)initWithOrderId:(NSString *)orderId;
@property(nonatomic, strong) NSString *orderId;
@property(copy, nonatomic) payStatusChanged payStatusChanged;
@end
