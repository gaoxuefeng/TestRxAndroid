//
//  CSActionSheet.m
//  CloudSong
//
//  Created by sen on 15/6/19.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSActionSheet.h"
#import "CSDefine.h"
#import "UIImage+Extension.h"
#import <Masonry.h>
#define HEADER_HEIGHT TRANSFER_SIZE(44.0)
@interface CSActionSheet ()
@property(nonatomic, copy) NSString *headerTitle;
@property(nonatomic, weak) UILabel *headerTitleLabel;
@property(nonatomic, weak) UIButton *cover;
@property(nonatomic, weak) UIView *optionView;
@property(nonatomic, strong) NSMutableArray *titles;
@property(nonatomic, strong) NSMutableArray *titleButtons;
@property(nonatomic, strong) NSMutableArray *lines;
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) MASConstraint *optionSheetOffset;
@end

@implementation CSActionSheet
#pragma mark - Public Methods
- (instancetype)initWithDelegate:(id<CSActionSheetDelegate>)delegate headerTitle:(NSString *)headerTitle cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *)otherTitles
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _headerTitle = headerTitle;
        _titles = [NSMutableArray arrayWithArray:otherTitles];
        [_titles insertObject:cancelTitle atIndex:0];
//        CSLog(@"%d",_titles.count);
        [self setupSubViews];
    }
    return self;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index
{
    return [_titleButtons[index] currentTitle];
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview);
    }];
    

    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _optionSheetOffset.offset = -_optionView.height;
        _cover.alpha = 0.5;
        [self layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupCover];
    [self setupOptionView];
    
    
}

- (void)setupOptionView
{
    
    if (_headerTitle.length > 0) {
        UILabel *headerTitleLabel = [[UILabel alloc] init];
        headerTitleLabel.text = _headerTitle;
        headerTitleLabel.textColor = HEX_COLOR(0xb5b7bf);
        headerTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(16.0)];
        headerTitleLabel.textAlignment = NSTextAlignmentCenter;
        headerTitleLabel.backgroundColor = HEX_COLOR(0x381e59);
//        headerTitleLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];

        [self addSubview:headerTitleLabel];
        _headerTitleLabel = headerTitleLabel;
    }
    
    
    UIView *optionView = [[UIView alloc] init];
    optionView.backgroundColor = HEX_COLOR(0x381e59);
    [self addSubview:optionView];
    _optionView = optionView;
    
    _titleButtons = [NSMutableArray arrayWithCapacity:_titles.count];
    for (int i = 0; i < _titles.count; i++) { // 按钮
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [titleButton setBackgroundImage:[[[UIImage imageNamed:@"action_sheet_bg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] resizedImage] forState:UIControlStateNormal];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:_titles[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:HEX_COLOR(0xb5b7bf) forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(16.0)];
        [optionView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
    }
    NSInteger lineCount = _titles.count - 2;
    _lines = [NSMutableArray arrayWithCapacity:lineCount];
    for (int i = 0; i < lineCount; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEX_COLOR(0x1d1d1d);
        [optionView addSubview:line];
        [self.lines addObject:line];
    }
}

- (void)setupCover
{
    UIButton *cover = [[UIButton alloc] init];
    [cover addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [self addSubview:cover];
    _cover = cover;
    
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        if (_headerTitle.length > 0) {
            [_headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_optionView.mas_top);
                make.height.mas_equalTo(HEADER_HEIGHT);
                make.left.right.equalTo(_headerTitleLabel.superview);
            }];
        }
        
        [_cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_cover.superview);
        }];
        
        [_optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            _optionSheetOffset = make.top.equalTo(_optionView.superview.mas_bottom).offset(_headerTitle>0?HEADER_HEIGHT:0);
            make.left.right.equalTo(_optionView.superview);
        }];
        
        for (int i = 0; i < _titleButtons.count; i++) {
            UIButton *titleButton = _titleButtons[i];
            if (i == 0) { // 取消按钮
                [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.left.right.equalTo(titleButton.superview);
                    make.height.mas_equalTo(TRANSFER_SIZE(57.0));
                }];
            }else if (i == 1) { // 第一个按钮
                [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(titleButton.superview);
                    make.height.mas_equalTo(TRANSFER_SIZE(57.0));
                    if (_titleButtons.count == 2) {
                        make.bottom.equalTo([_titleButtons[0] mas_top]).offset(-TRANSFER_SIZE(6.0));
                    }
                }];
                
            }else   // 之后的按钮
            {
                UIView *line = _lines[i - 2];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(line.superview);
                    make.top.equalTo([_titleButtons[i - 1] mas_bottom]);
                    make.height.mas_equalTo(TRANSFER_SIZE(0.5));
                }];
                
                
                if (i == _titleButtons.count - 1) { // 如果是最后一个 则设置和取消按钮的距离约束
                    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(line.mas_bottom);
                        make.left.right.equalTo(titleButton.superview);
                        make.height.mas_equalTo(TRANSFER_SIZE(57.0));
                        make.bottom.equalTo([_titleButtons[0] mas_top]).offset(-TRANSFER_SIZE(6.0));
                    }];
                }else
                {
                    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(line.mas_bottom);
                        make.left.right.equalTo(titleButton.superview);
                        make.height.mas_equalTo(TRANSFER_SIZE(57.0));
                    }];
                }
            }
        }
        
        
        _didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}


#pragma mark - Action
- (void)btnOnClick:(UIButton *)button
{
    if (button.tag) {
        if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
            [self.delegate actionSheet:self clickedButtonAtIndex:button.tag];
        }
    }
    [self cancel];
}

- (void)cancel
{
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _optionSheetOffset.offset = _headerTitle>0?HEADER_HEIGHT:0;
        _cover.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}





@end
