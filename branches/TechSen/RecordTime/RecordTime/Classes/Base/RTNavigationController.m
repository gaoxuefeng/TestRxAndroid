//
//  RTNavigationController.m
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTNavigationController.h"
#import "Header.h"
@implementation RTNavigationController

+ (void)initialize
{
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:@"GillSans-Light" size:20] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor lightTextColor]];
    [[UINavigationBar appearance] setBarTintColor:MAIN_BG_COLOR];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
}

@end
