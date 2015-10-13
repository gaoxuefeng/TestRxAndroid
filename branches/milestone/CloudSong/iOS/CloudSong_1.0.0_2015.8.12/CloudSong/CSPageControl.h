//
//  CSPageControl.h
//  CloudSong
//
//  Created by youmingtaizi on 7/21/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSPageControlDelegate;

@interface CSPageControl : UIView
@property (nonatomic, weak)id<CSPageControlDelegate>  delegate;
@property (nonatomic, assign)NSInteger  numOfPages;
@property (nonatomic, assign)NSInteger  currentPage;
@end

@protocol CSPageControlDelegate <NSObject>
- (void)pageControl:(CSPageControl *)control didSelectIndex:(NSInteger)index;
@end
