//
//  CSPayTypeCell.h
//  CloudSong
//
//  Created by sen on 5/30/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSDefine.h"
@interface CSPayTypeCell : UIView
- (instancetype)initWithType:(CSPayMethodType)payMethodType;
@property(nonatomic, assign) CSPayMethodType payMethodType;
@property(nonatomic, assign) BOOL selected;
- (void)addTarget:(id)target action:(SEL)action;
@end
