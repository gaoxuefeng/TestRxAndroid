//
//  CSInteractionViewController.m
//  CloudSong
//
//  Created by sen on 15/6/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSInteractionViewController.h"
#import <Masonry.h>
#import "CSDefine.h"
#import <FXBlurView.h>
#import "CSSendTextViewController.h"
#import "CSSendDoodleViewController.h"
#import "CSSendFaceViewController.h"
#import "CSActionSheet.h"
#define PADDING 75.0
@interface CSInteractionViewController ()<CSActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, weak) UIImage *backgroundImage;

@property(nonatomic, weak) UIImageView *backgroundImageView;
@property(nonatomic, weak) UIImageView *blurBackgroundImageView;
/** 互动按钮集合 */
@property(nonatomic, strong) NSMutableArray *buttons;

@property(nonatomic, strong) NSMutableArray *labels;

@property(nonatomic, weak) UIButton *cancelButton;

@property(nonatomic, weak) MASConstraint *blurBackgroundImageViewSize;

@end


@implementation CSInteractionViewController


- (instancetype)initWithBGImage:(UIImage *)bgImage
{
    
    _backgroundImage = bgImage;
    return [self init];
}
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"遥控";
    [self setupSubViews];
    
}

#pragma mark - Setup

- (void)setupSubViews
{
    [self setupBackgroundImageView];
    [self setupBlurBackgroundImageView];
    [self setupButtons];
    [self setupCancelButton];
    [self spread];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}



- (void)setupBackgroundImageView
{
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = _backgroundImage;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundImageView.superview);
    }];
}

- (void)setupBlurBackgroundImageView
{
    UIImage *blurImage = [_backgroundImage blurredImageWithRadius:20 iterations:10 tintColor:[UIColor clearColor]];
    UIImageView *blurBackgroundImageView = [[UIImageView alloc] init];
    blurBackgroundImageView.image = blurImage;
    blurBackgroundImageView.layer.masksToBounds = YES;
    blurBackgroundImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:blurBackgroundImageView];

    [blurBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        _blurBackgroundImageViewSize = make.size.mas_equalTo(CGSizeZero);
        make.center.equalTo(blurBackgroundImageView.superview);
    }];
    _blurBackgroundImageView = blurBackgroundImageView;

}

- (void)setupButtons
{
    
    _buttons = [NSMutableArray array];
    // 发文字
    UIButton *sendTextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendTextButton addTarget:self action:@selector(sendTextBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [sendTextButton setImage:[[UIImage imageNamed:@"remote_interaction_text_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    sendTextButton.alpha =  0.0;
    [self.view addSubview:sendTextButton];
    [_buttons addObject:sendTextButton];
    // 发涂鸦
    UIButton *sendDoodleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendDoodleButton addTarget:self action:@selector(sendDoodleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [sendDoodleButton setImage:[[UIImage imageNamed:@"remote_interaction_diy_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    sendDoodleButton.alpha =  0.0;
    [self.view addSubview:sendDoodleButton];
     [_buttons addObject:sendDoodleButton];
    
    // 发图片
    UIButton *sendPictureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendPictureButton addTarget:self action:@selector(sendPictureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [sendPictureButton setImage:[[UIImage imageNamed:@"remote_interaction_img_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    sendPictureButton.alpha =  0.0;
    [self.view addSubview:sendPictureButton];
     [_buttons addObject:sendPictureButton];
    
    // 发表情
    UIButton *sendFaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendFaceButton addTarget:self action:@selector(sendFaceBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [sendFaceButton setImage:[[UIImage imageNamed:@"remote_interaction_expression_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    sendFaceButton.alpha =  0.0;
    [self.view addSubview:sendFaceButton];
     [_buttons addObject:sendFaceButton];
    
    
    
    
    
    [sendTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sendTextButton.superview);
        make.centerY.equalTo(sendTextButton.superview);
    }];
    
    [sendDoodleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sendDoodleButton.superview);
        make.centerY.equalTo(sendDoodleButton.superview);
    }];
    
    [sendPictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sendPictureButton.superview);
        make.centerY.equalTo(sendPictureButton.superview);
    }];
    
    [sendFaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sendFaceButton.superview);
        make.centerY.equalTo(sendFaceButton.superview);
    }];
    
    _labels  = [NSMutableArray array];
    UILabel *sendTextLabel = [[UILabel alloc] init];
    sendTextLabel.alpha = 0.0;
    sendTextLabel.text = @"发文字";
    sendTextLabel.font = [UIFont systemFontOfSize:14.0];
    sendTextLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self.view addSubview:sendTextLabel];
    [_labels addObject:sendTextLabel];
    UILabel *sendDoodleLabel = [[UILabel alloc] init];
    sendDoodleLabel.alpha = 0.0;
    sendDoodleLabel.text = @"发涂鸦";
    sendDoodleLabel.font = [UIFont systemFontOfSize:14.0];
    sendDoodleLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self.view addSubview:sendDoodleLabel];
    [_labels addObject:sendDoodleLabel];
    
    UILabel *sendPictureLabel = [[UILabel alloc] init];
    sendPictureLabel.alpha = 0.0;
    sendPictureLabel.text = @"发图片";
    sendPictureLabel.font = [UIFont systemFontOfSize:14.0];
    sendPictureLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self.view addSubview:sendPictureLabel];
    [_labels addObject:sendPictureLabel];
    
    UILabel *sendFaceLabel = [[UILabel alloc] init];
    sendFaceLabel.alpha = 0.0;
    sendFaceLabel.text = @"发表情";
    sendFaceLabel.font = [UIFont systemFontOfSize:14.0];
    sendFaceLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self.view addSubview:sendFaceLabel];
    [_labels addObject:sendFaceLabel];
    
    
    CGFloat padding =AUTOLENGTH(PADDING);
    for (int i = 0; i < _labels.count; i++) {
        UILabel *label = _labels[i];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label.superview).offset(i % 2?padding:-padding);
            make.centerY.equalTo(label.superview).offset((i / 2?padding:-padding) + 50);
        }];
    }
    
    
    

}

- (void)setupCancelButton
{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImage:[[UIImage imageNamed:@"remote_interaction_close_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    cancelButton.backgroundColor = HEX_COLOR(0x1b1b1e);
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(cancelButton.superview);
        make.height.mas_equalTo(44.0);
    }];
    cancelButton.alpha = 0.0;
    _cancelButton = cancelButton;
}


#pragma mark - Animation
- (void)spread
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        _blurBackgroundImageViewSize.sizeOffset = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self iconSpread];
    }];
}

- (void)iconSpread
{
    CGFloat padding =AUTOLENGTH(PADDING);
    [self.view layoutIfNeeded];
    for (int i = 0; i < _buttons.count; i++) {
        UIButton *button = _buttons[i];
        NSInteger delayI = i;
        if (i == 2) {
            delayI = 3;
        }else if(i == 3)
        {
            delayI = 2;
        }
        CGFloat delayDuration = delayI * 0.05 + 0.1;
        [UIView animateWithDuration:0.3 delay:delayDuration usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button.superview).offset(i % 2?padding:-padding);
                make.centerY.equalTo(button.superview).offset(i / 2?padding:-padding);
            }];
            button.alpha = 1.0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
        UILabel *label = _labels[i];
        [UIView animateWithDuration:0.3 delay:delayI * 0.1 + 0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _cancelButton.alpha = 1.0;
            }];
        }];
    }
}

- (void)shrink
{
    [self.view layoutIfNeeded];
    CGFloat padding = AUTOLENGTH(PADDING + 30);
    for (int i = 0; i < _buttons.count; i++) {
        UIButton *button = _buttons[i];
        
        NSInteger delayI = i;
        if (i == 2) {
            delayI = 3;
        }else if (i == 3)
        {
            delayI = 2;
        }
        
        CGFloat delayDuration = delayI * 0.05 + 0.1;
        [UIView animateWithDuration:0.1 delay:delayDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button.superview).offset(i % 2?padding:-padding);
                make.centerY.equalTo(button.superview).offset(i / 2?padding:-padding);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.offset = 0;
                    make.centerY.offset = 0;
                }];
                button.alpha = 0.0;
                [self.view layoutIfNeeded];
            } completion:nil];
            
            UILabel *label = _labels[i];
            [UIView animateWithDuration:0.3 delay:delayI * 0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (i == _buttons.count - 1) {
                    [UIView animateWithDuration:0.3 animations:^{
                        _cancelButton.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        [self.navigationController popViewControllerAnimated:NO];
                    }];
                }
            }];
        }];
    }
}


#pragma mark - Action
- (void)cancelBtnPressed
{
    [self shrink];
}

- (void)sendTextBtnPressed
{
    CSSendTextViewController *sendTextVc = [[CSSendTextViewController alloc] init];

    [self.navigationController pushViewController:sendTextVc animated:YES];
}

- (void)sendDoodleBtnPressed
{
    CSSendDoodleViewController *sendDoodleVc = [[CSSendDoodleViewController alloc] init];
    UINavigationController *navVc = self.navigationController;
    
    [navVc presentViewController:sendDoodleVc animated:YES completion:^{
        [navVc popViewControllerAnimated:NO];
    }];
}

- (void)sendPictureBtnPressed
{
    CSActionSheet *actionSheet = [[CSActionSheet alloc] initWithDelegate:self headerTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    [actionSheet show];
}

- (void)sendFaceBtnPressed
{
    CSSendFaceViewController *sendFaceVc = [[CSSendFaceViewController alloc] init];
    UINavigationController *navVc = self.navigationController;
    [navVc popViewControllerAnimated:NO];
    [navVc pushViewController:sendFaceVc animated:YES];
}

#pragma mark - CSActionSheetDelegate
- (void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (buttonIndex == 1) { // 拍照
        [self openCamera];
    }else   // 相册取照片
    {
        [self openAlbum];
    }
}

// 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

// 打开图册
- (void)openAlbum
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
//    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    
}

- (void)dealloc
{
    CSLog(@"互动挂了");
}


@end
