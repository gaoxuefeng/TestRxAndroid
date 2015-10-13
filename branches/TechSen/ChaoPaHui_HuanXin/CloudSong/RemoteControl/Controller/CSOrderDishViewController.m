//
//  CSOrderDishViewController.m
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//  点菜控制器

#import "CSOrderDishViewController.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSDishTypeTableViewCell.h"
#import "CSDishDetailTableViewCell.h"
#import "CSCartView.h"
#import "CSDishCartTool.h"
#import "CSOrderDishPayViewController.h"
#import "CSOrderDishHttpTool.h"
#import "SVProgressHUD.h"
#import "CSOrderDishHttpTool.h"
#import <MJExtension.h>
#import "CSOrderDetailListJsonModel.h"
#import "NSArray+JSONCategories.h"
#import "NSDictionary+JSONCategories.h"
#import <MobClick.h>
@interface CSOrderDishViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 菜品类型列表 */
@property(nonatomic, weak) UITableView *dishTypeTableView;
/** 菜品详情列表 */
@property(nonatomic, weak) UITableView *dishDetailTableView;
/** 购物车View */
@property(nonatomic, weak) CSCartView *cartView;
/** 飞行图片 */
@property(nonatomic, strong) UIImageView *flyingImage;
/** 飞行图片图层 */
@property(nonatomic, weak) CALayer *layer;
/** 菜品类型数据 */
@property(nonatomic, strong) NSMutableArray *dishTypeData;
/** 菜品详情数据 */
@property(nonatomic, strong) NSMutableArray *dishDetailData;
/** 所有菜品详情数据 */
@property(nonatomic, strong) NSArray *totalDetailData;

@property(nonatomic, strong) NSMutableDictionary *dishDetails;

@property(nonatomic, copy) NSString *reserveBoxId;
@end


@implementation CSOrderDishViewController

- (instancetype)initWithReserveBoxId:(NSString *)reserveBoxId
{
    _reserveBoxId = reserveBoxId;
    return [self init];
}
#pragma mark - Lazy Load
- (UIImageView *)flyingImage
{
    if (!_flyingImage) {
        _flyingImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wine_shopping_cart_icon"]];
        _flyingImage.contentMode=UIViewContentModeScaleToFill;
        _flyingImage.frame=CGRectMake(0, 0, TRANSFER_SIZE(20.0), TRANSFER_SIZE(20.0));
        _flyingImage.hidden= YES;
    }
    return _flyingImage;
}
- (NSMutableDictionary *)dishDetails
{
    if (!_dishDetails) {
        _dishDetails = [NSMutableDictionary dictionary];
    }
    return _dishDetails;
}

- (NSMutableArray *)dishDetailData
{
    if (!_dishDetailData) {
        _dishDetailData = [NSMutableArray array];
    }
    return _dishDetailData;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"超市";
    self.view.backgroundColor = HEX_COLOR(0x232227);
    [self setupDishTypeTableView];
    [self setupDishDetailTableView];
    [self setupCartView];
    // 请求数据
    [self requestDishTypeData];
    [self setupNotification];
    [self configNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController.navigationBar setBarTintColor:HEX_COLOR(0x151417)];
//    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
//                                                                    NSForegroundColorAttributeName:HEX_COLOR(0xb5b7bf)};
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"plusButtonOnClick" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_CONTENT_CHANGED object:nil];
}

#pragma mark - Config
- (void)configNavigationBar
{
    [super configNavigationBar];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"room_nav_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}


#pragma mark - Setup
/** 监听通知 */
- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlusBtnOnClick:) name:@"plusButtonOnClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartContentChanged) name:CART_CONTENT_CHANGED object:nil];
}

/** 请求菜品类型列表 */
- (void)requestDishTypeData
{
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveBoxId = _reserveBoxId;
    [SVProgressHUD show];

    [CSOrderDishHttpTool dishesWithParam:param success:^(CSDishListResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            _totalDetailData = result.data;
            NSMutableArray *dishTypeM = [NSMutableArray arrayWithArray:[result.data valueForKeyPath:@"@distinctUnionOfObjects.type"]];
            [dishTypeM enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqualToString:@"其它"]) {
                    [dishTypeM exchangeObjectAtIndex:idx withObjectAtIndex:dishTypeM.count - 1];
                    *stop = YES;
                } ;
            }];
            _dishTypeData = dishTypeM;
            [_dishTypeTableView reloadData];
            NSIndexPath *defaultSelectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            
            [_dishTypeTableView selectRowAtIndexPath:defaultSelectIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_dishTypeTableView didSelectRowAtIndexPath:defaultSelectIndexPath];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}

/** 创建菜品类型列表 */
- (void)setupDishTypeTableView
{
    UITableView *dishTypeTableView = [[UITableView alloc] init];
//    dishTypeTableView.backgroundColor = [UIColor blackColor];
    dishTypeTableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    dishTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dishTypeTableView = dishTypeTableView;
    dishTypeTableView.delegate = self;
    dishTypeTableView.dataSource = self;
    dishTypeTableView.rowHeight = TRANSFER_SIZE(45.0);
    [self.view addSubview:dishTypeTableView];
    
    [dishTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TRANSFER_SIZE(44.0));
        make.width.mas_equalTo(AUTOLENGTH(60.0));
    }];
}

/** 创建菜品详情列表 */
- (void)setupDishDetailTableView
{
    UITableView *dishDetailTableView = [[UITableView alloc] init];
    dishDetailTableView.backgroundColor = [UIColor clearColor];
//    dishDetailTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wine_bg"]];
    dishDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dishDetailTableView = dishDetailTableView;
    dishDetailTableView.delegate = self;
    dishDetailTableView.dataSource = self;
    dishDetailTableView.rowHeight = TRANSFER_SIZE(81.0);
    [self.view addSubview:dishDetailTableView];
    
    [dishDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TRANSFER_SIZE(44.0));
        make.left.equalTo(self.dishTypeTableView.mas_right);
    }];
}

/** 创建购物车区域 */
- (void)setupCartView
{
    CSCartView *cartView = [[CSCartView alloc] init];
    _cartView = cartView;
    [cartView payButtonAddTarget:self action:@selector(payBtnOnClick)];
    [self.view addSubview:cartView];
    [cartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dishTypeTableView == tableView) {
        return self.dishTypeData.count;
    }else
    {
        return self.dishDetailData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dishTypeTableView == tableView) {
        CSDishTypeTableViewCell *cell = [CSDishTypeTableViewCell cellWithTableView:tableView];
        cell.titleLabel.text = self.dishTypeData[indexPath.row];
        return cell;
    }else
    {
        CSDishDetailTableViewCell *cell = [CSDishDetailTableViewCell cellWithTableView:tableView];
        cell.item = self.dishDetailData[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dishTypeTableView == tableView) {
        
        CSDishTypeTableViewCell *cell = (CSDishTypeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        // 如果菜品详情字典中不存在改类型菜品详情,则直接展示
        if (!self.dishDetails[cell.titleLabel.text]) {
            NSMutableArray *dishDetailDataTemp = [[NSMutableArray alloc] init];
            for (CSDishModel *model in self.totalDetailData) {
                if ([model.type isEqualToString:cell.titleLabel.text]) {
                    [dishDetailDataTemp addObject:model];
                }
                self.dishDetails[cell.titleLabel.text] = dishDetailDataTemp;
            }
        }
        self.dishDetailData = self.dishDetails[cell.titleLabel.text];

        [_dishDetailTableView reloadData];
    }
}

#pragma mark - Touch Events
- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [CSDishCartTool emptyCart];
}

- (void)backBtnOnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [CSDishCartTool emptyCart];
}

- (void)payBtnOnClick
{
    if ([CSDishCartTool totalPrice] > 0) {

        [MobClick event:@"RoomSuperMarketOrder"];
        [SVProgressHUD show];
            CSRequest *param = [[CSRequest alloc] init];
            param.reserveBoxId = _reserveBoxId;
            NSMutableArray *orderDetailListJsonStringM = [NSMutableArray array];
            for (int i = 0; i < [CSDishCartTool dishes].count; i++) {
                CSDishModel *dishModel = [CSDishCartTool dishes][i];
                CSOrderDetailListJsonModel *dishJsonModel = [[CSOrderDetailListJsonModel alloc] init];
                dishJsonModel.goodsId = dishModel.ID;
                dishJsonModel.num = [NSString stringWithFormat:@"%ld",dishModel.amount];
                [orderDetailListJsonStringM addObject:dishJsonModel];
            }
            NSArray *orderArray = [NSMutableArray keyValuesArrayWithObjectArray:orderDetailListJsonStringM];
            param.goodsList = [orderArray JSONString];
            param.goMoney = [NSString stringWithFloat:[CSDishCartTool totalPrice]];
            [CSOrderDishHttpTool submitDishOrderWithParam:param success:^(CSKTVDishListResponseModel *result) {
                if (result.code == ResponseStateSuccess) {
                    [SVProgressHUD dismiss];
                    CSOrderDishPayViewController *payVc = [[CSOrderDishPayViewController alloc] init];
                    payVc.data = result.data;
                    [self.navigationController pushViewController:payVc animated:YES];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:result.message];
                }
            } failure:^(NSError *error) {
                CSLog(@"%@",error);
            }];
            
//        }else
//        {
//            CSRequest *param = [[CSRequest alloc] init];
//            param.goodsList = [CSDishCartTool dishes];
//            param.reserveBoxId = [GlobalObj roomNum];
//            [CSOrderDishHttpTool submitDishOrderWithParam:param success:^(CSSubmitDishOrderResponseModel *result) {
//                if (result.code == ResponseStateSuccess) {
//                    CSOrderDishPayViewController *payVc = [[CSOrderDishPayViewController alloc] init];
//                    [self.navigationController pushViewController:payVc animated:YES];
//                }else
//                {
//                    [SVProgressHUD showErrorWithStatus:result.message];
//                }
//            } failure:^(NSError *error) {
//                
//                CSLog(@"%@",error);
//            }];
//        }
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"购物车是空的"];
    }
}

#pragma mark - Notification Events
/** 加号按钮点击动画 */
- (void)PlusBtnOnClick:(NSNotification *)notifiation
{
    UIButton *plusButton = (UIButton *)notifiation.userInfo[@"info"];
    CGPoint startPoint = [self.cartView convertPoint:plusButton.center fromView:plusButton.superview];
    CGPoint endPoint = [self.cartView convertPoint:_cartView.cartButton.center fromView:_cartView.cartButton.superview];
    self.flyingImage.center = startPoint;
    CALayer *layer = [[CALayer alloc]init];
    layer.contents = self.flyingImage.layer.contents;
    layer.frame= self.flyingImage.frame;
    layer.opacity = 1;
    [self.cartView.layer addSublayer:layer];
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
            
            self.cartView.cartButton.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1f animations:^{
                self.cartView.cartButton.layer.transform = CATransform3DIdentity;
            }];
        }];
    });
}

- (void)cartContentChanged
{
    [self.dishDetailTableView reloadData];
}
@end
