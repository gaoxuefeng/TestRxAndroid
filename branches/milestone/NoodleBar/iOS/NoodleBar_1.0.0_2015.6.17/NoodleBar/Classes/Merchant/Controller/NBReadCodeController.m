//
//  NBReadCodeController.m
//  NoodleBar
//
//  Created by sen on 5/28/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBReadCodeController.h"
#import "NBCover.h"
#import "NBNavBar.h"
#import <ZXingObjC.h>

@interface NBReadCodeController () <ZXCaptureDelegate,UIAlertViewDelegate>
{
    NBNavBar *_navBar;
    ZXResult *_result;
}
/** 扫描控制器 */
@property (nonatomic, strong) ZXCapture *capture;
/** 扫描网 */
@property(nonatomic, weak) UIImageView *scanNetView;
/** 遮罩 */
@property(nonatomic, weak) NBCover *cover;
/** 扫描边框 */
@property(nonatomic, weak) UIImageView *scanAreaImageView;
/** 扫描网动画 */
@property(nonatomic, assign) BOOL animated;
@end

@implementation NBReadCodeController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_COLOR(0x191919);
    
    [self setupReaderView];
    [self setupNavBar];
}

- (void)setupNavBar
{
    _navBar = [[NBNavBar alloc] init];
    _navBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [_navBar setTitle:@"扫一扫"];
    [self.view addSubview:_navBar];
    [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_navBar.superview);
        make.height.mas_equalTo(64.0);
    }];
    [_navBar backButtonAddTarget:self Action:@selector(backBtnOnClick:)];
}

- (void)setupReaderView
{
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    // 可扫描区域
    CGFloat padding = 2.0;
    
    UIImage *scanAreaImage = [UIImage imageNamed:@"scan_code_bg"];
    CGFloat scanAreaW = scanAreaImage.size.width - 2 * padding;
    CGFloat scanAreaH = scanAreaImage.size.height -  2 *padding;
    CGFloat scanAreaX = (self.view.width - scanAreaW) * 0.5;
    CGFloat scanAreaY = 125.0 + padding;
    CGRect scanAreaRect = CGRectMake(scanAreaX, scanAreaY, scanAreaW, scanAreaH);
    
    CGFloat borderW = scanAreaImage.size.width;
    CGFloat borderH = scanAreaImage.size.height;
    CGFloat borderX = (self.view.width - borderW) * 0.5;
    CGFloat borderY = 125.0;
    CGRect borderRect = CGRectMake(borderX, borderY, borderW, borderH);

    
    // 遮罩
    NBCover *cover = [[NBCover alloc] initWithFrame:self.view.bounds];
    _cover = cover;
    cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    cover.clearRect = scanAreaRect;
    [self.view addSubview:cover];
    
    

    // 边框
    UIImageView *scanAreaImageView = [[UIImageView alloc] initWithImage:scanAreaImage];
    _scanAreaImageView = scanAreaImageView;
    scanAreaImageView.layer.masksToBounds = YES;
    scanAreaImageView.frame = borderRect;
    [self.view addSubview:scanAreaImageView];
    
    // 扫描网图片
    UIImageView *scanNetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_code_net_bg"]];
    self.animated = YES;
    scanNetView.x = (scanAreaImageView.width - scanNetView.width) * 0.5;
    scanNetView.y =  - scanNetView.height;
    [scanAreaImageView addSubview:scanNetView];
    _scanNetView = scanNetView;
    
    // 文字提示
    UIImageView *warningView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_code_text"] ];
    warningView.x = (self.view.width - warningView.width) * 0.5;
    warningView.y = CGRectGetMaxY(scanAreaImageView.frame) + 27.0;
    [self.view addSubview:warningView];
    
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scanNetAnimation];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(_scanAreaImageView.frame, captureSizeTransform);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.capture.layer removeFromSuperlayer];
    self.capture = nil;
    [super viewWillDisappear:animated];
}



//- (void)dealloc {
//    [self.capture.layer removeFromSuperlayer];
//}

- (void)scanNetAnimation
{
    __weak typeof(self) weakSelf = self;
    __block BOOL animated = _animated;
    [UIView animateWithDuration:2.0 animations:^{
        if (!animated) return;
        weakSelf.scanNetView.y = weakSelf.scanAreaImageView.height * 0.9;
    } completion:^(BOOL finished) {
        weakSelf.scanNetView.y =  - weakSelf.scanNetView.height;
        if (animated) {
            [weakSelf scanNetAnimation];
        }
    }];
}



#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    
    if (!result) return;
    if (_result) return;
    _result = result;
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    if (![formatString isEqualToString:@"QR Code"]) return;
    [self.capture stop];
    self.animated = NO;
    
    NSArray *strArray = [result.text componentsSeparatedByString:@"|"];
        // 存 扫码得到的商户ID
    if ([strArray.firstObject isEqualToString:@"ethank"]) {
        if ([self.delegate respondsToSelector:@selector(readCodeControllerDidFinishReadWithMerchentID:tableCode:)]) {
            [self.delegate readCodeControllerDidFinishReadWithMerchentID:strArray[1] tableCode:strArray[2]];
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"二维码错误" message:@"无效的二维码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
        _result = nil;
//        [self.capture stop];
//        self.animated = NO;
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.capture start];
    self.animated = YES;
}




- (void)backBtnOnClick:(UIButton *)button
{
    [self.capture stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods
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
@end
