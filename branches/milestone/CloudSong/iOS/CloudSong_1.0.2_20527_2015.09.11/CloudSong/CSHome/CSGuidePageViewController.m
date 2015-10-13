//
//  CSGuidePageViewController.m
//  CloudSong
//
//  Created by EThank on 15/8/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSGuidePageViewController.h"
#import "CSDefine.h"

#define GUIDE_PAGE_COUNT 4

@interface CSGuidePageViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView ;
@end

@implementation CSGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView] ;
}

- (void)setupSubView{
   // 添加UISrollView
    
    NSString *imageNameTemp = nil ;
    if (iPhone4) {
        imageNameTemp = @"4s-";
    }else if (iPhone5){
        imageNameTemp = @"5s-";
    }else if (iPhone6) {
        imageNameTemp = @"6-";
    }else if (iPhone6Plus){
        imageNameTemp = @"6p-";
    }

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView ;
    
    CGFloat imageW = SCREENWIDTH ;
    CGFloat imageH = SCREENHEIGHT ;
    NSString *imageName = nil ;
    
    for (int i = 0; i < GUIDE_PAGE_COUNT; i++) {
        UIImageView *imageView = [[UIImageView alloc] init] ; // base_bg_4
        imageName = [NSString stringWithFormat:@"%@%d", imageNameTemp,i+1] ;
        imageView.image = [UIImage imageNamed:imageName] ;
        imageView.frame = CGRectMake(i * imageW, 0, imageW, imageH) ;
        [scrollView addSubview:imageView] ;
        
        imageName = imageNameTemp ;
        // 设置最后一页
        if (GUIDE_PAGE_COUNT - 1 == i ) {
            imageView.userInteractionEnabled = YES ;
            [self setupLastImageView:imageView] ;
        }
    }
    scrollView.contentSize = CGSizeMake(GUIDE_PAGE_COUNT * imageW, 0) ;
    scrollView.pagingEnabled = YES ;
    scrollView.showsHorizontalScrollIndicator = NO ;
    scrollView.backgroundColor = [UIColor clearColor] ;
}

- (void)setupLastImageView:(UIView *)view{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapExperience:)] ;
    [view addGestureRecognizer:tapGesture] ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CSLog(@"contentOffset = %@", NSStringFromCGPoint(scrollView.contentOffset)) ;
    CGPoint offset = scrollView.contentOffset ;
    if (offset.x > (GUIDE_PAGE_COUNT - 1 ) * SCREENWIDTH + 60) {
        [self showHomeVC] ;
    }
}

// 进入首页
- (void)showHomeVC{
    UIWindow *window = [UIApplication sharedApplication].keyWindow ;
    window.rootViewController = GlobalObj.tabBarController  ;
}

- (void)tapExperience:(UIGestureRecognizer *)tapGesture{
    CGFloat experienceBtnW = TRANSFER_SIZE(135) ;
    CGFloat experienceBtnH = TRANSFER_SIZE(34) ;
    CGFloat experienceBtnY = SCREENHEIGHT - TRANSFER_SIZE(78) - experienceBtnH ;
    CGFloat experienceBtnX = (SCREENWIDTH - experienceBtnW) / 2 ;
    
    CGPoint location = [tapGesture locationInView:self.view] ;
    if (location.x >= experienceBtnX &&
        location.x <= experienceBtnX + experienceBtnW &&
        location.y >= experienceBtnY &&
        location.y <= experienceBtnY + experienceBtnH) {
        [self showHomeVC] ;
    }
}
@end
