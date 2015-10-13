//
//  CSSmartSortView.h
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CSSmartSortViewType) {
    CSSmartSortViewTypeSmartSort = 0,
    CSSmartSortViewTypeNearest,
    CSSmartSortViewTypeHottest,
    CSSmartSortViewTypeCheapest,
};

@protocol CSSmartSortViewDelegate;

@interface CSSmartSortView : UIView
@property (nonatomic, weak)id<CSSmartSortViewDelegate> delegate;
@property (nonatomic, strong)NSArray*   data;
@property (nonatomic, assign, readonly)CSSmartSortViewType  type;
- (void)reloadData;
- (void)resetPosition;
@end

@protocol CSSmartSortViewDelegate <NSObject>
- (void)smartSortView:(CSSmartSortView *)view didSelectType:(CSSmartSortViewType)type;
- (void)smartSortViewDidHide:(CSSmartSortView *)view;
@end