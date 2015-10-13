//
//  CSFavoriteUserInfoViewController.h
//  CloudSong
//
//  Created by sen on 15/6/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"

typedef enum
{
    CSFavoriteUserInfoViewControllerTypeSinger,
    CSFavoriteUserInfoViewControllerTypeSong,
    CSFavoriteUserInfoViewControllerTypeSignature
}CSFavoriteUserInfoViewControllerType;
@interface CSFavoriteUserInfoViewController : CSBaseViewController
- (instancetype)initWithType:(CSFavoriteUserInfoViewControllerType)type;
@end
