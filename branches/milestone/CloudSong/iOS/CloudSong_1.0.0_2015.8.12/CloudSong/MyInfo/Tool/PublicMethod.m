//
//  PublicMethod.m
//  CloudSong
//
//  Created by Ronnie on 15/6/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "PublicMethod.h"
#import "CSDefine.h"
#import <AdSupport/AdSupport.h>
#import <sys/xattr.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation PublicMethod
#pragma mark - 初始化单例
+ (PublicMethod *)sharedSingleton{
    
    static PublicMethod *sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedSingleton = [[PublicMethod alloc] init];
        
    });
    return sharedSingleton;
    
}

#pragma mark - 网络请求post方法
- (NSMutableDictionary *)startPostDataWithUrl:(NSString *)url timeOut:(NSTimeInterval)timeOut params:(NSDictionary *)params{
    NSError * error;
    NSMutableDictionary *requestDic = nil;
    //初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if (timeOut > 0) {
        [request setTimeoutInterval:timeOut];
    }
    //设置URL
    NSString * reqUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *dataString  = [NSString stringWithFormat:@"%@",params];
    
    NSData *postData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setURL:[NSURL URLWithString:reqUrl]];
    //设置HTTP方法
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //发送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:&error];
    if (returnData != nil) {
        
        NSError *decoderError;
        //JSONDecoder *decoder = [[JSONDecoder alloc] init];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:&decoderError];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            requestDic = (NSMutableDictionary *)dictionary;
        }
    }
    return requestDic;
}

#pragma mark - 网络请求get方法
- (NSMutableDictionary *)startDownLoadWithUrl:(NSString *)url timeOut:(NSTimeInterval)timeOut{
    NSError * error;
    NSMutableDictionary *requestDic = nil;
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if (timeOut > 0) {
        [request setTimeoutInterval:timeOut];
    }
    // 设置URL
    NSString * reqUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//记得编码，否则出错
    [request setURL:[NSURL URLWithString:reqUrl]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:&error];
    if (returnData != nil) {
        
        NSError *decoderError;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:&decoderError];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            requestDic = (NSMutableDictionary *)dictionary;
        }
    }
    return requestDic;
}

#pragma mark - 给我的家庭应用管理post请求
- (NSMutableDictionary *)appPostDataWithUrl:(NSString *)url timeOut:(NSTimeInterval)timeOut DesKEY:(NSString *)desKEY{
    
    NSError * error;
    NSMutableDictionary *requestDic = nil;
    //初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if (timeOut > 0) {
        [request setTimeoutInterval:timeOut];
    }
    //设置URL
    NSString * reqUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [desKEY dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:reqUrl]];
    //设置HTTP方法
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //发送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:&error];
    if (returnData != nil) {
        NSError *decoderError;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:&decoderError];
        
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            requestDic = (NSMutableDictionary *)dictionary;
        }
    }
    return requestDic;
}



#pragma mark - 保存BOOL数据在UserDefault
- (void)saveUserSetForBool:(BOOL)curBOOL savKey:(NSString *)savKey{
    
    [USER_DEFAULT setBool:curBOOL forKey:savKey];
    [USER_DEFAULT synchronize];
}

#pragma mark - 保存String数据在UserDefault
- (void)saveUserSetForString:(NSString *)curString savKey:(NSString *)savKey{
    
    [USER_DEFAULT setObject:curString forKey:savKey];
    [USER_DEFAULT synchronize];
}

#pragma mark - 保存Float数据在UserDefault
- (void)saveUserSetForFloat:(float)curFloat savKey:(NSString *)savKey{
    
    [USER_DEFAULT setFloat:curFloat forKey:savKey];
    [USER_DEFAULT synchronize];
}

#pragma mark - 给视图添加手势
- (void)addTapGestureRecognizer:(UIView *)superView action:(SEL)action delegate:(id)delegate{
    
    superView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:action];
    [tapGest setNumberOfTapsRequired:1];
    [tapGest setNumberOfTouchesRequired:1];
    tapGest.delegate = delegate;
    [superView addGestureRecognizer:tapGest];
}

#pragma mark - 给视图添加边框
- (void)drawCorner:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(float)width cornerRadius:(float)radius
{
    view.layer.borderColor = [borderColor CGColor];
    view.layer.borderWidth = width;
    view.layer.cornerRadius = radius;
    view.clipsToBounds = TRUE;
}


#pragma mark - 检测字符串是否包含特殊字符
+ (BOOL)checkNSStringIsHasSpecialString:(NSString *)string{
    
    NSString *nicknameRegex = @".*[-`=\\\[\\];'./~!@#$%^&*()_+|{}:\"<>?]+.*";
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nicknameRegex];
    return ![nicknamePredicate evaluateWithObject:string];
}



#pragma mark - 获取设备版本型号
+ (NSString *)deviceTypeString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    /*iPhone Simulator*/
    if ([deviceString isEqualToString:@"i386"])         return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"iPhone Simulator";
    
    /*iPhone*/
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4(GSM)";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4(GSM Rev A)";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4(CDMA)";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5(GSM)";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5(GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c(GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c(Global)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iphone 5s(GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iphone 5s(Global)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    /*iPod Touch*/
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    /*iPad*/
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(GSM)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4(GSM)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4(GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air (China)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    
    /*iPad mini*/
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2 (China)";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad mini 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad mini 3 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3 (China)";
    
    return deviceString;
}

#pragma mark - 将时间戳转换成需要的格式
+ (NSString *)dateWithTimeIntervalSince1970:(int)time setDateFormat:(NSString *)string{
    
    if (string == nil || [string isEqual:[NSNull null]] || [string isEqual:@""] || [string isEqual:@"<null>"] || [string isEqual:@"(null)"]) {
        string = @"yyyy/MM/dd";
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:string];
    NSString *result=[dateFormat stringFromDate:confromTimesp];
    return result;
}

#pragma mark - 将字符串转为字典 可更改
+ (NSMutableDictionary *)checkArrayToDictionary:(NSArray *)array{
    
    if ([array count] == 0) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < [array count]; i++) {
        
        NSString *content = [array objectAtIndex:i];
        if (content != nil && ![content isEqualToString:@""] && ![content isEqualToString:@"(null)"] && ![content isEqual:[NSNull null]]) {
            
            NSRange range = [content rangeOfString:@"="];
            long int location = range.location;
            if (location > 0) {
                
                NSString *key = [content substringToIndex:location];
                NSString *value = @"";
                if (content.length == location + 1) {
                    value = @"";
                }else{
                    value = [content substringFromIndex:location + 1];
                }
                [dic setValue:value forKey:key];
            }
        }
    }
    return dic;
}

#pragma mark - alert 提示信息
- (void)showMessageWithAlert:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alert show];
}

#pragma mark - 判断cell的高度
- (void)checkTheLabelHeight:(NSString *)text width:(CGFloat)widthMax fontSize:(CGFloat)fontSize curFrame:(void(^)(CGFloat height,CGFloat width))curFrame{
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, widthMax, 10.f)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = text;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    CGSize maxSize = CGSizeMake(widthMax ,40000.f);
    CGSize curSize = [contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    curFrame(curSize.height,curSize.width);
}

#pragma mark - 把时间段转换成秒
- (long int)checkTimeForSeconds:(NSString *)curTime{
    
    NSArray *curArray = [curTime componentsSeparatedByString:@":"];
    return [[curArray objectAtIndex:0]intValue]*60 + [[curArray objectAtIndex:1]intValue];
}

#pragma mark - 将字符表示的时间转化为float型时间
-(float)timeIntervalWithString:(NSString*)time{
    NSArray *timeArr = [time componentsSeparatedByString:@"-"];
    float timeInterval = 0;
    if (timeArr.count == 3) {
        return  timeInterval = [[timeArr objectAtIndex:0] floatValue]*3600 + [[timeArr objectAtIndex:1] floatValue]*60 + [[timeArr objectAtIndex:2] floatValue];
    }else if (timeArr.count == 2){
        return  timeInterval = [[timeArr objectAtIndex:0] floatValue]*60 + [[timeArr objectAtIndex:1] floatValue];
    }else if (timeArr.count == 1){
        return  timeInterval = [[timeArr objectAtIndex:0] floatValue];
    }
    
    return timeInterval;
}

#pragma mark - 将float型时间转化为字符型  如：1(h):30(min):26(sec)
- (NSString *)stringWithTimeInterval:(float)time {
    
    BOOL isPositive;
    
    int timeInt;
    
    if (time > 3600 * 24 || time < - 3600 * 24)
        return nil;
    if (time < 0) {
        timeInt = (int)-time;
        isPositive = NO;
    } else {
        timeInt = (int)time;
        isPositive = YES;
    }
    
    int minute = (timeInt%3600)/60;
    int second = (timeInt%3600)%60;
    
    if (isPositive) {
        return [NSString stringWithFormat:@"%d%d:%d%d", minute/10, minute%10, second/10, second%10];
    } else {
        return [NSString stringWithFormat:@"%d%d:%d%d", minute/10, minute%10, second/10, second%10];
    }
}

#pragma mark - 设置文件Do Not Backup 防止被同步
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)curFilePath{
    
    NSURL *url = [NSURL URLWithString:curFilePath];
    const char* filePath = [[url path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

#pragma mark - AES加密
- (NSString *)encryptAES128WithKey:(NSString *)key contentText:(NSString *)contentText{
    
    NSData *keyData = [contentText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encData = [self AES128EncryptWithKey:key inData:keyData];
    
    unsigned char *encByte = (unsigned char *)[encData bytes];
    long int len = [encData length];
    char *encHex = malloc(len * 2 + 1);
    int _h, _l;
    for (int i = 0; i < len; ++i) {
        _h = encByte[i] / 16;
        _l = encByte[i] - 16 * _h;
        if (_h >= 0 && _h < 10) {
            encHex[i * 2] = _h + '0';
        } else if (_h >= 10 && _h < 16) {
            encHex[i * 2] = _h - 10 + 'A';
        }
        if (_l >= 0 && _l < 10) {
            encHex[i * 2 + 1] = _l + '0';
        } else if (_l >= 10 && _l < 16) {
            encHex[i * 2 + 1] = _l - 10 + 'A';
        }
    }
    encHex[len * 2] = '\0';
    NSString *encStr = [[NSString alloc] initWithCString:encHex encoding:NSUTF8StringEncoding];
    free(encHex);
    return encStr;
}

#pragma mark - AES解密
- (NSString *)decryptAES128WithKey:(NSString *)key contentText:(NSString *)contentText{
    
    long int len = [contentText length] / 2;
    const char *orig_buf = [contentText UTF8String];
    if (!(orig_buf[0] == '0' && (orig_buf[1] == 'X' || orig_buf[1] == 'x'))) {
        NSLog(@"**********hex string is not accepted!");
        return nil;
    }
    
    unsigned char *buf = malloc(len-1);
    char hc, lc;
    for (int i = 0; i < len - 1; ++i) {
        buf[i] = 0;
        hc = orig_buf[2*i + 2];
        lc = orig_buf[2*i + 3];
        if (hc >= '0' && hc <= '9') {
            buf[i] += (hc - '0') * 16;
        }
        if (hc >= 'A' && hc <= 'F') {
            buf[i] += (hc - 'A' + 10) * 16;
        }
        if (lc >= '0' && lc <= '9') {
            buf[i] += (lc - '0');
        }
        if (lc >= 'A' && lc <= 'F') {
            buf[i] += (lc - 'A' + 10);
        }
    }
    NSData *od = [NSData dataWithBytes:buf length:len - 1];
    free(buf);
    NSData *data = [self AES128DecryptWithKey:key inData:od];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

- (NSData *)AESDecHexString:(NSString *)key hexStr:(NSString *)hexString {
    NSUInteger len = [hexString length] / 2;
    const char *orig_buf = [hexString UTF8String];
    if (!(orig_buf[0] == '0' && (orig_buf[1] == 'X' || orig_buf[1] == 'x'))) {
        NSLog(@"**********hex string is not accepted!");
        return nil;
    }
    
    unsigned char *buf = malloc(len-1);
    char hc, lc;
    for (int i = 0; i < len - 1; ++i) {
        buf[i] = 0;
        hc = orig_buf[2*i + 2];
        lc = orig_buf[2*i + 3];
        if (hc >= '0' && hc <= '9') {
            buf[i] += (hc - '0') * 16;
        }
        if (hc >= 'A' && hc <= 'F') {
            buf[i] += (hc - 'A' + 10) * 16;
        }
        
        if (lc >= '0' && lc <= '9') {
            buf[i] += (lc - '0');
        }
        if (lc >= 'A' && lc <= 'F') {
            buf[i] += (lc - 'A' + 10);
        }
    }
    
    NSData *od = [NSData dataWithBytes:buf length:len - 1];
    free(buf);
    return [self AES128DecryptWithKey:key inData:od];
}
-(NSString *)nsdataToHexString:(NSData *)encData
{
    unsigned char *encByte = (unsigned char *)[encData bytes];
    NSUInteger len = [encData length];
    char *encHex = malloc(len * 2 + 1);
    int _h, _l;
    for (int i = 0; i < len; ++i) {
        //sprintf(encHex + i * 2, "%02X", encByte[i]);
        //*
        _h = encByte[i] / 16;
        _l = encByte[i] - 16 * _h;
        if (_h >= 0 && _h < 10) {
            encHex[i * 2] = _h + '0';
        } else if (_h >= 10 && _h < 16) {
            encHex[i * 2] = _h - 10 + 'A';
        }
        if (_l >= 0 && _l < 10) {
            encHex[i * 2 + 1] = _l + '0';
        } else if (_l >= 10 && _l < 16) {
            encHex[i * 2 + 1] = _l - 10 + 'A';
        }
        //*/
        //NSLog(@"+++%c+%c", encHex[i * 2], encHex[i * 2 + 1]);
    }
    encHex[len * 2] = '\0';
    NSString *encStr = [[NSString alloc] initWithCString:encHex encoding:NSUTF8StringEncoding];
    free(encHex);
    return encStr;
    
}
#pragma mark - AES加密基础库
- (NSData *)AES128EncryptWithKey:(NSString *)key inData:(NSData *)inData {
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [inData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128, // oorspronkelijk 256
                                          NULL /* initialization vector (optional) */,
                                          [inData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer); //free the buffer;
    return nil;
}

#pragma mark - AES解密基础库
- (NSData *)AES128DecryptWithKey:(NSString *)key inData:(NSData *)inData {
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused) // oorspronkelijk 256
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [inData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128, // oorspronkelijk 256
                                          NULL /* initialization vector (optional) */,
                                          [inData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer); //free the buffer;
    return nil;
}


#pragma mark - 取得图片某一像素点颜色值
- (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image{
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:
                          inImage];
    if (cgctx == NULL) {
        return nil; /* error */
    }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
                 (blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) {
        free(data);
    }
    return color;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
int bitmapInfo = kCGBitmapByteOrderDefault | kCGBitmapFloatComponents | kCGBitmapByteOrder16Little | kCGImageAlphaPremultipliedFirst;
#else
int bitmapInfo = kCGImageAlphaPremultipliedFirst;
#endif

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    long int bitmapByteCount;
    long int bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    context = CGBitmapContextCreate (bitmapData,pixelsWide,pixelsHigh,8,bitmapBytesPerRow,colorSpace,bitmapInfo);
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}


#pragma mark - 用户数据存储的路径
- (NSString *)userDataFilePath:(NSString *)fileName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CSData"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    return [path stringByAppendingPathComponent:fileName];
}

#pragma mark - 用户数据缓存的路径
- (NSString *)userDataFilePathForCache:(NSString *)fileName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CSData"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    return [path stringByAppendingPathComponent:fileName];
}

#pragma mark - 从本地存储中读取数据
- (void)readCacheArr:(NSMutableArray *)items cname:(NSString *)cname
{
    NSString *filePath = [self userDataFilePath:cname];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:filePath];
        if ([arr count] > 0) {
            [items removeAllObjects];
            [items addObjectsFromArray:arr];
        }
    }
}

#pragma mark - 从本地缓存中读取数据
- (void)readCacheArrForCache:(NSMutableArray *)items cname:(NSString *)cname
{
    NSString *filePath = [self userDataFilePathForCache:cname];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:filePath];
        if ([arr count] > 0) {
            [items removeAllObjects];
            [items addObjectsFromArray:arr];
        }
    }
}

#pragma mark - 数组写入本地存储中的数据
- (void)writeCacheArr:(NSMutableArray *)conten name:(NSString *)name
{
    NSString *file = [self userDataFilePath:name];
    
    BOOL flag = [conten writeToFile:file atomically:NO];
    
    if (!flag)
        NSLog(@"write cache array failed: %@", file);
    
}

#pragma mark - 数组写入本地缓存中的数据
- (void)writeCacheArrForCache:(NSMutableArray *)conten name:(NSString *)name
{
    NSString *file = [self userDataFilePathForCache:name];
    
    BOOL flag = [conten writeToFile:file atomically:NO];
    
    if (!flag)
        NSLog(@"write cache array failed: %@", file);
    
}

#pragma mark - 字典写入本地缓存中的数据
- (void)writeCachedDictForCache:(NSDictionary *)conten name:(NSString *)name
{
    NSString *file = [self userDataFilePathForCache:name];
    
    BOOL flag = [conten writeToFile:file atomically:NO];
    
    if (!flag)
        NSLog(@"write cache dict failed: %@", file);
    
}

#pragma mark - 字典写入本地存储中的数据
- (void)writeCachedDict:(NSDictionary *)conten name:(NSString *)name
{
    NSString *file = [self userDataFilePath:name];
    
    BOOL flag = [conten writeToFile:file atomically:NO];
    
    if (!flag)
        NSLog(@"write cache dict failed: %@", file);
    
}

#pragma mark - 读取本地存储中的数据
- (void)readCacheDict:(NSMutableDictionary *)items cname:(NSString *)cname
{
    NSString *filePath = [self userDataFilePath:cname];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //NSLog(@"read cache array: %@", filePath);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        if ([dict count] > 0) {
            [items removeAllObjects];
            [items setValuesForKeysWithDictionary:dict];
        }
    }
    
}

#pragma mark - 读取本地缓存中的数据
- (void)readCacheDictForCache:(NSMutableDictionary *)items cname:(NSString *)cname
{
    NSString *filePath = [self userDataFilePathForCache:cname];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //NSLog(@"read cache array: %@", filePath);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        if ([dict count] > 0) {
            [items removeAllObjects];
            [items setValuesForKeysWithDictionary:dict];
        }
    }
    
}

#pragma mark - 获取当前时间戳
+ (long long)getNowUnixTime{
    
    NSDate *datenow = [NSDate date];
    long long l = [datenow timeIntervalSince1970]*1000;
    return l;
}

+ (NSString *)timeFormat:(long)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}

+ (NSString *)time2string:(float)tm {
    NSString *str;
    int min, sec;
    min = tm / 60;
    sec = tm - min * 60;
    str = [NSString stringWithFormat:@"%d:%02d", min, sec];
    return str;
}



- (char)char2Int:(char)c {
    if (c >= '0' && c <= '9') {
        return c - '0';
    }
    if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    }
    if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    }
    return 0;
}



/**
 *  用于判断是否为手机号码
 *
 *  @param mobileNum 手机号
 *
 *  @return 返回是或否
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,177
     * 虚拟:170
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,177
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  根据路径计算文件大小
 *
 *  @param path 文件路径
 */
- (long long)fileSizeWithPath:(NSString *)path
{
    long long fileSize = 0;
    NSFileManager *mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:path]) {
        NSArray *pathArray = [mgr subpathsAtPath:path];
        for (NSString *subPath in pathArray) {
            NSDictionary *attr = [mgr attributesOfItemAtPath:[path stringByAppendingPathComponent:subPath] error:nil];
            fileSize += [attr[NSFileSize] longLongValue];
        }
    }
    return fileSize;
}


+ (NSString *)idfa
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}
@end
