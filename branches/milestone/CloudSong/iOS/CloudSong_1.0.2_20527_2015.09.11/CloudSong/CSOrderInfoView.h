//
//  CSOrderInfoView.h
//  CloudSong
//
//  Created by sen on 15/6/22.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSOrderInfoViewCell : UIView
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subTitle;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *subTitleLabel;
@property(nonatomic, assign,getter=isHiddenBottomLine) BOOL hiddenBottomLine;

- (instancetype)initWithTitle:(NSString *)title;
@end
@class CSKTVBookingOrder;

@interface CSOrderInfoView : UIView
@property (nonatomic, strong)CSKTVBookingOrder *item;
@end
