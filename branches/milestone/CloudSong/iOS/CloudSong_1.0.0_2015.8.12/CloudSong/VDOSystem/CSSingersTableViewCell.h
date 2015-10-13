//
//  CSSingersTableViewCell.h
//  CloudSong
//
//  Created by EThank on 15/6/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CSSingersTableViewCellType) {
    CSSingersTableViewCellTypeTop,
    CSSingersTableViewCellTypeMiddle,
    CSSingersTableViewCellTypeBottom,
    CSSingersTableViewCellTypeSingle,
};

@interface CSSingersTableViewCell : UITableViewCell
- (void)setTitle:(NSString *)title;
- (void)setCellType:(CSSingersTableViewCellType)type;
@end
