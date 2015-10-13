//
//  CSQRCodeReadViewController.m
//  CloudSong
//
//  Created by sen on 5/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSQRCodeReadViewController.h"
#import <ZXingObjC.h>
#import "CSClearInsideView.h"
#import "CSDefine.h"
#import <Masonry.h>
@interface CSQRCodeReadViewController ()<ZXCaptureDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) ZXCapture *capture;
/** 扫描网 */
@property(nonatomic, weak) UIImageView *scanNetView;
/** 遮罩 */
@property(nonatomic, weak) CSClearInsideView *cover;
/** 扫描边框 */
@property(nonatomic, weak) UIImageView *scanAreaImageView;
/** 扫描网动画 */
@property(nonatomic, assign) BOOL animated;
@property(nonatomic, strong) ZXResult *result;
@end

@implementation CSQRCodeReadViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCaptureView];
    [self setupFlashLightButton];
    [self setupBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self scanNetAnimation];
//    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(_scanAreaImageView.frame, captureSizeTransform);
}

- (void)dealloc {
    CSLog(@"扫描器挂了");
    [self.capture.layer removeFromSuperlayer];
}

#pragma mark - Setup

- (void)setupCaptureView
{
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    // 可扫描区域
    CGFloat padding = 3.0;
    
    UIImage *scanAreaImage = [UIImage imageNamed:@"code_frame"];
    // 扫描区域frame
    CGFloat scanAreaW = scanAreaImage.size.width - 2 * padding;
    CGFloat scanAreaH = scanAreaImage.size.height -  2 *padding;
    CGFloat scanAreaX = (self.view.width - scanAreaW) * 0.5;
    CGFloat scanAreaY = 134.0 + padding;
    CGRect scanAreaRect = CGRectMake(scanAreaX, scanAreaY, scanAreaW, scanAreaH);
    
    // 扫描区域图frame
    CGFloat borderW = scanAreaImage.size.width;
    CGFloat borderH = scanAreaImage.size.height;
    CGFloat borderX = (self.view.width - borderW) * 0.5;
    CGFloat borderY = 134.0;
    CGRect borderRect = CGRectMake(borderX, borderY, borderW, borderH);
    
    // 遮罩
    CSClearInsideView *cover = [[CSClearInsideView alloc] initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    cover.clearRect = scanAreaRect;
    [self.view addSubview:cover];
    _cover = cover;
    
    // 边框
    UIImageView *scanAreaImageView = [[UIImageView alloc] initWithImage:scanAreaImage];
    _scanAreaImageView = scanAreaImageView;
    scanAreaImageView.layer.masksToBounds = YES;
    scanAreaImageView.frame = borderRect;
    [self.view addSubview:scanAreaImageView];
    
    // 扫描网图片
    UIImageView *scanNetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code_scan"]];
    self.animated = YES;
    scanNetView.x = (scanAreaImageView.width - scanNetView.width) * 0.5;
    scanNetView.y =  - scanNetView.height;
    [scanAreaImageView addSubview:scanNetView];
    _scanNetView = scanNetView;
    
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.font = [UIFont systemFontOfSize:13.0];
    firstLabel.textColor = HEX_COLOR(0xe3e3e3);
    firstLabel.text = @"点击点歌台上的\"手机\"点歌";
    [self.view addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(scanAreaImageView.mas_bottom).offset(48.0);
    }];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.font = [UIFont systemFontOfSize:17.0];
    secondLabel.textColor = HEX_COLOR(0xff41ab);
    secondLabel.text = @"扫描二维码连接房间";
    [self.view addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(firstLabel.mas_bottom).offset(10.0);
    }];
    
    UILabel *thirdLabel = [[UILabel alloc] init];
    thirdLabel.font = [UIFont systemFontOfSize:12.0];
    thirdLabel.textColor = HEX_COLOR(0x6f6f70);
    thirdLabel.text = @"请使用KTV提供的免费WiFi";
    [self.view addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(secondLabel.mas_bottom).offset(32.0);
    }];
}

- (void)setupFlashLightButton
{
    UIButton *flashLightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashLightButton addTarget:self action:@selector(flashLightBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [flashLightButton setBackgroundImage:[UIImage imageNamed:@"code_on_btn"] forState:UIControlStateNormal];
    [flashLightButton setBackgroundImage:[UIImage imageNamed:@"code_off_btn"] forState:UIControlStateSelected];
    [self.view addSubview:flashLightButton];
    [flashLightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(92.0);
        make.size.mas_equalTo(flashLightButton.currentBackgroundImage.size);
    }];
}


- (void)setupBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton addTarget:self action:@selector(backBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[[UIImage imageNamed:@"control_navigationbar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(20.0);
        make.size.mas_equalTo(CGSizeMake(50.0, 50.0));
    }];
    
}





- (void)scanNetAnimation
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2.0 animations:^{
        self.scanNetView.y = self.scanAreaImageView.height;
    } completion:^(BOOL finished) {
        weakSelf.scanNetView.y =  - weakSelf.scanNetView.height;
        if (weakSelf.animated) {
            [weakSelf scanNetAnimation];
        }
    }];
}



- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - Action
- (void)backBtnOnClick
{
//    [self.readerView stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)flashLightBtnOnClick:(UIButton *)button
{
    // 选中为开
    button.selected = !button.selected;
    _capture.torch = button.selected;
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    if (_result) return;
    _result = result;
    self.animated = NO;
    // We got a result. Display information about the result onscreen.
//    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
//    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    NSArray *textArray = [result.text componentsSeparatedByString:@"|"];
    if (textArray.count != 3) {
        [self.capture stop];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"二维码不是你想扫,想扫就能扫~" delegate:self cancelButtonTitle:@"哦" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(codeReadControllerDidFinishReadWithServerIP:code:roomNum:)]) {
        [self.delegate codeReadControllerDidFinishReadWithServerIP:textArray[0] code:textArray[2] roomNum:textArray[1]];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.capture stop];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _result = nil;
    [self.capture start];
}



@end
