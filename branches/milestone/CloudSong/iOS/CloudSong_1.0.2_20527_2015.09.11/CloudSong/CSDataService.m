//
//  CSDataService.m
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDataService.h"
#import "CSKTVModel.h"
#import "CSRecommendedAlbum.h"
#import "CSSong.h"
#import "CSSinger.h"
#import <UIKit/UIKit.h>
#import "CSHttpTool.h"
#import "CSDefine.h"
#import "CSBaseHttpTool.h"
#import "CSButtonItem.h"
#import "MJExtension.h"
#import "CSUtil.h"
#import "NSObject+MJKeyValue.h"
#import "SDWebImageDownloader.h"
#import "Header.h"
#import "CSButtonsInfoResponse.h"
#import "CSButtonDataResponse.h"
#import "CSAllSingSongsResponse.h"
#import "CSRecommendedAlbumsResponse.h"
#import "CSRecommendedAlbumsData.h"
#import "CSRoomSongsResponse.h"
#import "CSSearchSongsResponse.h"
#import "CSSearchSingersResponse.h"
#import "CSHotSingersResponse.h"
#import "CSSingersClassifiedResponse.h"
#import "CSGetSongsByLanguageResponse.h"
#import "CSSongCategoriesResponse.h"
#import "CSSongsByCategoryResponse.h"
#import "CSRecommendedAlbumSongsResponse.h"
#import "CSBaseResponseModel.h"
#import "CSKTVModel.h"
#import "CSKTVRoomItem.h"
#import "CSKTVBookingOrder.h"
#import "CSKTVSearchResponse.h"
#import "CSGetDistrictDataResponse.h"
#import "CSQueryKTVPriceResponse.h"
#import "CSUserInfoModel.h"
#import "CSGenerateOrderResponse.h"
#import "CSSearchSongsBySingerResponse.h"
#import "CSDeleteSelectedSongResponse.h"
#import "CSSelectSongResponse.h"
#import "CSPutFrontSongResponse.h"
#import "CSDiscoveryRecordsResponse.h"
#import "CSDiscoveryPlayerResponse.h"
#import "CSHomeActivityResponse.h"
#import "CSMyRecordResponse.h"
#import "CSTuanGouResponse.h"
#import "CSTuanGouItem.h"
#import "CSActivityModel.h"
#import "CSActivityResponse.h"
#import "CSFindThemeResponseModel.h"
#import "CSHomeAdBannerResponse.h"
#import "CSHomeActivityTagResponse.h"

// TODO tmp
#import <MJExtension.h>

@interface CSDataService () <UIAlertViewDelegate> {
    NSMutableArray* _delegates;
    NSMutableArray* _ktvData;

    void(^_selectingSongHandler)(BOOL);
    CSSong* _selectingSong;
    BOOL _isCancel;
}
@end

@implementation CSDataService

#pragma mark - Life Cycle

- (id)init {
    if (self = [super init]) {
        _delegates = [NSMutableArray array];
        _ktvData = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)asyncGetKTVDataWithCoordinate:(CLLocationCoordinate2D)coordinate
                           startIndex:(NSInteger)startIndex
                             cityName:(NSString *)cityName
                                range:(CGFloat)range
                         businessName:(NSString *)businessName
                             sortType:(int)sortType
                              handler:(void(^)(NSArray *bldKTVData, NSArray *dianpingKTVData))handler {
    CSRequest *request = [[CSRequest alloc] init];
    request.businessName = businessName;
    request.cityName = cityName;
    request.lat = [NSString stringWithFormat:@"%lf", coordinate.latitude];
    request.lng = [NSString stringWithFormat:@"%lf", coordinate.longitude];
    request.orderType = [NSNumber numberWithInt:sortType];
    request.range = [NSNumber numberWithFloat:range];
    request.startIndex = [NSNumber numberWithInteger:startIndex];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, SearchKTVDataProtocol]
                         param:request
                   resultClass:[CSKTVSearchResponse class]
                       success:^(CSKTVSearchResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               NSMutableArray *bldData = [NSMutableArray array];
                               NSMutableArray *dianpingData = [NSMutableArray array];
                               for (CSKTVModel *item  in responseObj.data) {
                                   if (item.BLDKTVId.length > 0)
                                       [bldData addObject:item];
                                   else
                                       [dianpingData addObject:item];
                                   
//                                   // TODO
//                                   item.imageUrlList = @[@"http://192.168.1.226/43/9f/9102fd632fabd075faf7ab6fcc72.jpg",
//                                                         @"http://192.168.1.226/b7/42/6264107441e0565c46ae29a9efab.jpg",
//                                                         @"http://192.168.1.226/4b/a5/866bd35aab47b4ee71d4a6220449.jpg",
//                                                         @"http://192.168.1.226/8f/1f/ad35602f195e7a8e3223cafb32a3.jpg"];
                               }
                               handler (bldData, dianpingData);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
                       }];
}

- (void)asyncGetBusinessDistrictsWithCity:(NSString *)city handler:(void(^)(NSArray *districts))handler {
    CSRequest *request = [[CSRequest alloc] init];
    request.cityName = city;
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, GetDistrictsDataProtocol]
                         param:request
                   resultClass:[CSGetDistrictDataResponse class]
                       success:^(CSGetDistrictDataResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler (responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
                       }];
}

- (void)asyncGetKTVPriceWithBLDID:(NSString *)BLDID day:(NSString *)day time:(NSString *)time duration:(NSInteger)duration handler:(void(^)(CSQueryKTVPriceItem *item))handler {
    CSRequest *request = [[CSRequest alloc] init];
    request.BLDKTVId = BLDID;
    if (day.length > 0)
        request.day = day;
    if (time.length > 0)
        request.hour = time;
    // duration == 0 的情况是获取当前可用的预定时间
    if (duration > 0)
        request.duration = [NSNumber numberWithInteger:duration];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, QueryRoomsByTimeProtocol]
                         param:request
                   resultClass:[CSQueryKTVPriceResponse class]
                       success:^(CSQueryKTVPriceResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler (responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
                       }];
}

- (void)asyncBookKTVWithBLDKTVId:(NSString *)BLDKTVId
                       boxTypeId:(NSNumber *)boxTypeId
                     boxTypeName:(NSString *)boxTypeName
                             day:(NSString *)day
                        duration:(NSNumber *)duration
                            hour:(NSString *)hour
                           theme:(NSString *)theme
                         handler:(void(^)(CSKTVBookingOrder *order))handler {
    CSRequest *request = [[CSRequest alloc] init];
    request.BLDKTVId = BLDKTVId;
    request.boxTypeId = boxTypeId;
    request.boxTypeName = boxTypeName;
    request.day = day;
    request.duration = duration;
    request.hour = hour;
    request.theme = theme;
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, GenerateOrderProtocol]
                         param:request
                   resultClass:[CSGenerateOrderResponse class]
                       success:^(CSGenerateOrderResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler (responseObj.data);
                           }
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
//                           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"预订KTV失败: %@", [error localizedDescription]]];
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"] ;
                       }];
}

- (void)asyncGetTuanGouWithBLDKTVId:(NSString *)BLDKTVId handler:(void(^)(NSArray *items))handler {
    // TODO
    NSDictionary *dict = @{@"H5Url":@"www.baidu.com",
                           @"instruction":@"周一至周四欢唱3小时，小房/迷你包厢事发后苏苏大哥还是个",
                           @"oldPrice":@"880元",
                           @"photoUrl":@"http://192.168.1.226/43/9f/9102fd632fabd075faf7ab6fcc72.jpg",
                           @"price":@"￥30元",
                           @"seledNum":@897};
    handler(@[[CSTuanGouItem objectWithKeyValues:dict], [CSTuanGouItem objectWithKeyValues:dict], [CSTuanGouItem objectWithKeyValues:dict]]);
    
//    CSRequest *request = [[CSRequest alloc] init];
//    request.BLDKTVId = BLDKTVId;
//    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, GenerateOrderProtocol]
//                         param:request
//                   resultClass:[CSTuanGouResponse class]
//                       success:^(CSTuanGouResponse *responseObj) {
//                           // 请求成功
//                           if (responseObj.code == ResponseStateSuccess) {
//                               handler (responseObj.data);
//                           }
//                           else {
//                               [SVProgressHUD showErrorWithStatus:responseObj.message];
//                           }
//                       } failure:^(NSError *error) {
//                           CSLog(@"***** 获取团购信息失败");
//                       }];
}

- (NSArray *)vodCategoryButtonItems {
    NSString *dirPath = [CSUtil pathForButtonInfos];
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"button0"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 如果当前没有数据，则将默认数据写入相关路径
    if (![fileManager fileExistsAtPath:filePath]) {
        [self saveDefaultButtonsInfoToPath:dirPath];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    // 生成 CSButtonItem 对象
    for (int i = 0; ; ++i) {
        NSString *buttonPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"button%d", i]];
        if (![fileManager fileExistsAtPath:buttonPath])
            break;

        NSDictionary *itemDict = [NSDictionary dictionaryWithContentsOfFile:buttonPath];
        CSButtonItem *buttonItem = [CSButtonItem objectWithKeyValues:itemDict];
        NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d", i]];
        buttonItem.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath] scale:[UIScreen mainScreen].scale];
        [result addObject:buttonItem];
    }
    return result;
}

- (void)asyncGetVODButtonDataRefreshHandler:(void(^)())refreshhHandler {
    // 构造参数
    CSRequest *request = [[CSRequest alloc] init];
    request.version = [[NSUserDefaults standardUserDefaults] objectForKey:VODButtonVersion];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODButtonInfoProtocol]
                         param:request
                   resultClass:[CSButtonsInfoResponse class]
                       success:^(CSButtonsInfoResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               // 如果服务器端数据版本比本地新，才进行以下操作
                               if (responseObj.data.version > [[[NSUserDefaults standardUserDefaults] objectForKey:VODButtonVersion] intValue])
                                   [self handleButtonInfosFrom:responseObj handler:refreshhHandler];
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取按钮数据失败: %@", [error localizedDescription]]];
                       }];
}

- (NSArray *)allSingSongs {
    NSString *dirPath = [CSUtil pathForAllSingSongs];
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"song0"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 如果当前没有数据，则将默认数据写入相关路径
    if (![fileManager fileExistsAtPath:filePath]) {
        [self saveDefaultAllSingSongsToPath:dirPath];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    // 生成 CSSong 对象
    for (int i = 0; ; ++i) {
        NSString *songPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"song%d", i]];
        if (![fileManager fileExistsAtPath:songPath])
            break;
        
        NSDictionary *itemDict = [NSDictionary dictionaryWithContentsOfFile:songPath];
        CSSong *songItem = [CSSong objectWithKeyValues:itemDict];
        NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d", i]];
        songItem.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath] scale:[UIScreen mainScreen].scale];
        [result addObject:songItem];
    }
    return result;
}

- (void)asyncGetVODAllSingSongsType:(CSDataServiceAllSingSongsType)type startIndex:(NSInteger)index refreshHandler:(void(^)(NSArray *songs))refreshHandler {
    // NOTE: 目前服务器端没有支持版本信息，所以只要服务器端有数据，不管是不是和本地数据一致，都下载下来
    CSRequest *request = [[CSRequest alloc] init];
    request.flag = type == CSDataServiceAllSingSongsTypeOpertion ? @0 : @1;
    request.startIndex = [NSNumber numberWithInteger:index];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODAllSingSongsProtocol]
                         param:request
                   resultClass:[CSAllSingSongsResponse class]
                       success:^(CSAllSingSongsResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               // 请求的是运营数据
                               if (type == CSDataServiceAllSingSongsTypeOpertion) {
                                   [self handleAllSingSongsFrom:responseObj handler:refreshHandler];
                               }
                               // 请求的是更多数据
                               else {
                                   refreshHandler(responseObj.data);
                               }
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络连接"];
                       }];
}

- (NSArray *)recommendedAlbums {
    NSString *dirPath = [CSUtil pathForRecommendedAlbums];
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"album0"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 如果当前没有数据，则将默认数据写入相关路径
    if (![fileManager fileExistsAtPath:filePath]) {
        [self saveDefaultAlbumsToPath:dirPath];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    // 生成 CSRecommendedAlbum 对象
    for (int i = 0; ; ++i) {
        NSString *songPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"album%d", i]];
        if (![fileManager fileExistsAtPath:songPath])
            break;
        
        NSDictionary *itemDict = [NSDictionary dictionaryWithContentsOfFile:songPath];
        CSRecommendedAlbum *albumItem = [CSRecommendedAlbum objectWithKeyValues:itemDict];
        NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d", i]];
        albumItem.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath] scale:[UIScreen mainScreen].scale];
        [result addObject:albumItem];
    }
    return result;
}

- (void)asyncGetVODAlbumsHandler:(void(^)(NSArray *albums))handler {
    CSRequest *request = [[CSRequest alloc] init];
    request.version = [[NSUserDefaults standardUserDefaults] objectForKey:VODRecommendedAlbumsVersion];
    
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODRecommendedAlbumsProtocol]
                         param:request
                   resultClass:[CSRecommendedAlbumsResponse class]
                       success:^(CSRecommendedAlbumsResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                               // 如果服务器端数据版本比本地新，才进行以下操作
                               if (responseObj.data.version > [[userDefaults objectForKey:VODRecommendedAlbumsVersion] intValue])
                                   [self handleRecommendedAlbumsFrom:responseObj handler:handler];
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络连接"];
                       }];
}
#pragma mark - 已点歌曲和已唱歌曲

- (void)asyncGetSongsInRoomWithType:(int)type startIndex:(int)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.action = [NSNumber numberWithInt:type];
    requst.startIndex = [NSNumber numberWithInt:startIndex];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    requst.reserveBoxId = roomInfo.reserveBoxId;
    NSString * url =roomInfo.starting?[NSString stringWithFormat:@"%@%@", ServiceKTVURL, VODGetSongsProtocol]:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODGetSongsProtocol];
//    NSString * url = [NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODGetSongsProtocol];
    [CSBaseHttpTool getWithUrl:url
                         param:requst
                   resultClass:[CSRoomSongsResponse class]
                       success:^(CSRoomSongsResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {//KTV 失败 走云服务器
                           CSLog( @"Fail to get songs: %@", error);
                           
                       }];
}

- (void)asyncSearchSongsWithKeyword:(NSString *)keyword startIndex:(int)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.keyWord = keyword;
    requst.startIndex = [NSNumber numberWithInt:startIndex];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODSearchSongsProtocol]
                         param:requst
                   resultClass:[CSSearchSongsResponse class]
                       success:^(CSSearchSongsResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                          CSLog( @"Fail to get songs: %@", error);
                       }];
}

- (void)asyncSearchSingersWithKeyword:(NSString *)keyword startIndex:(int)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.keyWord = keyword;
    requst.startIndex = [NSNumber numberWithInt:startIndex];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODSearchSingersProtocol]
                         param:requst
                   resultClass:[CSSearchSingersResponse class]
                       success:^(CSSearchSingersResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                          CSLog( @"Fail to get songs: %@", error);
                       }];
}

- (void)asyncGetHotSingersWithHandler:(void(^)(NSArray *singers))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODHotSingersProtocol]
                         param:requst
                   resultClass:[CSHotSingersResponse class]
                       success:^(CSHotSingersResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                          CSLog( @"Fail to get songs: %@", error);
                       }];
}

- (void)asyncGetSingersClassifiedWithType:(NSInteger)type startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *singers))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.type = [NSNumber numberWithInteger:type];
    requst.startIndex = [NSNumber numberWithInteger:startIndex];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODSingersClassifiedProtocol]
                         param:requst
                   resultClass:[CSSingersClassifiedResponse class]
                       success:^(CSSingersClassifiedResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                          CSLog( @"Fail to get songs: %@", error);
                       }];
}

- (void)asyncGetSongsWithLanguageType:(NSInteger)type startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.type = [NSNumber numberWithInteger:type];
    requst.startIndex = [NSNumber numberWithInteger:startIndex];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODSongsByLanguageProtocol]
                         param:requst
                   resultClass:[CSGetSongsByLanguageResponse class]
                       success:^(CSGetSongsByLanguageResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                          CSLog( @"Fail to get songs: %@", error);
                       }];
}

- (void)asyncGetSongCategoriesWithHandler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODSongCategoriesProtocol]
                         param:requst
                   resultClass:[CSSongCategoriesResponse class]
                       success:^(CSSongCategoriesResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                          CSLog( @"Fail to get songs: %@", error);
                       }];
}

- (void)asyncGetSongsWithCategoryType:(NSInteger)type startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.type = [NSNumber numberWithInteger:type];
    requst.startIndex = [NSNumber numberWithInteger:startIndex];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODSongsProtocol]
                         param:requst
                   resultClass:[CSSongsByCategoryResponse class]
                       success:^(CSSongsByCategoryResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                          CSLog( @"Fail to get songs: %@", error);
                       }];
}

- (void)asyncGetSongsWithType:(NSInteger)type startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.type = [NSNumber numberWithInteger:type];
    requst.startIndex = [NSNumber numberWithInteger:startIndex];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODSongsProtocol]
                         param:requst
                   resultClass:[CSSongsByCategoryResponse class]
                       success:^(CSSongsByCategoryResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                          CSLog( @"Fail to get songs: %@", error);
                       }];
}

- (void)asyncGetRecommendedAlbumSongsWithID:(NSNumber *)identifier startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.themeId = identifier;
    requst.startIndex = [NSNumber numberWithInteger:startIndex];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, VODRecommendedAlbumSongsProtocol]
                         param:requst
                   resultClass:[CSRecommendedAlbumSongsResponse class]
                       success:^(CSRecommendedAlbumSongsResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           CSLog(@"Fail to asyncGetRecommendedAlbumSongsWithID: %@", error);
                       }];
}
#pragma mark 点歌
- (void)asyncSelectSong:(CSSong *)song forcely:(NSString *)forcely handler:(void(^)(BOOL success))handler {
    if (_isCancel) {//是否强制点歌,用户取消 block也要返回状态
        handler(NO);
        _isCancel=NO;
        return;
    }
    CSRequest *requst = [[CSRequest alloc] init];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    requst.reserveBoxId = roomInfo.reserveBoxId;
    requst.isForce = forcely;
    requst.songId = song.songId;

    NSString * url =roomInfo.starting?[NSString stringWithFormat:@"%@%@", ServiceKTVURL, SelectSongProtocol]:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, SelectSongProtocol];
    [CSBaseHttpTool getWithUrl:url
                         param:requst
                   resultClass:[CSSelectSongResponse class]
                       success:^(CSSelectSongResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(YES);
                           }
                           // 歌曲已经被点过了
                           else if (responseObj.code == SongHasBeenSelected) {
                               _selectingSong = song;
                               _selectingSongHandler = handler;
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                               message:@"该歌曲已经被点过了，确定再点一次么"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"取消"
                                                                     otherButtonTitles:@"确定", nil];
                               [alert show];
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                               handler(NO);

                           }
                       } failure:^(NSError *error) { //KTV 失败 走云服务器
                           CSLog( @"Fail to asyncSelectSong: %@", error);
                           handler(NO);
                           
                           [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, SelectSongProtocol]
                                                param:requst
                                          resultClass:[CSSelectSongResponse class]
                                              success:^(CSSelectSongResponse *responseObj) {
                                                  // 请求成功
                                                  if (responseObj.code == ResponseStateSuccess) {
                                                      handler(YES);
                                                  }
                                                  // 歌曲已经被点过了
                                                  else if (responseObj.code == SongHasBeenSelected) {
                                                      _selectingSong = song;
                                                      _selectingSongHandler = handler;
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                                      message:@"该歌曲已经被点过了，确定再点一次么"
                                                                                                     delegate:self
                                                                                            cancelButtonTitle:@"取消"
                                                                                            otherButtonTitles:@"确定", nil];
                                                      [alert show];
                                                  }
                                                  // 请求失败时的处理
                                                  else {
                                                      [SVProgressHUD showErrorWithStatus:responseObj.message];
                                                      handler(NO);

                                                  }
                                              } failure:^(NSError *error) {
                                                  CSLog( @"Fail to asyncSelectSong: %@", error);
                                                  handler(NO);
                                              }];
                           
                           
                       }];
    
}

#pragma mark   获取用户已点未唱



- (void)asyncGetUnsingedhandlerhandler:(void(^)(NSArray * songId))songId{
    CSRequest *request = [[CSRequest alloc] init];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    request.reserveBoxId = roomInfo.reserveBoxId;
    NSString * url = [NSString stringWithFormat:@"%@%@", ServiceKTVURL, UnsingedProtocol];
    [CSHttpTool get:url params:[request keyValues] success:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"]intValue]==ResponseStateSuccess) {
            songId([responseObj objectForKey:@"data"]);
        }//else
//            [SVProgressHUD showErrorWithStatus:[responseObj objectForKey:@"message"]];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
    }];
    
}


#pragma mark   点唱历史
- (void)asyncGetHistorySongsInRoomWithStartIndex:(int)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *request = [[CSRequest alloc] init];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    request.reserveBoxId = roomInfo.reserveBoxId;
    request.startIndex =[NSNumber numberWithInt:startIndex];
    NSString * url = [NSString stringWithFormat:@"%@%@", ServiceCloudURL, HistorySongProtocol];
    [CSBaseHttpTool getWithUrl:url
                         param:request
                   resultClass:[CSAllSingSongsResponse class]
                       success:^(CSAllSingSongsResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取点唱历史数据失败: %@", [error localizedDescription]]];
                       }];

}

#pragma mark   置顶已点歌曲

-(void)asyncGetFrontSong:(CSSong *)song handler:(void(^)(BOOL success))handler {

    CSRequest *requst = [[CSRequest alloc] init];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    requst.reserveBoxId = roomInfo.reserveBoxId;
    requst.roomSongId =song.roomSongId;
    NSString * url  =[NSString string];
    if (roomInfo.ktvName==nil||roomInfo.starting) {//判断是不是扫码进入
        url = [NSString stringWithFormat:@"%@%@", ServiceKTVURL, ChangeRSongProtocol];
    }else{
        url = [NSString stringWithFormat:@"%@%@", ServiceCloudURL, ChangeRSongProtocol];
    }

    [CSHttpTool get:url params:[requst keyValues] success:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"]intValue]==ResponseStateSuccess) {
            handler(YES);
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObj objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        CSLog( @"Fail to asyncSelectSong: %@", error);//失败了走云

        
    }];
}

- (void)asyncGetSongsBySingerID:(NSString *)singerID startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.startIndex = [NSNumber numberWithInteger:startIndex];
    requst.singerId = singerID;
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, SearchSongBySingerProtocol]
                         param:requst
                   resultClass:[CSSearchSongsBySingerResponse class]
                       success:^(CSSearchSongsBySingerResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           CSLog(@"Fail to asyncSelectSong: %@", error);
                       }];
}

- (void)asyncDeleteSelectedSongByRoomSongID:(NSString *)roomSongID roomNum:(NSString *) roomNum handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.roomNum = GlobalObj.roomNum;
    requst.roomSongId = roomSongID;
    requst.operationType = @1;
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceKTVURL, SearchSongBySingerProtocol]
                         param:requst
                   resultClass:[CSDeleteSelectedSongResponse class]
                       success:^(CSDeleteSelectedSongResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           CSLog(@"Fail to asyncSelectSong: %@", error);
                       }];
}

- (void)asyncPutFrontSelectedSongByRoomSongID:(NSString *)roomSongID roomNum:(NSString *) roomNum handler:(void(^)(NSArray *songs))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.roomNum = GlobalObj.roomNum;
    requst.roomSongId = roomSongID;
    requst.operationType = @0;
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceKTVURL, SearchSongBySingerProtocol]
                         param:requst
                   resultClass:[CSPutFrontSongResponse class]
                       success:^(CSPutFrontSongResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           CSLog(@"Fail to asyncSelectSong: %@", error);
                       }];
}

- (NSArray *)hotCityData {
    return @[@"上海", @"北京", @"广州",
             @"深圳", @"武汉", @"重庆",
             @"成都", @"西安", @"青岛",
             @"天津", @"杭州", @"南京"];
}

- (NSDictionary *)allCities {
    return
    @{
    @"A":@[@"鞍山", @"安阳", @"安庆", @"阿城", @"安顺", @"安康", @"阿里", @"阿图什", @"阿坝", @"阿克苏", @"阿拉善盟", @"阿勒泰"],
    
    @"B":@[@"北京", @"保定", @"宝鸡", @"包头", @"蚌埠", @"北海", @"本溪", @"毕节", @"滨州", @"博尔塔拉", @"博乐", @"博州", @"亳州",  @"巴彦淖尔", @"巴音郭楞", @"巴中", @"巴州", @"白城", @"白山", @"白银", @"百色"],
    
    @"C":@[@"巢湖", @"昌都", @"昌吉", @"常德", @"常熟", @"常州", @"长春", @"长沙", @"长治", @"朝阳", @"潮州", @"沧州", @"郴州", @"成都", @"承德", @"池州", @"赤峰", @"重庆", @"崇左", @"滁州", @"楚雄" ],
    
    @"D":@[@"达州", @"大理", @"大连", @"大庆", @"大同", @"大兴安岭", @"丹东", @"德宏", @"德阳", @"德州", @"迪庆", @"定西", @"东川", @"东胜", @"东营", @"东莞", @"都匀"],
    
    @"E":@[@"鄂尔多斯", @"鄂州", @"恩施"],
    
    @"F":@[@"防城港", @"佛山", @"涪陵", @"福州", @"抚顺", @"抚州", @"阜新", @"阜阳" ],
    
    @"G":@[@"甘南", @"甘孜", @"赣州", @"格尔木", @"固原", @"广安", @"广西", @"广元", @"广州", @"桂林", @"贵港", @"贵阳", @"果洛"],
    
    @"H":@[@"哈尔滨", @"哈密", @"海北", @"海东", @"海口", @"海拉尔", @"海西", @"邯郸", @"汉中", @"杭州", @"菏泽", @"和田", @"合肥", @"河池", @"河源", @"鹤壁", @"鹤岗", @"贺州", @"黑河", @"衡水", @"衡阳", @"红河", @"呼和浩特", @"呼伦贝尔",
           @"葫芦岛", @"湖州", @"怀化", @"淮安", @"淮北", @"珲春", @"淮南", @"黄冈", @"黄南", @"黄山", @"黄石", @"潢川", @"惠州" ],
    
    @"I":@[] ,
    
    @"J":@[@"鸡西", @"吉安", @"吉林", @"吉首", @"集宁", @"济南", @"济宁", @"济源", @"嘉兴", @"嘉峪关", @"佳木斯", @"江汉", @"江门", @"焦作", @"揭阳", @"金昌", @"金华", @"锦州", @"晋城", @"晋中", @"荆门", @"荆州", @"景德镇", @"九江", @"酒泉" ],
    
    @"K":@[@"喀什", @"开封", @"凯里", @"克拉玛依", @"克州", @"库尔勒", @"奎屯", @"昆明"],
    
    @"L":@[@"拉萨", @"莱芜", @"来宾", @"兰州", @"廊坊", @"漯河", @"乐山", @"丽江", @"丽水", @"连云港", @"凉山", @"聊城", @"辽阳", @"辽源", @"林芝", @"临沧", @"临汾", @"临河", @"临夏", @"临沂", @"柳州", @"六安", @"六盘水", @"龙岩", @"陇南",
           @"娄底", @"吕梁", @"洛阳", @"泸州"],
    
    @"M":@[@"马鞍山", @"茂名", @"梅河口", @"梅州", @"眉山", @"绵阳", @"牡丹江"],
    
    @"N":@[@"那曲", @"南昌", @"南充", @"南京", @"南宁", @"南平", @"南通", @"南阳", @"内江", @"内蒙古", @"宁波", @"宁德", @"怒江"],
    
    @"O":@[],
    
    @"P":@[@"攀枝花", @"盘锦", @"萍乡", @"平顶山", @"平凉", @"莆田", @"普洱", @"濮阳"],
    
    @"Q":@[@"七台河", @"齐齐哈尔", @"黔东南", @"黔江", @"黔南", @"黔西南", @"钦州", @"秦皇岛", @"青岛", @"清远", @"庆阳", @"曲靖", @"泉州", @"衢州" ],
    
    @"R":@[@"日喀则", @"日照"],
    
    @"S":@[@"三门峡", @"三明", @"三沙", @"三亚", @"山南", @"汕头", @"汕尾", @"商洛", @"商丘", @"商州", @"上海", @"上饶", @"韶关", @"邵阳", @"绍兴", @"深圳", @"沈阳", @"十堰", @"石河子", @"石家庄", @"石嘴山", @"双鸭山", @"朔州", @"四平", @"松原",
           @"苏州", @"宿迁", @"宿州", @"随州", @"绥化", @"遂宁" ],
    
    @"T":@[@"塔城", @"台州", @"泰安", @"泰州", @"太原", @"唐山", @"天津", @"天水", @"铁岭", @"通化", @"通辽", @"铜川", @"铜陵", @"铜仁", @"吐鲁番"],
    
    @"U":@[],
    
    @"V":@[],
    
    @"W":@[@"万州", @"威海", @"潍坊", @"渭南", @"温州", @"文山", @"乌海", @"乌兰察布", @"乌兰浩特", @"乌鲁木齐", @"无锡", @"芜湖", @"梧州", @"吴忠", @"武汉", @"武威"],
    
    @"X":@[@"西安", @"西藏", @"西昌", @"西峰", @"西宁", @"西双版纳", @"锡林郭勒盟", @"锡林浩特", @"厦门", @"仙桃", @"咸宁", @"咸阳", @"襄樊", @"襄阳", @"湘潭", @"湘西", @"孝感", @"新乡", @"新余", @"忻州", @"信阳", @"兴安盟", @"兴义", @"邢台", @"徐州", @"许昌", @"宣城"],
    
    @"Y":@[@"雅安", @"烟台", @"盐城", @"延安", @"延边", @"延吉", @"扬州", @"阳江", @"阳泉", @"伊春", @"伊犁", @"伊宁", @"宜宾", @"宜昌", @"宜春", @"益阳", @"银川", @"鹰潭", @"营口", @"永州", @"榆林", @"玉林", @"玉树", @"玉溪", @"岳阳", @"云浮", @"运城"],
    
    @"Z":@[@"枣庄", @"湛江", @"漳州", @"张家界", @"张家口", @"张掖", @"昭通", @"肇庆", @"镇江", @"郑州", @"中山", @"中卫", @"舟山", @"周口", @"珠海", @"株洲", @"驻马店", @"资阳", @"淄博", @"自贡", @"遵义" ]
    };
}

- (NSArray *)cityChoosingTitles {
    return @[@"热门国内城市",
             @"A", @"B", @"C", @"D", @"E", @"F",
             @"G", @"H", @"I", @"J", @"K", @"L",
             @"M", @"N", @"O", @"P", @"Q", @"R",
             @"S", @"T", @"U", @"V", @"W", @"X",
             @"Y", @"Z"];
}

- (NSArray *)cityChoosingIndexTitles {
    return @[@"热",
             @"A", @"B", @"C", @"D", @"E", @"F",
             @"G", @"H", @"I", @"J", @"K", @"L",
             @"M", @"N", @"O", @"P", @"Q", @"R",
             @"S", @"T", @"U", @"V", @"W", @"X",
             @"Y", @"Z"];
}

- (NSArray *)smartSortData {
    return @[@"智能排序", @"离我最近", @"人气最高", @"全网最低"];
}

#pragma mark - Private Methods

- (void)saveDefaultButtonsInfoToPath:(NSString *)path {
    CSButtonItem *item0 = [[CSButtonItem alloc] init];
    item0.identifier = 0;
    item0.title = @"歌星";
    item0.image = [UIImage imageNamed:@"song_singer"];
    
    CSButtonItem *item1 = [[CSButtonItem alloc] init];
    item1.identifier = 1;
    item1.title = @"语种";
    item1.image = [UIImage imageNamed:@"song_language"];

    CSButtonItem *item2 = [[CSButtonItem alloc] init];
    item2.identifier = 2;
    item2.title = @"分类";
    item2.image = [UIImage imageNamed:@"song_classification"];

    CSButtonItem *item3 = [[CSButtonItem alloc] init];
    item3.identifier = 3;
    item3.title = @"新歌";
    item3.image = [UIImage imageNamed:@"song_new"];

    CSButtonItem *item4 = [[CSButtonItem alloc] init];
    item4.identifier = 4;
    item4.title = @"热榜";
    item4.image = [UIImage imageNamed:@"song_hot"];
    
    [self saveButtonItems:@[item0, item1, item2, item3, item4] toPath:path];
}

- (void)saveButtonItems:(NSArray *)items toPath:(NSString *)path {
    for (int i = 0; i < items.count; ++i) {
        CSButtonItem *item = items[i];
        [[item keyValues] writeToFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"button%d", i]] atomically:YES];
        NSString *imageName = [NSString stringWithFormat:@"image%d", i];
        [UIImagePNGRepresentation(item.image) writeToFile:[path stringByAppendingPathComponent:imageName] atomically:YES];
    }
}

- (void)handleButtonInfosFrom:(CSButtonsInfoResponse *)response handler:(void(^)())handler {
    NSMutableArray *buttonItems = [NSMutableArray array];
    NSMutableArray *buttonDicts = [NSMutableArray array];
    __block int numOfButtonDownloaded = 0;
    for (NSDictionary *buttonDict in response.data.buttonInfo) {
        CSButtonItem *btnItem = [CSButtonItem objectWithKeyValues:buttonDict];
        [buttonItems addObject:btnItem];
        [buttonDicts addObject:buttonDict];
        // 异步加载所有 button 的图片
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:btnItem.imageSrc]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                               
                                                           } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                               btnItem.image = image;
                                                               numOfButtonDownloaded ++;
                                                               // 所有button的图片都下载完，执行后续操作
                                                               if (numOfButtonDownloaded == [response.data buttonInfo].count) {
                                                                   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                                   // 数据保存到本地
                                                                   [userDefaults setObject:[NSNumber numberWithInt:response.data.version] forKey:VODButtonVersion];
                                                                   [self saveButtonItems:buttonItems toPath:[CSUtil pathForButtonInfos]];
                                                                   // 调用下载数据成功地回调
                                                                   handler();
                                                               }
                                                           }];
    }
}

- (void)saveDefaultAllSingSongsToPath:(NSString *)path {
    CSSong *song0 = [[CSSong alloc] init];
    song0.songName = @"小苹果";
    song0.language = @"国语";
    CSSinger *singer = [[CSSinger alloc] init];
    singer.singerName = @"筷子兄弟";
    song0.singers = @[singer];
    song0.image = [UIImage imageNamed:@"menu_plus_button"];
    
    CSSong *song1 = [[CSSong alloc] init];
    song1.songName = @"可惜没有如果";
    song1.language = @"国语";
    singer = [[CSSinger alloc] init];
    singer.singerName = @"林俊杰";
    song1.singers = @[singer];
    song1.image = [UIImage imageNamed:@"menu_plus_button"];

    CSSong *song2 = [[CSSong alloc] init];
    song2.songName = @"李白";
    song2.language = @"国语";
    singer = [[CSSinger alloc] init];
    singer.singerName = @"李荣浩";
    song2.singers = @[singer];
    song2.image = [UIImage imageNamed:@"menu_plus_button"];

    CSSong *song3 = [[CSSong alloc] init];
    song3.songName = @"手写的从前";
    song3.language = @"国语";
    singer = [[CSSinger alloc] init];
    singer.singerName = @"周杰伦";
    song3.singers = @[singer];
    song3.image = [UIImage imageNamed:@"menu_plus_button"];
    [self saveAllSingSongsItems:@[song0, song1, song2, song3] toPath:path];
}

- (void)saveAllSingSongsItems:(NSArray *)items toPath:(NSString *)path {
    for (int i = 0; i < items.count; ++i) {
        CSSong *item = items[i];
        [[item keyValues] writeToFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"song%d", i]] atomically:YES];
        NSString *imageName = [NSString stringWithFormat:@"image%d", i];
        [UIImagePNGRepresentation(item.image) writeToFile:[path stringByAppendingPathComponent:imageName] atomically:YES];
    }
}

- (void)handleAllSingSongsFrom:(CSAllSingSongsResponse *)response handler:(void(^)(NSArray *))handler {
    // 将服务器端数据保存至本地
    NSMutableArray *songItems = [NSMutableArray array];
    __block int numOfSongImageDownloaded = 0;
    for (CSSong *songItem in response.data) {
        [songItems addObject:songItem];
        // 异步加载所有 song 的图片，所有图片加载完再调用回调
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:songItem.songImageUrl]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                               
                                                           } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                               songItem.image = image;
                                                               numOfSongImageDownloaded ++;
                                                               // 所有button的图片都下载完，执行后续操作
                                                               if (numOfSongImageDownloaded == response.data.count) {
                                                                   // 数据保存到本地
                                                                   [self saveAllSingSongsItems:songItems toPath:[CSUtil pathForAllSingSongs]];
                                                                   // 调用下载数据成功地回调
                                                                   handler(songItems);
                                                               }
                                                           }];
    }
}

- (void)saveDefaultAlbumsToPath:(NSString *)path {
    CSRecommendedAlbum *album0 = [[CSRecommendedAlbum alloc] init];
    album0.listTypeName = @"欧美摇滚专题";
    album0.image = [UIImage imageNamed:@"menu_sold_tag"];
    
    CSRecommendedAlbum *album1 = [[CSRecommendedAlbum alloc] init];
    album1.listTypeName = @"魅惑角色专题";
    album1.image = [UIImage imageNamed:@"menu_sold_tag"];
    
    [self saveAlbumsItems:@[album0, album1] toPath:path];
}

- (void)saveAlbumsItems:(NSArray *)items toPath:(NSString *)path {
    for (int i = 0; i < items.count; ++i) {
        CSRecommendedAlbum *item = items[i];
        [[item keyValues] writeToFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"album%d", i]] atomically:YES];
        NSString *imageName = [NSString stringWithFormat:@"image%d", i];
        [UIImagePNGRepresentation(item.image) writeToFile:[path stringByAppendingPathComponent:imageName] atomically:YES];
    }
}

- (void)handleRecommendedAlbumsFrom:(CSRecommendedAlbumsResponse *)response handler:(void(^)(NSArray *))handler {
    // 将服务器端数据保存至本地
    NSMutableArray *albumItems = [NSMutableArray array];
    __block int numOfAlbumDownloaded = 0;
    for (CSRecommendedAlbum *albumItem in response.data.albums) {
        [albumItems addObject:albumItem];
        // 异步加载所有 album 的图片，所有图片加载完再调用回调
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:albumItem.imageUrl]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                               
                                                           } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                               albumItem.image = image;
                                                               numOfAlbumDownloaded ++;
                                                               // 所有button的图片都下载完，执行后续操作
                                                               if (numOfAlbumDownloaded == response.data.albums.count) {
                                                                   // 数据保存到本地
                                                                   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                                   // 数据保存到本地
                                                                   [userDefaults setObject:[NSNumber numberWithInt:response.data.version] forKey:VODRecommendedAlbumsProtocol];
                                                                   [self saveAlbumsItems:albumItems toPath:[CSUtil pathForRecommendedAlbums]];
                                                                   // 调用下载数据成功地回调
                                                                   handler(albumItems);
                                                               }
                                                           }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        _isCancel=NO;
        [self asyncSelectSong:_selectingSong forcely:@"true" handler:_selectingSongHandler];
    }else{
        _isCancel=YES;
        [self asyncSelectSong:_selectingSong forcely:@"true" handler:_selectingSongHandler];
    }
}
#warning 发现界面
#pragma mark -- 获取发现页面滚动图
- (void)asyncGetDiscoveryThemehandler:(void (^)(NSArray *))handler
{
    CSRequest * request = [[CSRequest alloc] init];
    #warning 发现界面
    [CSBaseHttpTool getWithNetWarningUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL,DiscoveryThemeProtocol] param:request resultClass:[CSFindThemeResponseModel class] success:^(CSFindThemeResponseModel* responseObj) {
        if(responseObj.code == ResponseStateSuccess){
            handler(responseObj.data);
        }
        
    } failure:^(NSError *error) {
        CSLog(@"Fail to asyncGetDiscoveryRecordsWithStartIndex: %@", error);
    }];
}
#pragma mark -- 发现banner对应的下级页面数据
- (void)asyncGetDiscoveryThemeDetailWithSpecialId:(NSString*)specialId startIndex:(NSInteger)startIndex handle:(void (^)(NSArray *))handler
{
//    [SVProgressHUD show];
#warning 需要修改
    CSRequest *requst = [[CSRequest alloc] init];
    requst.specialId = specialId;
    requst.startIndex = [NSNumber numberWithInteger:startIndex];
    #warning 发现界面
    [CSBaseHttpTool getWithNetWarningUrl:[NSString stringWithFormat:@"%@%@",ServiceCloudURL,DiscoveryThemeDetailProtocol]
                                   param:requst
                             resultClass:[CSDiscoveryRecordsResponse class]
                                 success:^(CSDiscoveryRecordsResponse *responseObj) {
//                                     [SVProgressHUD dismiss];
                                     // 请求成功
                                     if (responseObj.code == ResponseStateSuccess) {
                                         handler(responseObj.data);
                                     }
                                     // 请求失败时的处理
                                     else {
                                         [SVProgressHUD showErrorWithStatus:responseObj.message];
                                     }
                                 } failure:^(NSError *error) {
//                                     [SVProgressHUD dismiss];
                                     CSLog(@"Fail to asyncGetDiscoveryRecordsWithStartIndex: %@", error);
                                     
                                 }];
}
#pragma mark - 获取发现页面数据

- (void)asyncGetDiscoveryRecordsWithStartIndex:(NSInteger)startIndex handler:(void (^)(NSArray *))handler
{
//    [SVProgressHUD show];
    CSRequest *requst = [[CSRequest alloc] init];
    requst.startIndex = [NSNumber numberWithInteger:startIndex];
    [CSBaseHttpTool getWithNetWarningUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, DiscoveryRecordsProtocol]
                         param:requst
                   resultClass:[CSDiscoveryRecordsResponse class]
                       success:^(CSDiscoveryRecordsResponse *responseObj) {
//                           [SVProgressHUD dismiss];
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
//                           [SVProgressHUD dismiss];
                           CSLog(@"Fail to asyncGetDiscoveryRecordsWithStartIndex: %@", error);
                           
                       }];
}

#pragma mark - 获取发现页面播放器数据
- (void)asyncGetDiscoveryPlayerDataByDiscoveryId:(NSString *)discoveryId handler:(void (^)(CSPlayingModel *playerData))handler{
    CSRequest *request = [[CSRequest alloc] init] ;
    request.discoveryId = discoveryId ;
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, DiscoveryPlayerProtocol]
                         param:request
                   resultClass:[CSDiscoveryPlayerResponse class]
                       success:^(CSDiscoveryPlayerResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler (responseObj.data);
                           }
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
                           [[NSNotificationCenter defaultCenter] postNotificationName:DISCOVER_NET_BAD object:nil];
                       }];
}

#pragma mark - 获取首页活动标签的二级数据
- (void)asyncGetHomeActivityTagListByRequestUrl:(NSString *)requestUrl Type:(NSNumber *)activityType startIndex:(NSNumber *)startIndex handler:(void (^)(NSArray *activities))handler
{
    CSRequest *request = [[CSRequest alloc] init] ;
    request.activityType = activityType;
    request.startIndex = startIndex;
    
    if (GlobalObj.latitude != 0) {
        request.cityName = GlobalObj.locationCity ;
        request.lat =  [NSString stringWithFloat:GlobalObj.latitude] ;
        request.lng = [NSString stringWithFloat:GlobalObj.longitude]  ;
    }
    
    [CSBaseHttpTool getWithNetWarningUrl:requestUrl
                                   param:request
                             resultClass:[CSHomeActivityResponse class]
                       success:^(CSHomeActivityResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler (responseObj.data);
                           }
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
//                           [SVProgressHUD showErrorWithStatus:@"首页活动数据请求失败"];
                           CSLog(@"%@",error);
                       }];
}
#pragma mark - 获取首页推荐活动数据
- (void)asyncGetHomeRecommendActivitiesWithStartIndex:(NSNumber *)startIndex handler:(void (^)(NSArray *))handler
{
    CSRequest *request = [[CSRequest alloc] init] ;
    // 由于定位信息的获取比较延迟，在首页活动请求数据之前还没返回，所以设置默认经纬度作为请求参数
    
    if (GlobalObj.latitude!=0) {
        request.lat=[NSString stringWithFormat:@"%f",GlobalObj.latitude];
        request.lng=[NSString stringWithFormat:@"%f",GlobalObj.longitude];
    }
    request.startIndex = startIndex ;    
    [CSBaseHttpTool getWithNetWarningUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL,HomeRecommendActivitiesProtocol
    /*HomeRecommendActivitiesProtocol */]
                                   param:request //
                             resultClass:[CSActivityResponse class]
                                 success:^(CSActivityResponse *responseObj) {
                                     // 请求成功
                                     if (responseObj.code == ResponseStateSuccess) {
                                         handler (responseObj.data);
                                     }
                                     else {
                                         [SVProgressHUD showErrorWithStatus:responseObj.message];
                                     }
                                 } failure:^(NSError *error) {
//                                    [SVProgressHUD showErrorWithStatus:@"首页活动数据请求失败"];
                                     CSLog(@"%@",error);
                                 }];
}

#pragma mark - 获取首页广告轮播数据
- (void)asyncGetHomeAdBannersDataByHandle:(void (^)(NSArray *))handler{
    
    [CSBaseHttpTool getWithNetWarningUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, HomeAdBannersProtocol]
                                   param:[[CSRequest alloc] init]//
                             resultClass:[CSHomeAdBannerResponse class]
                                 success:^(CSHomeAdBannerResponse *responseObj) {
                                     // 请求成功
                                     if (responseObj.code == ResponseStateSuccess) {
                                         handler (responseObj.data);
                                     }
                                     else {
                                         [SVProgressHUD showErrorWithStatus:responseObj.message];
                                     }
                                 } failure:^(NSError *error) {
                                     //                                    [SVProgressHUD showErrorWithStatus:@"首页活动数据请求失败"];
                                     CSLog(@"%@",error);
                                 }];
 
}
#pragma mark - 获取首页活动标签数据
- (void)asyncGetHomeActivityTagsByHandle:(void (^)(NSArray *))handler{
    [CSBaseHttpTool getWithNetWarningUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, HomeActivityTagProtocol]
                                   param:[[CSRequest alloc] init]//
                             resultClass:[CSHomeActivityTagResponse class]
                                 success:^(CSHomeActivityTagResponse *responseObj) {
                                     // 请求成功
                                     if (responseObj.code == ResponseStateSuccess) {
                                         handler (responseObj.data);
                                     }
                                     else {
                                         [SVProgressHUD showErrorWithStatus:responseObj.message];
                                     }
                                 } failure:^(NSError *error) {
                                     // [SVProgressHUD showErrorWithStatus:@"首页活动数据请求失败"];
                                     CSLog(@"%@",error);
                                 }];
}
#pragma mark - 获取我的录音
- (void)asyncGetMyRecordDataWithStartIndex:(NSInteger)startIndex handler:(void (^)(NSArray *))handler{
    CSRequest *request = [[CSRequest alloc] init] ;
    
    // 当前用户的token不能获取录音，因为我还没有录
    // 暂时用后台提供的token先测着
    request.token = @"0e9c96b2775c75ee" ;
    request.startIndex = [NSNumber numberWithInteger:startIndex] ;
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, MyRecordsProtocol]
                         param:request
                   resultClass:[CSMyRecordResponse class]
                       success:^(CSMyRecordResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data) ;
                           }else{
                               [SVProgressHUD showErrorWithStatus:responseObj.message] ;
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"我的录音数据请求失败"] ;
                       }] ;
}

#pragma mark  获取活动列表

- (void)asyncGetActivityWithCityName:(NSString *)cityName Tag:(NSString *) tag StartIndex:(NSNumber *)startIndex handler:(void(^)(NSArray *acitivity))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    requst.cityName = cityName;
    if (GlobalObj.latitude!=0) {
        requst.lat=[NSString stringWithFormat:@"%f",GlobalObj.latitude];
        requst.lng=[NSString stringWithFormat:@"%f",GlobalObj.longitude];
    }
    requst.tag = tag;
    requst.startIndex=startIndex;
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, ActivityProtocol]
                         param:requst
                   resultClass:[CSActivityResponse class]
                       success:^(CSActivityResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
                       }];
}

#pragma mark 活动活动tag
- (void)asyncGetActivityTag:(void(^)(NSArray *Acitivity))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    [CSBaseHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, ActivityTagProtocol]
                         param:requst
                   resultClass:[CSActivityResponse class]
                       success:^(CSActivityResponse *responseObj) {
                           // 请求成功
                           if (responseObj.code == ResponseStateSuccess) {
                               handler(responseObj.data);
                           }
                           // 请求失败时的处理
                           else {
                               [SVProgressHUD showErrorWithStatus:responseObj.message];
                           }
                       } failure:^(NSError *error) {
                           [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
                       }];
}

#pragma mark  点赞
- (void)asyncGetActivityClickPraiseByActivityId:(NSNumber * )activityId Type :(NSNumber* )type handler:(void(^)(BOOL success))handler{
    CSRequest *requst = [[CSRequest alloc] init];
    requst.type =type;
    requst.activityId =activityId;
    [CSHttpTool get:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, ActivityPraiseProtocol] params:[requst keyValues] success:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"]intValue]==ResponseStateSuccess) {
            handler(YES);
        }else
            [SVProgressHUD showErrorWithStatus:[responseObj objectForKey:@"message"]];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
    }];

}

- (void)asyncUploadAudioFileWithURL:(NSURL *)url handler:(void(^)(BOOL success))handler {
    CSRequest *requst = [[CSRequest alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", ServiceKTVURL, ChangeRSongProtocol];
    [CSHttpTool post:urlStr parameters:[requst keyValues] uploadData:[NSData dataWithContentsOfURL:url] success:^(id responseObj) {
        // 请求成功
        if ([[responseObj objectForKey:@"code"]intValue]==ResponseStateSuccess)
            handler(YES);
        else
            [SVProgressHUD showErrorWithStatus:[responseObj objectForKey:@"message"]];
    } failure:^(NSError *error) {
        CSLog( @"Fail to upload song: %@", error);
    }];
}

@end





