//
//  NBTabBarController.m
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBTabBarController.h"
#import "NBCommon.h"
@interface NBTabBarController () <UITabBarControllerDelegate>
{
    UIView *_block;
    NSArray *_tabBarButtons;
}
@end

@implementation NBTabBarController

+ (void)initialize
{
    UITabBar *appearance = [UITabBar appearance];
    
    appearance.tintColor = HEX_COLOR(0xeea300);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.translucent = NO;
    self.delegate = self;
    _block = [[UIView alloc] init];
    _block.backgroundColor = HEX_COLOR(0xeda300);
    [self.tabBar addSubview:_block];
//    NSLog(@"self.tabBar ========== %@",self.tabBar);
    
    NSMutableArray *tabBarButtonsM = [NSMutableArray arrayWithCapacity:3];
    for (UIView *subView in self.tabBar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonsM addObject:subView];
            continue;
        }
    }
    
    _tabBarButtons = [tabBarButtonsM sortedArrayUsingComparator:^NSComparisonResult(UIView *p1, UIView *p2){
        return [[NSNumber numberWithFloat:p1.centerX] compare:[NSNumber numberWithFloat:p2.centerX]];
    }];
    

    _block.size = CGSizeMake(35.0, 4.0);
    _block.y = self.tabBar.height - _block.height;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *tabBarButton = _tabBarButtons[0];
    _block.centerX = tabBarButton.centerX;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    UIView *tabBarButton = _tabBarButtons[selectedIndex];
    _block.centerX = tabBarButton.centerX;
}



#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UIView *tabBarButton = _tabBarButtons[self.selectedIndex];
    [UIView animateWithDuration:0.2 animations:^{
       _block.centerX = tabBarButton.centerX;
    }];
}

@end
