//
//  CSHttpTool.m
//  CloudSong
//
//  Created by EThank on 15/4/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHttpTool.h"
#import "AFNetworking.h"
#import "CSDefine.h"
#import "SGCryptoUtil.h"
#import "NSString+Base64.h"
//
//#import "RNDecryptor.h"
//#import "RNEncryptor.h"

@implementation CSHttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    CSLog(@"get url = %@",url);
    CSLog(@"params = %@",params);
    
    // 创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置管理器支持text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"application/json"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置请求超时时间为20s
    manager.requestSerializer.timeoutInterval = 20.0 * 3;
    // 拼接&
    NSMutableString *paramStrM = [NSMutableString string];
    for (NSString *key in [params allKeys]) {
        NSString *value = [params objectForKey:key];
        [paramStrM appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    NSString *paramStr = nil;
    if (paramStrM.length>0) {
        paramStr = [paramStrM substringToIndex:paramStrM.length - 1];
    }
    
    // 加密
    NSData *data = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [[SGCryptoUtil defaultUtil] encryptData:data];
//    NSError *error;
//    NSData *encryptedData = [RNEncryptor encryptData:data
//                                        withSettings:kRNCryptorAES256Settings
//                                            password:[self key]
//                                               error:&error];
//    
    NSData *base64Data = [encryptedData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *str = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
//    CSLog(@"加密串 == %@",str);
    
    // 发送请求和处理
    [manager GET:url parameters:@{@"param":[str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""],@"v":@"1.0"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSString *responseString = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *responseData = [responseString base64DecodedData];
//            NSError *error;
//            NSData *decrypted = [RNDecryptor decryptData:responseData withSettings:kRNCryptorAES256Settings password:[self key] error:&error];
            NSData *decrypted = [[SGCryptoUtil defaultUtil] decryptData:responseData];
            NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
//            CSLog(@"解密文 == %@",decryptedString);
            NSData *data = [[decryptedString stringByReplacingOccurrencesOfString:@"\0" withString:@""] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *dicError;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
            CSLog(@"dic = %@",dic);
            success(dic);

            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    CSLog(@"post url = %@",url);
    CSLog(@"params = %@",params);
    // 创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置管理器支持application/json
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"application/json"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置请求超时时间为20s
    manager.requestSerializer.timeoutInterval = 20.0;
    
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSError *error;
//    NSData *encryptedData = [RNEncryptor encryptData:jsonData
//                                        withSettings:kRNCryptorAES256Settings
//                                            password:[self key]
//                                               error:&error];
    NSData *encryptedData = [[SGCryptoUtil defaultUtil] encryptData:jsonData];
    
    NSData *base64Data = [encryptedData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *str = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];

    // 发送请求和处理
    [manager POST:url parameters:@{@"param":str,@"v":@"1.0"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSString *responseString = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *responseData = [responseString base64DecodedData];
//            NSError *error;
//            NSData *decrypted = [RNDecryptor decryptData:responseData withSettings:kRNCryptorAES256Settings password:[self key] error:&error];
            NSData *decrypted = [[SGCryptoUtil defaultUtil] decryptData:responseData];
            
            NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
            NSData *data = [[decryptedString stringByReplacingOccurrencesOfString:@"\0" withString:@""] dataUsingEncoding:NSUTF8StringEncoding];
//            CSLog(@"解密文 == %@",decryptedString);
            
            NSError *dicError;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
            CSLog(@"dic = %@",dic);
            success(dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  上传图片的请求类
 */
+ (void)post:(NSString *)url parameters:(NSDictionary *)params uploadData:(NSData *)uploadData success:(void (^)(id responseObj))success failure:(void (^)(NSError *))failure
{
    CSLog(@"post url = %@",url);
    CSLog(@"params = %@",params);
    NSString *fileName = params[@"picName"];
    // 创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置管理器支持text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"application/json"]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:uploadData name:@"picValue" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
//            CSLog(@"response = %@",responseObject);
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (NSString *)key
{
    char buf1[7] = { 'R' + 1, 'i' - 1, 'o', 'v' + 1, 'n' - 1, 'a' + 4, 0 };
    char buf2[4] = { 'U' - 1, 'j' - 2, 'e', 0 };
    char buf3[6] = { 'M', 'q' - 2, 'm' + 1, 'g' - 2, 'z' - 1, 0 };
    char ukey[17] = { 0 };
    snprintf(ukey, sizeof(ukey) / sizeof(ukey[0]), "%s$%s$%s", buf1, buf2,
             buf3);

    return [NSString stringWithUTF8String:ukey];
}
@end
