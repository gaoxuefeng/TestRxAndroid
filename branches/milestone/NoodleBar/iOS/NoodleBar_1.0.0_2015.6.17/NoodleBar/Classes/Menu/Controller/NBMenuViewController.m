//
//  NBMenuViewController.m
//  NoodleBar
//
//  Created by sen on 6/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBMenuViewController.h"
#import "NBNavBar.h"
#import "NBAdView.h"
#import "NBMenuView.h"
#import "NBCartView.h"
#import "NBTopView.h"
#import "NBAccountTool.h"
#import "NBPayViewController.h"
#import "NBLoginViewController.h"
#import "NBMenuHttpTool.h"
#import "NBMerchantTool.h"
#import "NBCartTool.h"
#import "NBMerchantDetailViewController.h"

#define AD_VIEW_HEIGHT 80.f
@interface NBMenuViewController ()<NBMenuViewDelegate>
{
    NBNavBar *_customNavBar;
    NBAdView *_adView;
    NBMenuView *_menuView;
    NBCartView *_cartView;
}
@property(nonatomic, weak) NBTopView *topView;
@property(nonatomic, strong) UIImageView *flyingImage;
@property(nonatomic, weak) CALayer *layer;

/** 菜单是否已上移 */
@property(nonatomic, assign,getter=isMoveUp) BOOL moveUp;
@end

@implementation NBMenuViewController
#pragma mark - Lazy Load
- (UIImageView *)flyingImage
{
    if (!_flyingImage) {
        _flyingImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_cart_full"]];
        _flyingImage.contentMode=UIViewContentModeScaleToFill;
        _flyingImage.frame=CGRectMake(0, 0, 20, 20);
        _flyingImage.hidden= YES;
    }
    return _flyingImage;
}

- (NBTopView *)topView
{
    if (!_topView) {
        NBTopView *topView = [[NBTopView alloc] init];
//        topView.frame = self.view.bounds;
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        _topView = topView;
    }
    return _topView;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self setupNavBar];
    [self setupAdView];
    [self setupMenuView];
    [self setupCartView];
    [self loadData];
    if (self.merchantName) {
        self.title = self.merchantName;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plusBtnOnClick:) name:MENU_CATEGORY_DETAIL_PLUS_ON_CLICK object:nil];
    [self.view bringSubviewToFront:_topView];
    [_menuView reload];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MENU_CATEGORY_DETAIL_PLUS_ON_CLICK object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_CONTENT_CHANGED object:nil];
}

- (void)dealloc
{
    [NBCartTool emptyShoppingCart];
    [NBMerchantTool setCurrentMerchantID:nil];
    [NBMerchantTool setCurrentTableCode:nil];
}

#pragma - Inherit
- (void)loadData
{
    [SVProgressHUD show];
    [super loadData];
    [self loadDishData];
    [self loadAdData];
    
}

- (void)configNavigationBar
{
    [super configNavigationBar];
    UIButton *merchantDetailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [merchantDetailButton addTarget:self action:@selector(merchantDetailBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [merchantDetailButton setImage:[[UIImage imageNamed:@"nav_merchant_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [merchantDetailButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:merchantDetailButton];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Private Methods
#pragma mark - Setup
- (void)setupNavBar
{
    _customNavBar = [[NBNavBar alloc] init];
    [_customNavBar backButtonAddTarget:self Action:@selector(backBtnOnClick)];
    [_customNavBar setTitle:self.title];
    [self.view addSubview:_customNavBar];
    [_customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(64.0);
    }];
}

- (void)setupAdView
{
    _adView = [[NBAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 80.0f)];
    [self.view addSubview:_adView];
}

- (void)setupMenuView
{
    _menuView = [[NBMenuView alloc] init];
    CGFloat menuViewW = SCREEN_WIDTH;
    CGFloat menuViewH = SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - _adView.height - CART_VIEW_HEIGHT;
    CGFloat menuViewX = 0;
    CGFloat menuViewY = CGRectGetMaxY(_adView.frame);
    _menuView.frame = CGRectMake(menuViewX, menuViewY, menuViewW, menuViewH);
    _menuView.delegate = self;
    [self.view addSubview:_menuView];
}

- (void)setupCartView
{
    _cartView = [[NBCartView alloc] init];
    [self.topView addSubview:_cartView];
    _cartView.cartViewHeightConstraint = [_cartView autoSetDimension:ALDimensionHeight toSize:CART_VIEW_HEIGHT];
    [_cartView autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
    [_cartView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_cartView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_cartView payButtonAddTarget:self action:@selector(toPayBtnOnClick)];
}

#pragma mark - Load Data
- (void)loadDishData
{
    // 菜单数据
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.businessid = [NBMerchantTool currentMerchantID];
    [NBMenuHttpTool dishesWithParam:param success:^(NBDishResponseModel *result) {
        _menuView.dishesData = result.data;
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NBLog(@"%@",error);
        [self showNetInstabilityView];
    }];
}

- (void)loadAdData
{
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.businessid = [NBMerchantTool currentMerchantID];
    
    [NBMenuHttpTool adesWithParam:param success:^(NBMenuAdResponseModel *result) {
        _adView.items = [result.data.pictureurlList valueForKeyPath:@"pictureurl"];
        [NBCartTool setPromots:result.data.promots];
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
    }];
}

/**
 *  加号按钮点击动画
 *
 *  @param notifiation 通知
 */
- (void)plusBtnOnClick:(NSNotification *)notifiation
{
    UIButton *plusButton = (UIButton *)notifiation.userInfo[@"info"];
    CGPoint startPoint = [self.topView convertPoint:plusButton.center fromView:plusButton.superview];
    CGPoint endPoint = [self.topView convertPoint:_cartView.cartButton.center fromView:_cartView.cartButton.superview];
    self.flyingImage.center = startPoint;
    CALayer *layer = [[CALayer alloc]init];
    layer.contents = self.flyingImage.layer.contents;
    layer.frame= self.flyingImage.frame;
    layer.opacity = 1;
    [self.topView.layer addSublayer:layer];
    _layer = layer;
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    float sx=startPoint.x;
    float sy=startPoint.y;
    float ex=endPoint.x;
    float ey=endPoint.y;
    float x= sx + (ex-sx) * 0.5;
    float y= sy + (ey-sy) * 0.5 - 200;
    CGPoint centerPoint=CGPointMake(x,y);
    [path addQuadCurveToPoint:endPoint controlPoint:centerPoint];
    
    CGFloat duration = 0.4f;
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    animation.autoreverses = NO;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:@"buy"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
        
        [UIView animateWithDuration:.1f animations:^{
            
            _cartView.cartButton.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1f animations:^{
                _cartView.cartButton.layer.transform = CATransform3DIdentity;
            }];
        }];
    });
}

#pragma mark - NBMenuViewDelegate

- (void)menuViewshouldMove:(NBMenuViewMoveType)moveType
{
    CGFloat menuViewY = 0;
    CGFloat menuViewH = 0;
    switch (moveType) {
        case NBMenuViewMoveTypeUp:
            if (_moveUp) return; // 如果已上移 则返回
            menuViewY = _menuView.y - AD_VIEW_HEIGHT;
            menuViewH = _menuView.height + AD_VIEW_HEIGHT;
            _moveUp = YES;
            break;
        case NBMenuViewMoveTypeDown:
            if (!_moveUp) return; // 如果没上移动 则返回
            menuViewY = _menuView.y + AD_VIEW_HEIGHT;
            menuViewH = _menuView.height - AD_VIEW_HEIGHT;
            _moveUp = NO;
            
            break;
            
        default:
            break;
    }
    
    if (_moveUp) {
        _menuView.height = menuViewH;
    }
    [UIView animateWithDuration:.2f animations:^{
        _menuView.y = menuViewY;
        
    } completion:^(BOOL finished) {
        if (!_moveUp) {
            _menuView.height = menuViewH;
        }
    }];
}



#pragma mark - Action
- (void)backBtnOnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toPayBtnOnClick
{
    
    
    if ([NBAccountTool account]) { // 如果已经登录
        [self.navigationController pushViewController:[[NBPayViewController alloc] init] animated:YES];
    }else
    {
        NBLoginViewController *loginVc = [[NBLoginViewController alloc] init];
        loginVc.loginBlock = ^(BOOL loginSuccess){
            if (loginSuccess) {
                [self.navigationController popViewControllerAnimated:NO];
                [self.navigationController pushViewController:[[NBPayViewController alloc] init] animated:YES];
            }
        };
        
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}

- (void)merchantDetailBtnOnClick
{
    NBMerchantDetailViewController *merchantVc = [[NBMerchantDetailViewController alloc] initWithMerchantID:[NBMerchantTool currentMerchantID]];
    [self.navigationController pushViewController:merchantVc animated:YES];
}


@end
