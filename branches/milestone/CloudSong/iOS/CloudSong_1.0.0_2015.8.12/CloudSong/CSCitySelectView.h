//
//  CSCitySelectView.m.h
//  CloudSong
//
//  Created by youmingtaizi on 5/18/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSCitySelectViewDelegate;

@interface CSCitySelectView : UIView
@property (nonatomic, weak)id<UITableViewDataSource>  dataSource;
@property (nonatomic, weak)id<UITableViewDelegate>  delegate;
@property (nonatomic, weak)id<UICollectionViewDataSource>  collectionViewDataSource;
@property (nonatomic, weak)id<UICollectionViewDelegate>  collectionViewDelegate;
@property (nonatomic, assign)id<CSCitySelectViewDelegate>  locationDelegate;

@property (nonatomic, weak)id <CSCitySelectViewDelegate>searchDelegate ;
- (void)reloadData;
- (void)hideKeyboard;
@end

@protocol CSCitySelectViewDelegate <NSObject>
- (void)citySelectViewDidPressLocationBtn:(CSCitySelectView *)view;

// 点击搜索结果的某一行
- (void)citySelectViewWillSearchCity:(NSString *)selectCity ;
@end