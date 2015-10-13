//
//  RTCompanyHeaderView.m
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTCompanyHeaderView.h"
#import "Header.h"
#import "RTCircleView.h"
#define CIRCLE_RADIUS (SCREEN_WIDTH * 0.5 - 50.0)

@interface RTCompanyHeaderView ()
@property(assign, nonatomic) BOOL didUpdateConstraint;
@property(weak, nonatomic) RTCircleView *circleView;
@end


@implementation RTCompanyHeaderView



#pragma mark -Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
        self.backgroundColor = DEFAULT_BG_COLOR;
    }
    return self;
}

#pragma mark - Setup

- (void)setupSubviews
{

    RTCircleView *circleView = [[RTCircleView alloc] init];
    [self addSubview:circleView];
    circleView.layer.cornerRadius = CIRCLE_RADIUS;
    circleView.layer.masksToBounds = YES;
//    circleView.backgroundColor = [UIColor greenColor];
    _circleView = circleView;
    
    
    
    
    
    
}


- (void)updateConstraints
{
    if (!self.didUpdateConstraint) {
        
        [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 2));
            make.center.equalTo(_circleView.superview);
        }];
        
        self.didUpdateConstraint = YES;
    }
    [super updateConstraints];
    
}

@end
