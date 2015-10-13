//
//  CSActivityStyleViewController.h
//  CloudSong
//
//  Created by 汪辉 on 15/7/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSLocationService.h"

@interface CSActivityStyleViewController : UIViewController<CSLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end