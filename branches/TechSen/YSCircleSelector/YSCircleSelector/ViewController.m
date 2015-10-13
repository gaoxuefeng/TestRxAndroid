//
//  ViewController.m
//  YSCircleSelector
//
//  Created by sen on 15/6/1.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "ViewController.h"
#import "YSCircleSelector.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i<5; i++) {
        YSCircleSelectorItem *item = [[YSCircleSelectorItem alloc] init];
        [array addObject:item];
    }
    YSCircleSelector *selector = [[YSCircleSelector alloc] initWithCircleSelectorItems:array];
    [self.view addSubview:selector];
    
    selector.frame = CGRectMake(0, 100, 320, 320);
    [self.view addSubview:selector];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
