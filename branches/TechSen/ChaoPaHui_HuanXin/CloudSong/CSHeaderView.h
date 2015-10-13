//
//  CSHeaderView.h
//  CloudSong
//
//  Created by Ethank on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSFindThemeModel;
@interface CSHeaderView : UICollectionReusableView
@property (nonatomic ,strong)UIScrollView * scrollView;
@property (nonatomic ,strong)UIImageView * photoView;
@property (nonatomic,copy) CSFindThemeModel * themeModel;
@end
