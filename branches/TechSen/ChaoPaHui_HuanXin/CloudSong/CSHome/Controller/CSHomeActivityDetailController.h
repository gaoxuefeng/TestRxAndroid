//
//  CSThemeDetailViewController.h
//  CloudSong
//
//  Created by EThank on 15/7/22.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSHomeActivityDetailController : CSBaseViewController

// 一些分享的信息
@property (nonatomic, copy) NSString *shareTitle ;
@property (nonatomic, copy) NSString *shareContent ;
@property (nonatomic, strong) UIImage *shareImage ;
@property (nonatomic, strong)NSString * htmlUrl;

@property (weak, nonatomic) UIWebView *webView ;

- (void)setupSubviewsWithUrl:(NSString *)strUrl ;
@end
