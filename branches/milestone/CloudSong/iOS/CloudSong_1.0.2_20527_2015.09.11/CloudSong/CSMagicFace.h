//
//  CSMagicFace.h
//  CloudSong
//
//  Created by sen on 8/12/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMagicFace : UIView
/** 魔法表情的文字 */
@property(nonatomic, copy) NSString *text;
/** 魔法表情的图片 */
@property(nonatomic, strong) UIImage *image;

- (void)addTarget:(id)target action:(SEL)sel;

@end
