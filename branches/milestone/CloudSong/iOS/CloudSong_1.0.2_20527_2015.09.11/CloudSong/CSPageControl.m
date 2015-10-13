//
//  CSPageControl.m
//  CloudSong
//
//  Created by youmingtaizi on 7/21/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSPageControl.h"
#import "CSDefine.h"
#import <Masonry.h>

#define kNumOfPages 3
#define kIndicatorWidth 10
#define kIndicatorGap   5

@interface CSPageControl () {
    NSMutableArray* _indicators;
}
@end

@implementation CSPageControl

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _currentPage = -1;
        _indicators = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setNumOfPages:(NSInteger)numOfPages {
    _numOfPages = numOfPages;
    [self setupSubviews];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    for (int i = 0; i < _indicators.count; ++i) {
        UIView *indicator = _indicators[i];
        indicator.backgroundColor = _currentPage == i ? HEX_COLOR(0xff00ab) : HEX_COLOR(0xa0a0a0);
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UIView *container = [[UIView alloc] init];
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(container.superview);
        make.size.mas_equalTo(CGSizeMake((kIndicatorWidth + kIndicatorGap) * _numOfPages - kIndicatorGap, 1));
    }];
    for (int i = 0; i < _numOfPages; ++i) {
        UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(i == 0 ? 0 : (kIndicatorWidth + kIndicatorGap) * i, 0, kIndicatorWidth, 1)];
        [container addSubview:indicator];
        [_indicators addObject:indicator];
    }
}



@end
