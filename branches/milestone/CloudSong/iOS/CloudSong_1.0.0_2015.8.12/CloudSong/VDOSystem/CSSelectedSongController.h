//
//  CSSelectedSongController.h
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSSelectedSongController : NSObject
@property (nonatomic, strong, readonly)UITableView*  tableView;
- (void)refreshData;
@end
