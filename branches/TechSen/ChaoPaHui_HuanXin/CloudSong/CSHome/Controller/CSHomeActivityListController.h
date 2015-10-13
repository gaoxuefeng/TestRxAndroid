//
//  CSHomeActivityListController.h
//  CloudSong
//
//  Created by EThank on 15/7/28.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSDefine.h"
#import "CSHomeActivityTagModel.h"

@interface CSHomeActivityListController : CSBaseViewController
//@property (nonatomic, copy) NSString *titleName ;
//@property (nonatomic, assign)CSHomeActivityType activityType ;
@property (nonatomic, strong) CSHomeActivityTagModel *activityTagModel ;
@end
