//
//  RTViewController.m
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTViewController.h"

@implementation RTViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_BG_COLOR;
}


- (void)dealloc
{
    RTLog(@"当前控制器挂了");
}
@end
