//
//  CSSongListTableViewController.h
//  CloudSong
//
//  Created by youmingtaizi on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseTableViewController.h"

@class CSRecommendedAlbum;

typedef NS_ENUM(NSInteger, CSSongListTableViewControllerType) {
    CSSongListTableViewControllerTypeLanguage = 0,
    CSSongListTableViewControllerTypeCategory,
    CSSongListTableViewControllerTypeNewSong,
    CSSongListTableViewControllerTypeHotList,
    CSSongListTableViewControllerTypeAllSingingMore,
    CSSongListTableViewControllerTypeRecommendedAlbum,
    CSSongListTableViewControllerTypeSinger,
};

@interface CSSongListTableViewController : CSBaseTableViewController
@property (nonatomic, assign)NSInteger                          languageType;
@property (nonatomic, assign)NSInteger                          categoryType;
@property (nonatomic, assign)CSSongListTableViewControllerType  type;
@property (nonatomic, strong)CSRecommendedAlbum*                album;
@property (nonatomic, strong)NSString*  singerID;
@property (nonatomic, assign)BOOL isSeach;
@end
