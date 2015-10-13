//
//  CSOrderPayCellHeaderView.h
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSOrderPayCellHeaderView : UIView
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subTitle;
@property(nonatomic, assign,getter=isHiddenDivider) BOOL hiddenDivider;
@end
