//
//  CSEditUserIconViewController.m
//  CloudSong
//
//  Created by sen on 15/6/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSEditUserIconViewController.h"
#import "CSActionSheet.h"
#import <FXBlurView.h>
#import <Masonry.h>
#import "UIImage+Extension.h"
#import "CSCircleImageSelectorView.h"
#import "SVProgressHUD.h"
//#import <RSKImageCropper.h>
#import "RSKImageCropper.h"
#import "CSLoginHttpTool.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageDownloader.h>
#import "CSActionSheet.h"
#import <AVFoundation/AVFoundation.h>
#define ANIMATION_DURATION 0.3
#define PICTURE_RADIUS 85.0
#define SELECT_VIEW_Y 135.0
@interface CSEditUserIconViewController ()<CSActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,RSKImageCropViewControllerDataSource,RSKImageCropViewControllerDelegate>
@property(nonatomic, strong) UIImage *userIcon;
/** 背景头像 */
@property(nonatomic, strong) UIImageView *bgView;
/** 用户头像 */
@property(nonatomic, strong) UIImageView *iconView;
/** 用于点击放大时候的头像容器 */
@property(nonatomic, weak) UIImageView *imageView;
/** 遮罩 */
@property(nonatomic, weak) UIView *cover;
/** 更换头像 */
@property(nonatomic, strong) UIButton *editButton;
/** 确认图片 */
@property(nonatomic, strong) UIButton *confirmButton;

@property(nonatomic, weak) UIImageView *editImageView;

@property(nonatomic, weak) CSCircleImageSelectorView *showImageView;

@property(nonatomic, strong) UIImage *selectedImage;

@property(nonatomic, weak) CSActionSheet *saveIconActionSheet;
/** 图片是否展开 */
@property(nonatomic, assign,getter=isSpread) BOOL spread;



@end

@implementation CSEditUserIconViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _userIcon = GlobalObj.userIcon?GlobalObj.userIcon:[UIImage imageNamed:@"mine_default_user_icon"];

    [self setupSubViews];
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupBgView];
    [self setupIconView];
    [self setupEditButton];
}

- (void)setupBgView
{
    UIImage *blurUserIcon = [_userIcon blurredImageWithRadius:10.0 iterations:20.0 tintColor:[UIColor clearColor]];
    _bgView = [[UIImageView alloc] init];
    _bgView.layer.masksToBounds = YES;
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.8;
    [_bgView addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cover.superview);
    }];
    [self.view addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgView.superview);
    }];
    _bgView.image = blurUserIcon;
}

- (void)setupIconView
{
    _iconView = [[UIImageView alloc] init];
    _iconView.userInteractionEnabled = YES;
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = PICTURE_RADIUS;
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconView.superview);
        make.top.equalTo(_iconView.superview).offset(135.0);
        make.size.mas_equalTo(CGSizeMake(PICTURE_RADIUS * 2, PICTURE_RADIUS * 2));
    }];


    [_iconView sd_setImageWithURL:[NSURL URLWithString:GlobalObj.userInfo.headUrl] placeholderImage:_userIcon];

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewPressed:)];
    [_iconView addGestureRecognizer:tapGr];
}



- (void)setupEditButton
{
    CGFloat radius = 22.5;
    _editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_editButton addTarget:self action:@selector(editBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_editButton setTitle:@"更换头像" forState:UIControlStateNormal];
    [_editButton setTitleColor:HEX_COLOR(0xb5b7bf) forState:UIControlStateNormal];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _editButton.layer.cornerRadius = radius;
    _editButton.layer.masksToBounds = YES;
    _editButton.layer.borderWidth = 1.0;
    _editButton.layer.borderColor = HEX_COLOR(0x616f60).CGColor;
    [self.view addSubview:_editButton];
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_editButton.superview).offset(55.0);
        make.right.equalTo(_editButton.superview).offset(-55.0);
        make.height.mas_equalTo(2 * radius);
        make.centerY.equalTo(_editButton.superview).offset(100.0);
    }];
}

#pragma mark - Action
- (void)editBtnOnClick
{
    CSActionSheet *actionSheet = [[CSActionSheet alloc] initWithDelegate:self headerTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    [actionSheet show];
}

- (void)coverTap:(UITapGestureRecognizer *)tapGr
{
    if (self.isSpread) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = @0;
        animation.toValue = [NSNumber numberWithFloat:PICTURE_RADIUS];
        animation.duration = ANIMATION_DURATION;
        animation.delegate = self;
        _imageView.layer.cornerRadius = PICTURE_RADIUS;
        [_imageView.layer addAnimation:animation forKey:@"cornerRadius"];
    }
}

- (void)coverLongPress:(UILongPressGestureRecognizer *)tapGr
{
    if (tapGr.state == UIGestureRecognizerStateBegan)
    {
        CSActionSheet *saveIconActionSheet = [[CSActionSheet alloc] initWithDelegate:self headerTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"保存图片"]];
        _saveIconActionSheet = saveIconActionSheet;
        [saveIconActionSheet show];
    }
}

- (void)iconViewPressed:(UITapGestureRecognizer *)tapGr
{
    if (!self.isSpread) { // 没展开时,展开
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *cover = [[UIView alloc] init];
        UILongPressGestureRecognizer *coverLongPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(coverLongPress:)];
        UITapGestureRecognizer *coverTapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap:)];
        [cover addGestureRecognizer:coverTapGr];
        [cover addGestureRecognizer:coverLongPressGr];
        cover.alpha = 0.0;
        cover.backgroundColor = [UIColor blackColor];
        _cover = cover;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        imageView.image = _userIcon;
        imageView.layer.cornerRadius = PICTURE_RADIUS;
        imageView.layer.masksToBounds = YES;
        [keyWindow addSubview:cover];
        [keyWindow addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView.superview);
            make.top.equalTo(imageView.superview).offset(135.0);
            make.size.mas_equalTo(CGSizeMake(PICTURE_RADIUS * 2, PICTURE_RADIUS * 2));
        }];
        
        [cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cover.superview);
        }];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = [NSNumber numberWithFloat:PICTURE_RADIUS];
        animation.toValue = @0;
        animation.duration = ANIMATION_DURATION;
        animation.delegate = self;
        imageView.layer.cornerRadius = 0.0;
        [imageView.layer addAnimation:animation forKey:@"cornerRadius"];
    }
}

- (void)animationDidStart:(CAAnimation *)anim
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow layoutIfNeeded];
    _iconView.hidden = YES;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        if (self.spread) {
            [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_imageView.superview);
                make.top.equalTo(_imageView.superview).offset(135.0);
                make.size.mas_equalTo(CGSizeMake(PICTURE_RADIUS * 2, PICTURE_RADIUS * 2));
            }];
            _cover.alpha = 0.0;
        }else
        {
            [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_imageView.superview);
                make.size.mas_equalTo(CGSizeMake(SCREENWIDTH, SCREENWIDTH));
            }];
            _cover.alpha = 1.0;
        }
        [keyWindow layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.spread) {
            _iconView.hidden = NO;
            [_cover removeFromSuperview];
            [_imageView removeFromSuperview];
        }
        self.spread = !self.spread;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_imageView.layer removeAnimationForKey:@"cornerRadius"];
}


#pragma mark - CSActionSheetDelegate
- (void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (actionSheet == _saveIconActionSheet) { // 保存图片actionSheet
        UIImageWriteToSavedPhotosAlbum(GlobalObj.userIcon, self, nil, nil);
    }else // 拍照OR相册
    {
        if (buttonIndex == 1) { // 拍照
            [self openCamera];
        }else   // 相册取照片
        {
            [self openAlbum];
        }
    }
}

// 打开相机
- (void)openCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中，允许潮趴汇访问你的相机。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }
}

// 打开图册
- (void)openAlbum
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    _selectedImage = selectedImage;
    RSKImageCropViewController *cropVc = [[RSKImageCropViewController alloc] initWithImage:selectedImage cropMode:RSKImageCropModeCustom];
    cropVc.delegate = self;
    cropVc.dataSource = self;
    cropVc.avoidEmptySpaceAroundImage = YES;
    cropVc.rotationEnabled = YES;
    
    CGFloat showImageViewW = PICTURE_RADIUS * 2;
    CGFloat showImageViewH = showImageViewW;
    CGFloat showImageViewX = (self.view.width - showImageViewW) * 0.5;
    CGFloat showImageViewY =SELECT_VIEW_Y;

    CSCircleImageSelectorView *showImageView = [[CSCircleImageSelectorView alloc] initWithCircleRect:CGRectMake(showImageViewX, showImageViewY, showImageViewW, showImageViewH)];
    showImageView.frame = self.view.bounds;
    [cropVc.view addSubview:showImageView];
    [self.navigationController pushViewController:cropVc animated:NO];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CSLog(@"图像选择器将要显示");
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CSLog(@"图像选择器显示结束");
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    [SVProgressHUD show];
    CSRequest *param = [[CSRequest alloc] init];
    param.picName = @"userIcon.jpg";
    NSData *imageData = UIImageJPEGRepresentation(croppedImage, 0.5);
    CSLog(@"上传图片大小 = %fM",imageData.length / (1024.0 * 1024.0));
    NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    param.picValue = imageString;
    // 用于上传的image图片
    UIImage *uploadImage = [UIImage imageWithData:imageData];

    [CSLoginHttpTool uploadIconWithParam:param success:^(CSImageUploadingResponseModel *result) {
        if (result.code == ResponseStateSuccess && result.data.imageUrl.length>0) {
            GlobalObj.userInfo.headUrl = result.data.imageUrl;
            [SVProgressHUD dismiss];
            GlobalObj.userIcon = uploadImage;
            [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
        CSLog(@"%@",error);
    }];    
}



#pragma mark - RSKImageCropViewControllerDataSource
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    return self.view.bounds;
}

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGFloat showImageViewW = PICTURE_RADIUS * 2;
    CGFloat showImageViewH = showImageViewW;
    CGFloat showImageViewX = (self.view.width - showImageViewW) * 0.5;
    CGFloat showImageViewY = SELECT_VIEW_Y;
    CGRect rect = CGRectMake(showImageViewX, showImageViewY, showImageViewW, showImageViewH);
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    CGFloat showImageViewW = PICTURE_RADIUS * 2;
    CGFloat showImageViewH = showImageViewW;
    CGFloat showImageViewX = (self.view.width - showImageViewW) * 0.5;
    CGFloat showImageViewY = SELECT_VIEW_Y;
    return  CGRectMake(showImageViewX, showImageViewY, showImageViewW, showImageViewH);
}


@end
