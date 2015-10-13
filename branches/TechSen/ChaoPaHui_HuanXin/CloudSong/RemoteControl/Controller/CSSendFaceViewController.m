//
//  CSSendFaceViewController.m
//  CloudSong
//
//  Created by sen on 15/6/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSendFaceViewController.h"
#import "CSMagicFace.h"
@interface CSSendFaceViewController ()
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, strong) NSArray *magicDecs;
@property(nonatomic, weak) UIView *container;
@end

@implementation CSSendFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _magicDecs = @[
                   @"嗨起来",
                   @"放个屁",
                   @"谢谢大家",
                   @"雷到了",
                   @"送花",
                   @"我到了",
                   @"崇拜",
                   @"苦逼的歌",
                   @"戳你PP"
                  ];
    [self setupSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}



#pragma mark - Setup
- (void)setupSubviews
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView.superview);
    }];

    
    UIView *container = [[UIView alloc] init];
    _container = container;
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container.superview);
        make.width.equalTo(container.superview);
    }];
    
    CGFloat faceWidth = SCREENWIDTH / 3;
    CGFloat faceHeight = TRANSFER_SIZE(130.0);
    int totalImageCount = 9;
    for (int i = 0; i < totalImageCount; i++) {
        int row = i / 3;
        int col = i % 3;
        CSMagicFace *magicFace = [[CSMagicFace alloc] init];
        magicFace.tag = i + 1;
        [magicFace addTarget:self action:@selector(magicFaceOnPressed:)];
        NSString *imageName = [NSString stringWithFormat:@"room_magic_%d",i+1];
        magicFace.image = [UIImage imageNamed:imageName];
        magicFace.text = _magicDecs[i];
        [container addSubview:magicFace];
        
        [magicFace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(faceWidth, faceHeight));
            make.left.equalTo(magicFace.superview).offset(faceWidth * col);
            make.top.equalTo(magicFace.superview).offset(faceHeight * row);
            if (i == totalImageCount - 1) {
                make.bottom.equalTo(container.mas_bottom);
            }
        }];

    }
    

}

#pragma mark - Config
- (void)configNavigationBar
{
    [super configNavigationBar];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"room_nav_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}

#pragma mark - Touch Events
- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)magicFaceOnPressed:(UITapGestureRecognizer *)tap
{
    NSString *gifName = [NSString stringWithFormat:@"mofaface%ld.gif",tap.view.tag];
//    CSLog(@"%@",gifName);
    if ([self.delegate respondsToSelector:@selector(sendFaceViewControllerDidClickWithName:)]) {
        [self.delegate sendFaceViewControllerDidClickWithName:gifName];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
