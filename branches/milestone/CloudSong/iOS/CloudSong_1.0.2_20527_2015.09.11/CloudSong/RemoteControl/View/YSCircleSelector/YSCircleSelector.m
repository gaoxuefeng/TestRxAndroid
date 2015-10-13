//
//  YSCircleSelector.m
//  YSCircleSelector
//
//  Created by sen on 15/6/1.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "YSCircleSelector.h"
#import "Header.h"
#define RADIOUS ([UIScreen mainScreen].bounds.size.width * 0.5 + 30)
//#define IMAGE_RADIOUS 31.0
#import <Masonry.h>
#import <UIImage+ColorAtPixel.h>
#define BUTTON_HEIGHT 44.0
#define CENTERYOFFSET 20.0
@implementation YSCircleSelectorItem
@end


@interface YSCircleSelector ()
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) NSMutableArray *aroundImageViews;
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, strong) NSMutableArray *XCounstraints;
@property(nonatomic, strong) NSMutableArray *YCounstraints;
@property(nonatomic, strong) NSMutableArray *XCounstraintsOffsets;
@property(nonatomic, strong) NSMutableArray *YCounstraintsOffsets;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign, getter=isSpread) BOOL spread;

@property(nonatomic, assign, getter=isAnimating) BOOL animating;

/** 背景图片视图 */
@property(nonatomic, strong) UIImageView *backgroundImageView;
/** 用用背景视图 */
@property(nonatomic, strong) UIImageView *reserveBackgroundImageView;
/** 展示在中间的圆型图视图 */
@property(nonatomic, strong) UIImageView *centerCircleImageView;
/** 备用展示在中间的圆形图视图 用于过渡动画 */
@property(nonatomic, strong) UIImageView *reserveCircleImageView;
/** 展示在中间的图片视图 */
@property(nonatomic, strong) UIImageView *centerImageView;
/** 备用展示在中间的图视图 用于过渡动画 */
@property(nonatomic, strong) UIImageView *reserveCenterImageView;
/** 标题 */
@property(nonatomic, strong) UILabel *titleLabel;
/** 返回按钮 */
@property(nonatomic, strong) UIButton *backButton;
/** 确认按钮 */
@property(nonatomic, strong) UIButton *confirmButton;
/** 返回按钮距离顶部的位移 */
@property(nonatomic, strong) MASConstraint *backBtnYConstraint;

@property(nonatomic, strong) YSCircleSelectorItem *currentItem;

/** 真实item数量 */
@property(nonatomic, assign) NSInteger itemCount;

@end

@implementation YSCircleSelector
#pragma mark - Lazy Load

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];

        [_backButton setTitle:@"返回遥控" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTitleColor:HEX_COLOR(0x676866) forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _backButton.layer.borderColor = HEX_COLOR(0x676866).CGColor;
        _backButton.layer.borderWidth = 0.5;
        _backButton.layer.cornerRadius = BUTTON_HEIGHT * 0.5;
        _backButton.layer.masksToBounds = YES;
        _backButton.alpha = 0.0;
        [self addSubview:_backButton];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(210.0, BUTTON_HEIGHT));
            self.backBtnYConstraint = make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return _backButton;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitle:@"确认切换" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
//        _confirmButton.layer.borderWidth = 0.5;
        _confirmButton.layer.cornerRadius = BUTTON_HEIGHT * 0.5;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.alpha = 0.0;
        [self addSubview:_confirmButton];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(210.0, BUTTON_HEIGHT));
            make.bottom.equalTo(self.backButton.mas_top).offset(-15.0);
        }];
    }
    return _confirmButton;
}


- (UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
        [self addSubview:_centerImageView];
        [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
//            make.center.equalTo(self);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-CENTERYOFFSET);

        }];
    }
    return _centerImageView;
}

/** 备用背景图片视图 */
- (UIImageView *)reserveBackgroundImageView
{
    if (!_reserveBackgroundImageView) {
        _reserveBackgroundImageView = [[UIImageView alloc] init];
        _reserveBackgroundImageView.alpha = 0.0;
        [self insertSubview:_reserveBackgroundImageView belowSubview:self.backgroundImageView];
        [_reserveBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _reserveBackgroundImageView;
}

/** 备用中心视图 */
- (UIImageView *)reserveCenterImageView
{
    if (!_reserveCenterImageView) {
        _reserveCenterImageView = [[UIImageView alloc] init];
        _reserveCenterImageView.alpha = 0.0;
        [self addSubview:_reserveCenterImageView];
    }
    return _reserveCenterImageView;
    
}

// 备用中心圆圈视图
- (UIImageView *)reserveCircleImageView
{
    if (!_reserveCircleImageView) {
        _reserveCircleImageView = [[UIImageView alloc] init];
        _reserveCircleImageView.alpha = 0.0;
        [self insertSubview:_reserveCircleImageView belowSubview:_centerCircleImageView];
        [_reserveCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_centerCircleImageView.mas_width);
            make.height.mas_equalTo(_centerCircleImageView.mas_height);
//            make.center.equalTo(self);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-CENTERYOFFSET);
        }];
    }
    return _reserveCircleImageView;
    
    
}

#pragma mark - Init
- (instancetype)initWithCircleSelectorItems:(NSArray *)items
{
    _items = [NSMutableArray arrayWithArray:items];
//    if (items.count % 2 == 0) { // 如果是偶数个 则+1
//        YSCircleSelectorItem *item = [[YSCircleSelectorItem alloc] init];
//        [_items addObject:item];
//    }
    
    _itemCount = _items.count;
    for (int i = 0; i < 7 - items.count; i++) {
        YSCircleSelectorItem *item = _items[i % _itemCount];
        [_items addObject:item];
    }
    
    return [self init];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setupBackgroundImageView];
        [self setupCenterCircleImageView];
        [self setupAroundImageViews];
        [self setupTitleLabel];
        [self addGR];
        _currentIndex = _items.count / 2;
        self.layer.masksToBounds = YES;
    }
    return self;
}



#pragma mark - Setup
/** 创建背景视图 */
- (void)setupBackgroundImageView
{
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView = backgroundImageView;
    [self insertSubview:backgroundImageView atIndex:0];
}

/** 创建中心原型视图 */
- (void)setupCenterCircleImageView
{
    UIImageView *centerCircleImageView = [[UIImageView alloc] init];
    _centerCircleImageView = centerCircleImageView;
    [self addSubview:centerCircleImageView];
}

- (void)setupTitleLabel
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:30.0];
    _titleLabel.textColor = HEX_COLOR(0x55574e);
    _titleLabel.alpha = 0.0;
    [self addSubview:_titleLabel];
}



/** 添加手势 */
- (void)addGR
{
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipeGR];
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipeGR];
}

- (void)setupAroundImageViews
{
    // 创建一个可变数组,用于存放边上的图片View
    self.aroundImageViews = [NSMutableArray arrayWithCapacity:_items.count];
    for (int i = 0; i<_items.count; i++) {
        YSCircleSelectorItem *item = _items [i % _itemCount];
        UIButton *aroundImageView = [[UIButton alloc] init];
        [aroundImageView setImage:item.aroundImage forState:UIControlStateNormal];
        [aroundImageView setImage:item.highlightAroundImage forState:UIControlStateHighlighted];
        [self addSubview:aroundImageView];
        [self.aroundImageViews addObject:aroundImageView];
        aroundImageView.alpha = 0.0;
    }
}


#pragma mark - Public Methods

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = _backgroundImage;
}

- (void)spread
{
    if (self.isSpread) return;
    // X方向的约束数组
    self.XCounstraints = [NSMutableArray arrayWithCapacity:_aroundImageViews.count];
    // Y方向的约束数组
    self.YCounstraints = [NSMutableArray arrayWithCapacity:_aroundImageViews.count];
    
    // X方向偏移数组
    self.XCounstraintsOffsets = [NSMutableArray arrayWithCapacity:_aroundImageViews.count];
    // Y方向偏移数组
    self.YCounstraintsOffsets = [NSMutableArray arrayWithCapacity:_aroundImageViews.count];
    
    
    
    __weak typeof(self) weakSelf = self;
    /**************************************** 获取中心被选中的item ************************************/
    YSCircleSelectorItem *centerItem = self.items[self.items.count / 2];
    _currentItem = centerItem;
    self.centerCircleImageView.image = centerItem.centerCircleImage;
    self.centerImageView.image = centerItem.centerImage;
    self.backgroundImageView.image = self.backgroundImage?self.backgroundImage:centerItem.backgroundImage;
    self.titleLabel.text = centerItem.title;
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 中心圆型图片弹出动画
        [weakSelf.centerCircleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf).offset(-CENTERYOFFSET);
            make.size.mas_equalTo(weakSelf.centerCircleImageView.image.size);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // 中心图片弹出动画
            [weakSelf.centerImageView mas_remakeConstraints:^(MASConstraintMaker *make)
            {
                make.centerX.equalTo(weakSelf);
                make.centerY.equalTo(weakSelf).offset(-CENTERYOFFSET);
                make.size.mas_equalTo(weakSelf.centerImageView.image.size);
            }];
            weakSelf.titleLabel.alpha = 1.0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        
            [self layoutIfNeeded];
            for (int i = 0; i<_aroundImageViews.count; i++) {
                
                UIImageView *aroundImageView = _aroundImageViews[i];
                aroundImageView.hidden = NO;
                // 格数 如果是偶数个,凑到基数个
                NSInteger totalPiece = _items.count % 2?_items.count:_items.count + 1;
                // 每格的弧度
                CGFloat rad =  M_PI / (totalPiece - 1);
//                 占时固定死 每个item的角度差为M_PI / 6
//                CGFloat rad =  M_PI / 6;
                CGFloat XOffset = RADIOUS * cos(-M_PI + rad * (i));
                CGFloat YOffset = RADIOUS * sin(-M_PI + rad * (i)) - CENTERYOFFSET;
                [weakSelf.XCounstraintsOffsets addObject:[NSNumber numberWithFloat:XOffset]];
                [weakSelf.YCounstraintsOffsets addObject:[NSNumber numberWithFloat:YOffset]];
                CGFloat duration = 0.5;
                [UIView animateWithDuration:duration delay:i * duration / MIN(_items.count, 7)
                     usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                         
                         aroundImageView.alpha = 1.0;
                         [aroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                             [weakSelf.XCounstraints addObject:make.centerX.equalTo(weakSelf).offset(XOffset)];
                             [weakSelf.YCounstraints addObject:make.centerY.equalTo(weakSelf).offset(YOffset)];
                         }];
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         // 显示返回按钮和确认按钮
                         weakSelf.backButton.hidden = NO;
                         weakSelf.confirmButton.backgroundColor = _currentItem.confirmColor?_currentItem.confirmColor:[_currentItem.centerCircleImage colorAtPixel:CGPointMake(_currentItem.centerCircleImage.size.width * 0.5,_currentItem.centerCircleImage.size.height * 0.5)];

                         [self layoutIfNeeded];
                         [UIView animateWithDuration:0.5 animations:^{
                             weakSelf.backBtnYConstraint.offset = -35.0;
                             weakSelf.backButton.alpha = 1.0;
                             weakSelf.confirmButton.alpha = 1.0;
                             [self layoutIfNeeded];
                         } completion:nil];
                         
                         _spread = YES;
                     }];
            }
        }];
    }];
}

#pragma mark - Private Methods
- (void)swipe:(UISwipeGestureRecognizer *)swipeGR
{
    // 还未展开 直接返回
    if (!self.isSpread) return;
    // 如果正在动画 直接返回
    if (self.isAnimating) return;
    self.animating = YES;
    
    UIImageView *aroundImageView;
    switch (swipeGR.direction) {
        case UISwipeGestureRecognizerDirectionLeft: // 左滑手势
        {
            NSNumber *XLastObj = self.XCounstraintsOffsets.lastObject;
            [self.XCounstraintsOffsets removeLastObject];
            [self.XCounstraintsOffsets insertObject:XLastObj atIndex:0];
            NSNumber *YLastObj = self.YCounstraintsOffsets.lastObject;
            [self.YCounstraintsOffsets removeLastObject];
            [self.YCounstraintsOffsets insertObject:YLastObj atIndex:0];
            
            
            if (_itemCount == 5) {
                // 获取当前最右边索引
                NSInteger rightIndex = (_currentIndex + _items.count / 2) % _items.count;
                NSInteger rightTempIndex = rightIndex - _itemCount;

                YSCircleSelectorItem *item = self.items[(rightTempIndex < 0 ? rightTempIndex + _items.count:rightTempIndex) % _items.count];
                self.items[rightIndex] = item;
                
                YSCircleSelectorItem *rightItem = self.items[rightIndex];
                // 获取屏幕最右边的视图
                UIButton *rightAroundImageView = self.aroundImageViews[rightIndex];
                [rightAroundImageView setImage:rightItem.aroundImage forState:UIControlStateNormal];
                
                // 获取当前处于屏幕最左边的索引
                NSInteger tmpIndex = (_currentIndex - _items.count / 2);
                NSInteger leftIndex = (tmpIndex < 0 ? tmpIndex + _items.count:tmpIndex) % _items.count;
                aroundImageView = self.aroundImageViews[leftIndex];
                aroundImageView.hidden = YES;
                _currentIndex = (_currentIndex + 1) % _items.count;
            }else
            {
                // 获取当前处于屏幕最左边的索引
                NSInteger tmpIndex = (_currentIndex - _items.count / 2);
                NSInteger leftIndex = (tmpIndex < 0 ? tmpIndex + _items.count:tmpIndex) % _items.count;
                
                // 获取当前最右边索引
                NSInteger rightIndex = (_currentIndex + _items.count / 2) % _items.count;
                self.items[rightIndex] = self.items[leftIndex];
                YSCircleSelectorItem *rightItem = self.items[rightIndex];
                
                // 获取屏幕最右边的视图
                UIButton *rightAroundImageView = self.aroundImageViews[rightIndex];
                [rightAroundImageView setImage:rightItem.aroundImage forState:UIControlStateNormal];
                aroundImageView = self.aroundImageViews[leftIndex];
                aroundImageView.hidden = YES;
                _currentIndex = (_currentIndex + 1) % _items.count;
            }
            
            break;
        }
        case UISwipeGestureRecognizerDirectionRight: // 右滑手势
        {
            NSNumber *XLastObj = self.XCounstraintsOffsets.firstObject;
            [self.XCounstraintsOffsets removeObjectAtIndex:0];
            [self.XCounstraintsOffsets addObject:XLastObj];
            NSNumber *YLastObj = self.YCounstraintsOffsets.firstObject;
            [self.YCounstraintsOffsets removeObjectAtIndex:0];
            [self.YCounstraintsOffsets  addObject:YLastObj];
            
            if (_itemCount == 5) {
                // 获取当前处于屏幕最左边的索引
                NSInteger tmpIndex = (_currentIndex - _items.count / 2);
                NSInteger leftIndex = (tmpIndex < 0 ? tmpIndex + _items.count:tmpIndex) % _items.count;
                NSInteger leftTempIndex = (leftIndex + _itemCount) % _items.count;
//                CSLog(@"%ld",leftTempIndex);
                self.items[leftIndex] = self.items[leftTempIndex];
                
                YSCircleSelectorItem *firstItem = self.items[leftIndex];
                
                // 获取屏幕最右边的视图
                UIButton *leftAroundImageView = self.aroundImageViews[leftIndex];
                [leftAroundImageView setImage:firstItem.aroundImage forState:UIControlStateNormal];
                
                // 获取当前最右边索引
                NSInteger index = (_currentIndex + _items.count / 2) % _items.count;
                aroundImageView = self.aroundImageViews[index];
                aroundImageView.hidden = YES;
                _currentIndex = (_currentIndex - 1 < 0?_items.count - 1:_currentIndex - 1);
                
            }else
            {
                // 获取当前最右边索引
                NSInteger index = (_currentIndex + _items.count / 2) % _items.count;
                // 获取屏幕最右边-1索引
                NSInteger firstIndex = index - 1 < 0 ?(index - 1+_items.count) % _items.count:index - 1;
                self.items[index] = self.items[firstIndex];
                YSCircleSelectorItem *firstItem = self.items[index];
                // 获取屏幕最右边的视图
                UIButton *leftAroundImageView = self.aroundImageViews[index];
                [leftAroundImageView setImage:firstItem.aroundImage forState:UIControlStateNormal];
                
                aroundImageView = self.aroundImageViews[index];
                aroundImageView.hidden = YES;
                _currentIndex = (_currentIndex - 1 < 0?_items.count - 1:_currentIndex - 1);
            }
            
            break;
        }
        default:
            break;
    }
    

    
    YSCircleSelectorItem *item = self.items[_currentIndex];
    /******************************************* 修改确认键按钮 ****************************************************/
    self.confirmButton.backgroundColor = item.confirmColor?item.confirmColor:[item.centerCircleImage colorAtPixel:CGPointMake(item.centerCircleImage.size.width * 0.5,item.centerCircleImage.size.height * 0.5)];
    _currentItem = item;
    /******************************************* 初始化中心圆图片 ****************************************************/
    if (self.centerCircleImageView.alpha == 0.0) {  // 如果中心圆图片透明 则中心圆即将展示 给予图片
        self.centerCircleImageView.image = item.centerCircleImage;
    }else // 如果中心圆图片不透明 则中心圆即将隐藏 备用中心圆视图即将展示  给予图片
    {
        self.reserveCircleImageView.image = item.centerCircleImage;
    }
    
    /******************************************* 初始化背景切换图片 ****************************************************/
    if (!self.backgroundImage) {
        if (self.backgroundImageView.alpha == 0.0) {  // 如果背景图片透明 则背景图即将展示 给予图片
            self.backgroundImageView.image = item.backgroundImage;
        }else // 如果背景图片不透明 则背景即将隐藏 备用背景视图即将展示  给予图片
        {
            self.reserveBackgroundImageView.image = item.backgroundImage;
        }
    }
    
    /******************************************* 初始化中心图片切换位置 ****************************************************/
    CGFloat xOffset = 70.0;
    CGFloat yOffset = 30.0;
    if (self.centerImageView.alpha == 0.0) {    // 如果中心图透明 则中心图即将展示 给予图片
        self.centerImageView.image = item.centerImage;
        [self.centerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.centerImageView.image.size);
            make.centerY.equalTo(self).offset(yOffset);
            make.centerX.equalTo(self).offset(swipeGR.direction == UISwipeGestureRecognizerDirectionLeft?xOffset:-xOffset);
        }];
    }else
    {
        self.reserveCenterImageView.image = item.centerImage;
        [self.reserveCenterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.reserveCenterImageView.image.size);
            make.centerY.equalTo(self).offset(yOffset);
            make.centerX.equalTo(self).offset(swipeGR.direction == UISwipeGestureRecognizerDirectionLeft?xOffset:-xOffset);
        }];
    }

    // 设置标题
    self.titleLabel.text = item.title;
//    CSLog(@"%@",item.title);
    __weak typeof(self) weakSelf = self;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        /******************************************* 中心圆图片切换动画 ****************************************************/
        if (weakSelf.centerCircleImageView.alpha == 0.0) { // 如果中心圆图片透明 则中心圆图片即将展示
            weakSelf.reserveCircleImageView.alpha = 0.0;
            weakSelf.centerCircleImageView.alpha = 1.0;
        }else
        {
            weakSelf.reserveCircleImageView.alpha = 1.0;
            weakSelf.centerCircleImageView.alpha = 0.0;
        }
        /******************************************** 背景图切换动画 ****************************************************/
        if (!self.backgroundImage) {
            if (weakSelf.backgroundImageView.alpha == 0.0) { // 如果中心圆图片透明 则中心圆图片即将展示
                weakSelf.reserveBackgroundImageView.alpha = 0.0;
                weakSelf.backgroundImageView.alpha = 1.0;
            }else
            {
                weakSelf.reserveBackgroundImageView.alpha = 1.0;
                weakSelf.backgroundImageView.alpha = 0.0;
            }
        }
        
        /******************************************* 中心图片切换动画 ****************************************************/
        if (weakSelf.centerImageView.alpha == 0.0) { // 如果中心图片透明 则中心圆图片即将展示
            weakSelf.centerImageView.alpha = 1.0;
            weakSelf.reserveCenterImageView.alpha = 0.0;
            [weakSelf.centerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(weakSelf.centerImageView.image.size);
                make.centerX.equalTo(weakSelf);
                make.centerY.equalTo(weakSelf).offset(-CENTERYOFFSET);
            }];
            [weakSelf.reserveCenterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(weakSelf.reserveCenterImageView.image.size);
                make.centerX.equalTo(weakSelf).offset(swipeGR.direction == UISwipeGestureRecognizerDirectionLeft?-xOffset:xOffset);
                make.centerY.equalTo(weakSelf).offset(yOffset);
            }];
        }else
        {
            weakSelf.centerImageView.alpha = 0.0;
            weakSelf.reserveCenterImageView.alpha = 1.0;
            [weakSelf.reserveCenterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(weakSelf.reserveCenterImageView.image.size);
                make.centerX.equalTo(weakSelf);
                make.centerY.equalTo(weakSelf).offset(-CENTERYOFFSET);
            }];
            [weakSelf.centerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(weakSelf.centerImageView.image.size);
                make.centerX.equalTo(weakSelf).offset(swipeGR.direction == UISwipeGestureRecognizerDirectionLeft?-xOffset:xOffset);
                make.centerY.equalTo(weakSelf).offset(yOffset);
            }];
        }
        
        /******************************************* 周边图片切换动画 ****************************************************/
        for (int i = 0; i<weakSelf.XCounstraints.count; i++) {
            MASConstraint *currentXConstraint = weakSelf.XCounstraints[i];
            MASConstraint *currentYConstraint = weakSelf.YCounstraints[i];
            currentXConstraint.offset = [weakSelf.XCounstraintsOffsets[i] floatValue];
            currentYConstraint.offset = [weakSelf.YCounstraintsOffsets[i] floatValue];
        }
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        _animating = NO;
        aroundImageView.hidden = NO;
    }];
    
    
}

#pragma mark Inherit Methods
- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        for (int i = 0; i<_aroundImageViews.count; i++) {
            [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [self.centerCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeZero);
//                make.center.equalTo(self);
                make.centerX.equalTo(self);
                make.centerY.equalTo(self).offset(-CENTERYOFFSET);
            }];
            
            UIImageView *aroundImageView = _aroundImageViews[i];
            [aroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.centerY.equalTo(self).offset(-CENTERYOFFSET);
            }];
            
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerCircleImageView.mas_bottom).offset(iPhone4?-50.0:iPhone6Plus?0.0:-40.0);
                make.centerX.equalTo(self);
            }];
        }
        self.didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Action
- (void)backBtnOnClick
{
    if ([self.delegate respondsToSelector:@selector(circleSelectorDidClosed)]) {
        [self.delegate circleSelectorDidClosed];
    }
    [self removeFromSuperview];
}

- (void)confirmBtnOnClick
{
    if ([self.delegate respondsToSelector:@selector(circleSelector:itemDidPickUp:)]) {
        [self.delegate circleSelector:self itemDidPickUp:_currentItem];
        [self backBtnOnClick];
    }
}

@end
