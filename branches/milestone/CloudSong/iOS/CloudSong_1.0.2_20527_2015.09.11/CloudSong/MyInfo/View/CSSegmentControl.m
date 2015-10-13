//
//  CSSegmentControl.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSegmentControl.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSSegmentControl () <UIScrollViewDelegate>
@property(nonatomic, strong) NSMutableArray *titleButtons;
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) UIView *block;
@property(nonatomic, weak) UIView *innerBlock;
@property(nonatomic, weak) UIButton *selectedButton;
@property(nonatomic, weak) MASConstraint *blockLeftConstraint;
@property(nonatomic, weak) MASConstraint *innerBlockInsetsConstraint;
@property(nonatomic, assign) NSInteger previousIndex;
@property(weak, nonatomic) UIImageView *backgroundImageView;
@end

@implementation CSSegmentControl



#pragma mark - Getter & Setter
- (void)setBlockX:(CGFloat)blockX
{
    _blockX = blockX;
    _blockLeftConstraint.offset = blockX;
    NSInteger index = blockX / _block.width + 0.5;
    _currentIndex = index;
    UIButton *currentButton = _titleButtons[index];
    self.selectedButton.selected = NO;
    currentButton.selected = YES;
    self.selectedButton = currentButton;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    scrollView.delegate = self;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    for (UIButton *titleButton in _titleButtons) {
        [titleButton setTitleColor:titleColor forState:UIControlStateNormal];
        [titleButton setTitleColor:titleColor forState:UIControlStateHighlighted];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    for (UIButton *titleButton in _titleButtons) {
        [titleButton setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
}

- (void)setBlockColor:(UIColor *)blockColor
{
    _blockColor = blockColor;
    _innerBlock.backgroundColor = blockColor;
}

//- (void)setBackgroundImage:(UIImage *)backgroundImage
//{
//    _backgroundImage = backgroundImage;
//    UIImageView *backgroundImageView = [[UIImageView alloc] init];
//    backgroundImageView.layer.masksToBounds = YES;
//    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
//    backgroundImageView.image = backgroundImage;
////    [self insertSubview:backgroundImageView atIndex:0];
//    [self addSubview:backgroundImageView];
//    
//    _backgroundImageView = backgroundImageView;
////    
////    
////    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.edges.equalTo(backgroundImageView.superview);
////    }];
//}




- (instancetype)initWithTitles:(NSArray *)titles
{
    _titles = titles;
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    _titleButtons = [NSMutableArray arrayWithCapacity:_titles.count];
    for (int i = 0; i < _titles.count; i++) {
        UIButton *titleButton = [[UIButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:_titles[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14.0];

        if (i == 0) {
            titleButton.selected = YES;
            _selectedButton = titleButton;
            _previousIndex = 0;
        }
        
        [self addSubview:titleButton];
        [_titleButtons addObject:titleButton]; 
    }
    
    UIView *block = [[UIView alloc] init];
    [self addSubview:block];
    _block = block;
    
    UIView *innerBlock = [[UIView alloc] init];
    innerBlock.backgroundColor = [UIColor redColor];
    [block addSubview:innerBlock];
    _innerBlock = innerBlock;
}



- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        
        UIButton *lastButton;
        for (int i = 0; i < _titleButtons.count; i++) {
            UIButton *titleButton = _titleButtons[i];
            [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.height.equalTo(self.mas_height);
                make.left.equalTo(lastButton?lastButton.mas_right:self.mas_left);
                make.width.equalTo(self.mas_width).multipliedBy(1.0 / _titleButtons.count);
            }];
            lastButton = titleButton;
        }
        
        [_block mas_makeConstraints:^(MASConstraintMaker *make) {
            _blockLeftConstraint = make.left.equalTo(self);
            make.width.equalTo(self.mas_width).multipliedBy(1.0 / _titleButtons.count);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(_blockHeight!=0?_blockHeight:2.0);
        }];
        
        [_innerBlock mas_makeConstraints:^(MASConstraintMaker *make) {
            _innerBlockInsetsConstraint = make.edges.equalTo(_block).insets(_blockEdgeInsets);
        }];
        
        _didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Action Methods
- (void)titleBtnOnClick:(UIButton *)button
{
    if (_currentIndex == button.tag) return;
    if (self.scrollView) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * button.tag, 0) animated:YES];
    }else
    {
        NSAssert(self.scrollView == nil, @"scrollView must not nil");
    }
}

#pragma mark - Public Methods
- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated
{
//    [self moveBlockWithButton:_titleButtons[currentIndex] animated:animated];
    [self titleBtnOnClick:_titleButtons[currentIndex]];
}

#pragma mark - Private Methods
- (void)moveBlockWithButton:(UIButton *)button animated:(BOOL)animated
{
//    self.selectedButton.selected = NO;
//    button.selected = YES;
//    self.selectedButton = button;
    [self layoutIfNeeded];
    [UIView animateWithDuration:animated?0.2:0.0 animations:^{
        self.blockX = CGRectGetMinX(button.frame);
        [self layoutIfNeeded];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.blockX = scrollView.contentOffset.x / self.titles.count;
}

// 点击按钮滚动停止时触发
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_selectedButton.tag == _previousIndex) return;
    _previousIndex = _selectedButton.tag;
    if ([self.delegate respondsToSelector:@selector(selectedChanged:)]) {
        [self.delegate selectedChanged:_currentIndex];
    }
}

// 手动滚动停止时触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_selectedButton.tag == _previousIndex) return;
    _previousIndex = _selectedButton.tag;
    if ([self.delegate respondsToSelector:@selector(selectedChanged:)]) {
        [self.delegate selectedChanged:_currentIndex];
    }
}
// 手动滚动抬起手指时停止时触发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (_selectedButton.tag == _previousIndex) return;
//    _previousIndex = _selectedButton.tag;
    if (!decelerate) {
        if ([self.delegate respondsToSelector:@selector(selectedChanged:)]) {
            [self.delegate selectedChanged:_currentIndex];
        }
    }
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    if (_backgroundImageView) {
////        [self sendSubviewToBack:_backgroundImageView];
//        _backgroundImageView.frame = self.bounds;
//    }
//    
//}



@end
