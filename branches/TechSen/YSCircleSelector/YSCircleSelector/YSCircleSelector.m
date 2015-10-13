//
//  YSCircleSelector.m
//  YSCircleSelector
//
//  Created by sen on 15/6/1.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "YSCircleSelector.h"
#define RADIOUS 165.0
#define IMAGE_RADIOUS 31.0
#import <Masonry.h>
#define COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RANDOM_COLOR COLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@implementation YSCircleSelectorItem
@end


@interface YSCircleSelector ()
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) NSMutableArray *aroundImageViews;
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, strong) NSMutableArray *XCounstraints;
@property(nonatomic, strong) NSMutableArray *YCounstraints;
@property(nonatomic, strong) NSMutableArray *XCounstraintsOffsets;
@property(nonatomic, strong) NSMutableArray *YCounstraintsOffsets;
@property(nonatomic, assign) NSInteger currentIndex;
@end

@implementation YSCircleSelector
#pragma mark - Init
- (instancetype)initWithCircleSelectorItems:(NSArray *)items
{
    _items = items;
    return [self init];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAroundImageViews];
        [self addGR];
        _currentIndex = _items.count / 2;
    }
    return self;
}

- (void)addGR
{
    // 添加手势
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipeGR];
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipeGR];
}

- (void)swipe:(UISwipeGestureRecognizer *)swipeGR
{
    
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
            NSInteger index = (_currentIndex - _items.count / 2) % _items.count;
            aroundImageView = self.aroundImageViews[index];
            aroundImageView.hidden = YES;
            _currentIndex = (_currentIndex + 1) % _items.count;
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
            NSInteger index = (_currentIndex + _items.count / 2) % _items.count;
            aroundImageView = self.aroundImageViews[index];
            aroundImageView.hidden = YES;
            _currentIndex = (_currentIndex - 1 < 0?_items.count - 1:_currentIndex - 1);
            break;
        }
            
        default:
            break;
            
    }
    [UIView animateWithDuration:0.5 animations:^{
        for (int i = 0; i<self.XCounstraints.count; i++) {
            MASConstraint *currentXConstraint = self.XCounstraints[i];
            MASConstraint *currentYConstraint = self.YCounstraints[i];
            currentXConstraint.offset = [self.XCounstraintsOffsets[i] floatValue];;
            currentYConstraint.offset = [self.YCounstraintsOffsets[i] floatValue];;
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        aroundImageView.hidden = NO;
    }];
    NSLog(@"当前被选中的索引为%d",_currentIndex);

}

- (void)setupAroundImageViews
{
    // 创建一个可变数组,用于存放边上的图片View
    self.aroundImageViews = [NSMutableArray arrayWithCapacity:_items.count];
    for (int i = 0; i<_items.count; i++) {
        YSCircleSelectorItem *item = _items [i];
        UIButton *aroundImageView = [[UIButton alloc] init];
        aroundImageView.backgroundColor = RANDOM_COLOR;
//        aroundImageView.image = item.aroundImage;
        aroundImageView.layer.cornerRadius = IMAGE_RADIOUS;
        aroundImageView.layer.masksToBounds = YES;
        //        aroundImageView.highlightedImage = item.highlightAroundImage;
        [aroundImageView setImage:item.aroundImage forState:UIControlStateNormal];
        [aroundImageView setImage:item.highlightAroundImage forState:UIControlStateHighlighted];
        [aroundImageView setTitle:[NSString stringWithFormat:@"%d号",i] forState:UIControlStateNormal];
        [self addSubview:aroundImageView];
        [self.aroundImageViews addObject:aroundImageView];
    }
}


- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        self.XCounstraints = [NSMutableArray arrayWithCapacity:_aroundImageViews.count];
        self.YCounstraints = [NSMutableArray arrayWithCapacity:_aroundImageViews.count];
        self.XCounstraintsOffsets = [NSMutableArray arrayWithCapacity:_aroundImageViews.count];
        self.YCounstraintsOffsets = [NSMutableArray arrayWithCapacity:_aroundImageViews.count];
        for (int i = 0; i<_aroundImageViews.count; i++) {
            UIImageView *aroundImageView = _aroundImageViews[i];
            
            CGFloat XOffset = RADIOUS * cos(-M_PI + M_PI / (_items.count + 1) * (i+1));
            CGFloat YOffset = RADIOUS * sin(-M_PI + M_PI / (_items.count + 1) * (i+1));
            [aroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(IMAGE_RADIOUS * 2, IMAGE_RADIOUS * 2));
                [self.XCounstraints addObject:make.centerX.equalTo(self).offset(XOffset)];
                [self.YCounstraints addObject:make.centerY.equalTo(self).offset(YOffset)];
            }];
            [self.XCounstraintsOffsets addObject:[NSNumber numberWithFloat:XOffset]];
            [self.YCounstraintsOffsets addObject:[NSNumber numberWithFloat:YOffset]];
        }
        
        
        self.didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}


@end
