//
//  CSActivityViewController.m
//  CloudSong
//
//  Created by 汪辉 on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSActivityViewController.h"
#import "WMPageController.h"
#import "CSDataService.h"
#import "CSActivityModel.h"
#import "ActivityCityView.h"
#import "CSNavigationController.h"
#import "CSDefine.h"
#import "CSActivityStyleViewController.h"
@interface CSActivityViewController ()
{
    ActivityCityView * _cityView;
    UIButton * cityBut;
    NSMutableArray * _cityArray;
    WMPageController * pageController;

}
@end

@implementation CSActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark 创建pageC<活动页>
- (void)creatPageController{
    if (pageController==nil) {
        [[CSDataService sharedInstance]asyncGetActivityTag:^(NSArray *Acitivity) {
            _cityArray = [NSMutableArray arrayWithObjects:@"全部", nil];
            for (CSActivityModel * activity in Acitivity) {
                [_cityArray addObject:activity.tagName];
            }
            UITabBarController *tabBarController = (UITabBarController *)self.parentViewController.parentViewController;
            //替换SB添加的活动控制器
            NSArray * tabBarArray = tabBarController.childViewControllers;
            pageController = [self getPageController];
            CSNavigationController * NC = [tabBarArray objectAtIndex:2];
            NSArray * NCArray =  NC.childViewControllers;
            NSMutableArray * NCMutableArray = [NSMutableArray arrayWithArray:NCArray];
            [NCMutableArray removeAllObjects];
            [NCMutableArray addObject:pageController];
            NC.viewControllers=[NSArray arrayWithArray:NCMutableArray];
            
        }];

    }
    
}
- (WMPageController *)getPageController{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < _cityArray.count; i++) {
        Class vcClass;
        NSString *title;
        vcClass = [CSActivityStyleViewController class];
        title = _cityArray[i];
        [viewControllers addObject:vcClass];
        [titles addObject:title];
    }
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.pageAnimatable = YES;
    pageVC.menuViewStyle=WMMenuViewStyleLine;
    pageVC.menuItemWidth = SCREENWIDTH/6;
    pageVC.titleSizeNormal =13;
    pageVC.titleSizeSelected =13;
    pageVC.titleColorNormal =[UIColor whiteColor];
    pageVC.titleColorSelected =HEX_COLOR(0Xe20399);
    
    NSString *imageName = nil;
    if (iPhone4 || iPhone5) {
        imageName = @"nav_bg_5";
    }else if (iPhone6)
    {
        imageName = @"nav_bg_6";
    }else if (iPhone6Plus)
    {
        imageName = @"nav_bg_6p";
    }
    
    pageVC.menuBGColor =[UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
    pageVC.postNotification = YES;
    return pageVC;
}

- (void)viewWillAppear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creatPageController) name:NET_WORK_REACHABILITY object:nil];
    //创建pageConroller <活动>
    [self creatPageController];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
