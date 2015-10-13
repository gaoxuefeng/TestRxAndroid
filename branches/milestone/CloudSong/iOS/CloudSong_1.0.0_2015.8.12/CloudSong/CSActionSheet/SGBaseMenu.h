//
//  SGBaseMenu.h
//  SGActionView
//
//  Created by Sagi on 13-9-18.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGActionView.h"

#define BaseMenuBackgroundColor(style)  (style == SGActionViewStyleLight ? [[UIColor darkGrayColor] colorWithAlphaComponent:0.7] : [[UIColor grayColor] colorWithAlphaComponent:0.7] )
#define BaseMenuTextColor(style)        (style == SGActionViewStyleLight ? [UIColor colorWithRed:168/255.0 green:168/255.0 blue:165/255.0 alpha:1] : [UIColor colorWithRed:168/255.0 green:168/255.0 blue:165/255.0 alpha:1])
#define BaseMenuActionTextColor(style)  ([UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0])
#define BaseMenuActivityBGColor(style)  ([UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2])


// 自定义下面取消按钮
@interface SGButton : UIButton
@end

// 自定义上面显示内容
@interface SGBaseMenu : UIView{
    SGActionViewStyle _style;
    
}

// if rounded top left/right corner, default is YES.
@property (nonatomic, assign) BOOL roundedCorner;

@property (nonatomic, assign) SGActionViewStyle style;

@end
