//
//  CSThemeDetailViewController.h
//  CloudSong
//
//  Created by Ethank on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
typedef void(^pressIntoBanner)(BOOL flag);
@interface CSThemeDetailViewController : CSBaseViewController
@property (nonatomic, strong)NSString * titleStr;
@property (nonatomic, strong)NSString * specialId;
@property (nonatomic, copy)pressIntoBanner pressIntoBannerBlock;
@end
