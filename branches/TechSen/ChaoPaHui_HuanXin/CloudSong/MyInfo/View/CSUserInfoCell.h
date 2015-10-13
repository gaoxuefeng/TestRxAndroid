//
//  CSUserInfoCell.h
//  CloudSong
//
//  Created by sen on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSInteger default_max_length = 20;
typedef NS_ENUM(NSInteger, CSUserInfoCellType){
    CSUserInfoCellTypeIcon,
    CSUserInfoCellTypeNickName,
    CSUserInfoCellTypeGender,
    CSUserInfoCellTypeAge,
    CSUserInfoCellTypeCon,
    CSUserInfoCellTypeBloodType,
    CSUserInfoCellTypeFavoriteSinger,
    CSUserInfoCellTypeFavoriteSong,
    CSUserInfoCellTypeSignature
};
@class CSUserInfoCell;
@protocol CSUserInfoCellDelegate <NSObject>

@optional
- (void)userInfoCellDidLostFocusWithString:(NSString *)string;

@end


@interface CSUserInfoCell : UIView
- (instancetype)initWithTitle:(NSString *)title;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *placeHolder;
@property(nonatomic, copy) NSString *subTitle;
@property(nonatomic, weak) UILabel *subTitleLabel;
@property(strong, nonatomic) UIImageView *userIconView;
@property(weak, nonatomic) UITextField *nickNametextField;
@property(weak, nonatomic) id<CSUserInfoCellDelegate> delegate;
- (void)addTarget:(id)target action:(SEL)action;
@end
