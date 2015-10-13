//
//  CSSendDoodleViewController.m
//  CloudSong
//
//  Created by sen on 15/6/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSendDoodleViewController.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSSlider.h"
#import "UIImage+Extension.h"
#import "CSPaletteView.h"
#import <UIImage+ColorAtPixel.h>
#import "SVProgressHUD.h"
@interface CSSendDoodleViewController ()
/** 返回按钮 */
@property(nonatomic, weak) UIButton *backButton;
/** 完成按钮 */
@property(nonatomic, weak) UIButton *confirmButton;
/** 画板 */
@property(nonatomic, weak) CSPaletteView *palette;
/** 粗细选择区域 */
@property(nonatomic, weak) UIView *lineWidthView;
/** 颜色选择区域 */
@property(nonatomic, weak) UIView *lineColorView;
/** 控制器区域 */
@property(nonatomic, weak) UIView *controlContainer;
/** 当前选中颜色按钮 */
@property(nonatomic, weak) UIButton *selectedColorButton;
/** 当前选中粗细数值 */
@property(nonatomic, assign) CGFloat selectedLineWidth;
@end

@implementation CSSendDoodleViewController

#pragma mark - Lazy Load
- (UIView *)lineWidthView
{
    if (!_lineWidthView) {
        UIView *lineWidthView = [[UIView alloc] init];
        lineWidthView.backgroundColor = HEX_COLOR(0x070708);
        [_controlContainer addSubview:lineWidthView];
        [lineWidthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(lineWidthView.superview);
        }];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = @"纤细";
        leftLabel.font = [UIFont systemFontOfSize:12.0];
        leftLabel.textColor = HEX_COLOR(0x8a8a8a);
        
        UILabel *centerLabel = [[UILabel alloc] init];
        centerLabel.text = @"适中";
        centerLabel.font = [UIFont systemFontOfSize:12.0];
        centerLabel.textColor = HEX_COLOR(0x8a8a8a);
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.text = @"浑厚";
        rightLabel.font = [UIFont systemFontOfSize:12.0];
        rightLabel.textColor = HEX_COLOR(0x8a8a8a);
        
        [lineWidthView addSubview:leftLabel];
        [lineWidthView addSubview:centerLabel];
        [lineWidthView addSubview:rightLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftLabel.superview).offset(-10.0);
            make.left.equalTo(leftLabel.superview).offset(27.0);
        }];
        [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftLabel);
            make.centerX.equalTo(centerLabel.superview);
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftLabel);
            make.right.equalTo(leftLabel.superview).offset(-27.0);
        }];
        
        CSSlider *slider = [[CSSlider alloc] init];
        slider.minimumValue = 1.0;
        slider.maximumValue = 10.0;
        slider.value = 5.5;
        _selectedLineWidth = slider.value;
        [slider addTarget:self action:@selector(lineWidthChanged:) forControlEvents:UIControlEventValueChanged];
        [slider setThumbImage:[UIImage imageNamed:@"remote_interaction_thickness_circle_btn"] forState:UIControlStateNormal];
        [slider setMaximumTrackImage:[[UIImage imageNamed:@"remote_interaction_thickness_bg_1"] resizedImage] forState:UIControlStateNormal] ;
        [slider setMinimumTrackImage:[[UIImage imageNamed:@"remote_interaction_thickness_bg_2"] resizedImage] forState:UIControlStateNormal];
        [lineWidthView addSubview:slider];
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(slider.superview).offset(27.0);
            make.right.equalTo(slider.superview).offset(-27.0);
            make.bottom.equalTo(leftLabel.mas_top).offset(-10.0);
        }];
        
        UIButton *okButton = [[UIButton alloc] init];
        [okButton setImage:[UIImage imageNamed:@"remote_interaction_ok_btn"] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [lineWidthView addSubview:okButton];
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(okButton.superview);
            make.top.equalTo(leftLabel.mas_bottom).offset(15.0);
        }];
        
        
        _lineWidthView = lineWidthView;
    }
    

    return _lineWidthView;
}

- (UIView *)lineColorView
{
    if (!_lineColorView) {
        UIView *lineColorView = [[UIView alloc] init];
        lineColorView.backgroundColor = HEX_COLOR(0x070708);
        [_controlContainer addSubview:lineColorView];
        [lineColorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(lineColorView.superview);
        }];
        
        CGFloat padding = 6.0;
        CGFloat colorButtonWidth = (SCREENWIDTH - 2 *padding) / 8;
        
        for (int i = 0; i < 8; i++) {
            UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [colorButton addTarget:self action:@selector(colorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [colorButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"remote_interaction_btn_%d",i]] forState:UIControlStateNormal];
            [colorButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"remote_interaction_btn_h_%d",i]] forState:UIControlStateSelected];
            [lineColorView addSubview:colorButton];
            [colorButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(colorButton.superview).offset(-30.0);
                make.size.mas_equalTo(CGSizeMake(colorButtonWidth, colorButtonWidth));
                make.left.equalTo(colorButton.superview).offset(padding + i * colorButtonWidth);
            }];
            
            if (i == 0) {
                colorButton.selected = YES;
                _selectedColorButton = colorButton;
            }
        }
        UIButton *okButton = [[UIButton alloc] init];
        [okButton setImage:[UIImage imageNamed:@"remote_interaction_ok_btn"] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [lineColorView addSubview:okButton];
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(okButton.superview);
            make.centerY.equalTo(okButton.superview).offset(30.0);
        }];
        

        _lineColorView = lineColorView;
    }
    return _lineColorView;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR(0x070708);
    [self setupSubViews];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;

}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupBackButton];
    [self setupConfirmButton];
    [self setupPalette];
    [self setupControlContainer];
    

}

- (void)setupBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"退出涂鸦" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [backButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backButton.superview).offset(40.0);
        make.left.equalTo(backButton.superview).offset(15.0);
    }];
    
}

- (void)setupConfirmButton
{
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"创作完成" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [confirmButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmButton.superview).offset(40.0);
        make.right.equalTo(confirmButton.superview).offset(-15.0);
    }];
}

- (void)setupPalette
{
    UIView *paletteBackView = [[UIView alloc] init];
    paletteBackView.backgroundColor = HEX_COLOR(0xf5f5f5);
    [self.view addSubview:paletteBackView];
    CSPaletteView *palette = [[CSPaletteView alloc] init];
    palette.lineWidth = 5.5;
    palette.lineColor = [UIColor blackColor];
    [self.view addSubview:palette];
    [palette mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(palette.superview);
        make.height.equalTo(palette.superview.mas_width);
        make.center.equalTo(palette.superview);
    }];
    _palette = palette;
    
    [paletteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(palette);
    }];
}

- (void)setupControlContainer
{
    UIView *controlContainer = [[UIView alloc] init];
    [self.view addSubview:controlContainer];
    _controlContainer = controlContainer;
    [controlContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_palette.mas_bottom);
        make.left.right.bottom.equalTo(controlContainer.superview);
    }];
    
    UIView *lineColorContainer = [self lineButtonContainerWithTitle:@"颜色" icon:[UIImage imageNamed:@"remote_interaction_color_icon"] sel:@selector(lineColorButtonPressed) longPressSel:nil];
    
    UIView *superLineColorContainer = [[UIView alloc] init];
    [superLineColorContainer addSubview:lineColorContainer];
    
    UIView *lineWidthContainer = [self lineButtonContainerWithTitle:@"粗细" icon:[UIImage imageNamed:@"remote_interaction_thickness_icon"] sel:@selector(lineWidthButtonPressed) longPressSel:nil];
    UIView *superLineWidthContainer = [[UIView alloc] init];
    [superLineWidthContainer addSubview:lineWidthContainer];
    
    UIView *linelastStepContainer = [self lineButtonContainerWithTitle:@"撤销" icon:[UIImage imageNamed:@"remote_interaction_revoke_icon"] sel:@selector(linelastStepButtonPressed) longPressSel:nil];
    UIView *superLinelastStepContainer = [[UIView alloc] init];
    [superLinelastStepContainer addSubview:linelastStepContainer];
    
    [lineColorContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(lineColorContainer.superview);
    }];
    [lineWidthContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(lineWidthContainer.superview);
    }];
    [linelastStepContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(linelastStepContainer.superview);
    }];
    
    [controlContainer addSubview:superLineColorContainer];
    [controlContainer addSubview:superLineWidthContainer];
    [controlContainer addSubview:superLinelastStepContainer];
    
    CGFloat width = SCREENWIDTH / 3;
    [superLineWidthContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(superLineWidthContainer.superview);
        make.width.mas_equalTo(width);
    }];
    
    [superLineColorContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superLineWidthContainer.mas_right);
        make.top.bottom.equalTo(superLineColorContainer.superview);
        make.width.mas_equalTo(width);
    }];
    
    [superLinelastStepContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superLineColorContainer.mas_right);
        make.top.bottom.equalTo(superLinelastStepContainer.superview);
        make.width.mas_equalTo(width);
    }];
}

- (UIView *)lineButtonContainerWithTitle:(NSString *)title icon:(UIImage *)icon sel:(SEL)sel longPressSel:(SEL)longPressSel
{
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    if (longPressSel) {
        [button addTarget:self action:longPressSel forControlEvents:UIControlEventTouchDownRepeat];
    }
    [button setImage:[icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = HEX_COLOR(0xffcc00);
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = title;
    [container addSubview:button];
    [container addSubview:label];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.superview);
        make.centerX.equalTo(button.superview);
        make.right.lessThanOrEqualTo(button.superview);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(10.0);
        make.bottom.equalTo(label.superview);
        make.centerX.equalTo(label.superview);
        make.right.lessThanOrEqualTo(label.superview);
    }];

    return container;
}


#pragma mark - Action Methods

- (void)backButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonPressed
{
    // TODO
    UIImage *paletteImage = [_palette getImageFromPalette];
//    UIImageWriteToSavedPhotosAlbum(paletteImage,self,nil,nil);
#warning 涂鸦创建完成后需要的操作
    
    if ([self.delegate respondsToSelector:@selector(sendDoodleViewControllerDidFinishDoodleImage:)]) {
        [self.delegate sendDoodleViewControllerDidFinishDoodleImage:paletteImage];
    }
    
//    [UIView animateWithDuration:1.0 animations:^{
//        [SVProgressHUD showSuccessWithStatus:@"创建完成"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
    [SVProgressHUD showSuccessWithStatus:@"创建完成"];
    [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } completion:nil];
}

- (void)lineWidthButtonPressed
{
    // TODO
    self.lineWidthView.hidden = NO;
     
}

- (void)lineColorButtonPressed
{
    self.lineColorView.hidden = NO;
}

- (void)linelastStepButtonPressed
{
    [_palette previous];
}

- (void)linelongPressButtonPressed
{
    [_palette clear];
}

- (void)okButtonPressed:(UIButton *)button
{
    button.superview.hidden = YES;
    
    // TODO
}

- (void)colorButtonPressed:(UIButton *)button
{
    _selectedColorButton.selected = NO;
    _selectedColorButton = button;
    _palette.lineColor = [button.currentImage colorAtPixel:CGPointMake(button.currentImage.size.width * 0.5, button.currentImage.size.height * 0.5)];
    button.selected = YES;
}

- (void)lineWidthChanged:(UISlider *)slider
{
    _palette.lineWidth = slider.value;
}
@end
