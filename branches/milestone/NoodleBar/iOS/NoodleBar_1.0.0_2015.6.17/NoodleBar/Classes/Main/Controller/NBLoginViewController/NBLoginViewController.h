//
//  NBLoginViewController.h
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBViewController.h"
typedef void (^LoginBlock)(BOOL loginSuccess);
@interface NBLoginViewController : NBViewController
@property (nonatomic, copy) LoginBlock loginBlock;



@end
