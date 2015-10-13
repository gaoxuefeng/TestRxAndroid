//
//  CSPayTool.m
//  CloudSong
//
//  Created by sen on 15/7/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSPayTool.h"
#import "Order.h"
#import "AlipayConfig.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXUtil.h"
#define PARTNER_ID @"1262738101"
#define WECHAT_KEY @"wx0975dfb9e6a3d9f1"
#define WECHAT_APP_LEY @"uDf6sGQRBksW6GzqdXLaQu7lAGZz83kV"
@implementation CSPayTool
static NSString *_timeStamp;
+ (void)alipayWithOrderId:(NSString *)orderId productName:(NSString *)productName productDescription:(NSString *)productDescription price:(NSString *)price callBack:(void(^)(NSDictionary *resultDic))callBack
{
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = ALIPAY_PARTNER;
    order.seller = ALIPAY_SELLER;
    order.tradeNO = orderId; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = price; //商品价格
    order.notifyURL =  ALIPAY_NOTIFY_URL; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = APP_SCHEME;
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALIPAY_PRIVATE_KEY);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
    }
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if (callBack) {
            callBack(resultDic);
        }
    }];

}

+ (void)wechatPayWithPrepayOrderID:(NSString *)prepayOrderID
{
    // 时间戳
    _timeStamp = [self getCurrentTimeStamp];
    PayReq *request = [[PayReq alloc] init];
    request.openID = WECHAT_KEY;
    request.partnerId = PARTNER_ID;
    request.prepayId = prepayOrderID;
    request.package = @"Sign=WXPay";
    request.nonceStr = [self getNonceStr];
    request.timeStamp = (UInt32)[_timeStamp integerValue];//构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:WECHAT_KEY        forKey:@"appid"];
    [params setObject: request.nonceStr    forKey:@"noncestr"];
    [params setObject: request.package      forKey:@"package"];
    [params setObject: PARTNER_ID        forKey:@"partnerid"];
    [params setObject: _timeStamp   forKey:@"timestamp"];
    [params setObject: request.prepayId     forKey:@"prepayid"];
    request.sign = [self createMd5Sign:params];
    
    [WXApi sendReq:request];
}

#pragma mark - Tool
+ (NSString *)getNonceStr
{
    return [WXUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

+ (NSString *)getCurrentTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

//创建package签名
+ (NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", WECHAT_APP_LEY];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    //    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}
@end
