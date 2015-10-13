//
//  PublicMethod.h
//  CloudSong
//
//  Created by Ronnie on 15/6/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sys/utsname.h"

@interface PublicMethod : NSObject

/*********************************************************************************************
 
 初始化单例
 
 ********************************************************************************************/

+ (PublicMethod *)sharedSingleton;

/*********************************************************************************************
 
 startDownLoadWithUrl: timeOut: 网络请求get方法
 
 参数 :   url : 网络请求的URL
 timeOut : 请求超时时间
 
 返回值 : get请求返回的数据字典
 
 ********************************************************************************************/

- (NSMutableDictionary *)startDownLoadWithUrl:(NSString *)url timeOut:(NSTimeInterval)timeOut;

/*********************************************************************************************
 
 startPostDataWithUrl: timeOut: params: 网络请求post方法
 
 参数 :   url : 网络请求的URL
 timeOut : 请求超时时间
 params : post请求所带参数字典
 
 返回值 : post请求返回的数据字典
 
 ********************************************************************************************/

- (NSMutableDictionary *)startPostDataWithUrl:(NSString *)url timeOut:(NSTimeInterval)timeOut params:(NSDictionary *)params;

/*********************************************************************************************
 
 appPostDataWithUrl: timeOut: DesKEY: 我的家庭应用管理post请求
 
 参数 :   url : 网络请求的URL
 timeOut : 请求超时时间
 desKEY : des加密的key
 
 返回值 : post请求返回的数据字典
 
 ********************************************************************************************/

- (NSMutableDictionary *)appPostDataWithUrl:(NSString *)url timeOut:(NSTimeInterval)timeOut DesKEY:(NSString *)desKEY;


/*********************************************************************************************
 
 saveUserSetForBool: savKey: 保存BOOL数据在UserDefault
 
 参数 :     curBOOL : 当前保存的bool数据
 savKey : 当前保存索引key
 
 ********************************************************************************************/

- (void)saveUserSetForBool:(BOOL)curBOOL savKey:(NSString *)savKey;

/*********************************************************************************************
 
 saveUserSetForString: savKey: 保存String数据在UserDefault
 
 参数 :     curString : 当前保存的string数据
 savKey : 当前保存索引key
 
 ********************************************************************************************/

- (void)saveUserSetForString:(NSString *)curString savKey:(NSString *)savKey;

/*********************************************************************************************
 
 saveUserSetForFloat: savKey: 保存Float数据在UserDefault
 
 参数 :     curFloat : 当前保存的float数据
 savKey : 当前保存索引key
 
 ********************************************************************************************/

- (void)saveUserSetForFloat:(float)curFloat savKey:(NSString *)savKey;

/*********************************************************************************************
 
 addTapGestureRecognizer: action: delegate: 给视图添加手势
 
 参数 :        superView : 父视图
 action : 手势点击响应方法
 delegate : 代理
 
 ********************************************************************************************/

- (void)addTapGestureRecognizer:(UIView *)superView action:(SEL)action delegate:(id)delegate;

/*********************************************************************************************
 
 drawCorner: borderColor: borderWidth: cornerRadius: 给视图添加边框
 
 参数 :        view : 父视图
 borderColor : 边框颜色
 width : 边框宽度
 radius : 圆角弧度
 
 ********************************************************************************************/

- (void)drawCorner:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(float)width cornerRadius:(float)radius;


/*
 检测字符串是否包含特殊字符
 
 *********************************************************************************************/

+ (BOOL)checkNSStringIsHasSpecialString:(NSString *)string;

/*********************************************************************************************
 
 获取设备版本型号
 
 *********************************************************************************************/

+ (NSString *)deviceTypeString;

/*********************************************************************************************
 
 dateWithTimeIntervalSince1970: setDateFormat: 将时间戳转换成需要的格式
 
 参数 :    time : 时间戳
 string : 需要转换的格式
 
 *********************************************************************************************/

+ (NSString *)dateWithTimeIntervalSince1970:(int)time setDateFormat:(NSString *)string;

/*********************************************************************************************
 
 checkArrayToDictionary: 将字符串转为字典 可更改(主要处理UPnP字段数据)
 
 参数 :    array : 传入的数组
 
 返回值:   处理后的字典数据
 
 *********************************************************************************************/

+ (NSMutableDictionary *)checkArrayToDictionary:(NSArray *)array;

/*********************************************************************************************
 
 alert 提示信息
 
 *********************************************************************************************/

- (void)showMessageWithAlert:(NSString *)message;

/*********************************************************************************************
 
 checkTheLabelHeight: width: fontSize: curFrame:判断cell的高度
 
 参数 :       text : 传入的字串长度
 width : 宽度
 fontSize : 字体大小
 curFrame : 实际尺寸
 
 *********************************************************************************************/

- (void)checkTheLabelHeight:(NSString *)text width:(CGFloat)widthMax fontSize:(CGFloat)fontSize curFrame:(void(^)(CGFloat height,CGFloat width))curFrame;

/*********************************************************************************************
 
 checkTimeForSeconds: 把时间段转换成秒
 
 返回值:      秒
 
 *********************************************************************************************/

- (long int)checkTimeForSeconds:(NSString *)curTime;

/*********************************************************************************************
 
 timeIntervalWithString: 将字符表示的时间转化为float型时间
 
 参数 :       time : 字符串格式时间 如：1(h):30(min):26(sec)
 
 返回值:      float型时间
 
 *********************************************************************************************/

-(float)timeIntervalWithString:(NSString*)time;

/*********************************************************************************************
 
 stringWithTimeInterval: 将float型时间转化为字符型
 
 参数 :       time : float型时间
 
 返回值:      字符串格式时间 如：1(h):30(min):26(sec)
 
 *********************************************************************************************/

- (NSString *)stringWithTimeInterval:(float)time;

/*********************************************************************************************
 
 encryptAES128WithKey: contentText: AES加密
 
 参数 :       key : 加密密钥
 contentText : 需要加密的数据
 
 返回值:      加密后的数据
 
 *********************************************************************************************/
- (NSData *)AES128EncryptWithKey:(NSString *)key inData:(NSData *)inData;
-(NSString *)nsdataToHexString:(NSData *)encData;
- (NSString *)encryptAES128WithKey:(NSString *)key contentText:(NSString *)contentText;

/*********************************************************************************************
 
 decryptAES128WithKey: contentText: AES解密
 
 参数 :       key : 解密密钥
 contentText : 需要解密的数据
 
 返回值:      加解密的数据
 
 *********************************************************************************************/

- (NSString *)decryptAES128WithKey:(NSString *)key contentText:(NSString *)contentText;
- (NSData *)AESDecHexString:(NSString *)key hexStr:(NSString *)hexString;
/*
 取得图片某一像素点颜色值
 
 *********************************************************************************************/

- (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image;


/*********************************************************************************************
 
 用户数据存储的路径
 
 *********************************************************************************************/

- (NSString *)userDataFilePath:(NSString *)fileName;

/*********************************************************************************************
 
 用户数据缓存的路径
 
 *********************************************************************************************/

- (NSString *)userDataFilePathForCache:(NSString *)fileName;

/*********************************************************************************************
 
 从本地存储中读取数据
 
 *********************************************************************************************/

- (void)readCacheArr:(NSMutableArray *)items cname:(NSString *)cname;

/*********************************************************************************************
 
 从本地缓存中读取数据
 
 *********************************************************************************************/

- (void)readCacheArrForCache:(NSMutableArray *)items cname:(NSString *)cname;

/*********************************************************************************************
 
 数组写入本地存储中的数据
 
 *********************************************************************************************/

- (void)writeCacheArr:(NSMutableArray *)conten name:(NSString *)name;

/*********************************************************************************************
 
 数组写入本地缓存中的数据
 
 *********************************************************************************************/

- (void)writeCacheArrForCache:(NSMutableArray *)conten name:(NSString *)name;

/*********************************************************************************************
 
 字典写入本地缓存中的数据
 
 *********************************************************************************************/

- (void)writeCachedDictForCache:(NSDictionary *)conten name:(NSString *)name;

/*********************************************************************************************
 
 字典写入本地存储中的数据
 
 *********************************************************************************************/

- (void)writeCachedDict:(NSDictionary *)conten name:(NSString *)name;

/*********************************************************************************************
 
 读取本地存储中的数据
 
 *********************************************************************************************/

- (void)readCacheDict:(NSMutableDictionary *)items cname:(NSString *)cname;

/*********************************************************************************************
 
 读取本地缓存中的数据
 
 *********************************************************************************************/

- (void)readCacheDictForCache:(NSMutableDictionary *)items cname:(NSString *)cname;

/*********************************************************************************************
 
 获取当前时间戳
 
 *********************************************************************************************/


/**
 *  根据路径计算文件大小
 *
 *  @param path 文件路径
 */
- (long long)fileSizeWithPath:(NSString *)path;


+ (long long)getNowUnixTime;
+ (NSString *)timeFormat:(long)totalSeconds;
+ (NSString *)time2string:(float)tm;
/**
 *  用于判断是否为手机号码
 *
 *  @param mobileNum 手机号
 *
 *  @return 返回是或否
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString *)idfa;
@end
