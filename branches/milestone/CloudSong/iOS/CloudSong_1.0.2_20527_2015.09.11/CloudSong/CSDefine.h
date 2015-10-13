//
//  CSDefine.h
//  CloudSong
//
//  Created by EThank on 15/4/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "NSString+Extension.h"
#import "PublicMethod.h"
#import "GlobalVar.h"
#ifndef CloudSong_CSDefine_h
#define CloudSong_CSDefine_h

#define UmengAppkey     @"552e1a4bfd98c5ab55000044"
///** 生产服务器 **/
////// 云服务器
//#define ServiceCloudURL          @"http://yunge.ethank.com.cn/ethank-yunge-deploy/"
//// KTV服务器
//#define ServiceKTVURL         [NSString stringWithFormat:@"http://%@/ethank-KTVCenter-deploy/",GlobalObj.centerIp]

/** 测试服务器 **/
// 云服务器
#define ServiceCloudURL          @"http://yunge.ethank.com.cn/ethank-yunge-deploy/"

// KTV服务器
#define ServiceKTVURL         [NSString stringWithFormat:@"http://%@/ethank-KTVCenter-deploy/",GlobalObj.centerIp]

// 盒子
#define ServiceBoxURL         [NSString stringWithFormat:@"http://%@/",GlobalObj.boxIp]

#define SearchKTVDataProtocol           @"ktvorder/searchktv.json"
#define GetDistrictsDataProtocol        @"ktvorder/getCircle.json"
#define QueryRoomsByTimeProtocol        @"ktvorder/querytime.json"
#define GenerateOrderProtocol           @"ktvorder/genorder.json"

#define VODButtonInfoProtocol           @"ui/button.json"
#define VODAllSingSongsProtocol         @"search/button/singtogether.json"
#define VODRecommendedAlbumsProtocol    @"ui/theme.json"
#define VODGetSongsProtocol             @"roomsong/getRoomSong.json"
#define VODSearchSongsProtocol          @"search/song/key.json"
#define VODSearchSingersProtocol        @"search/singer/key.json"
#define VODHotSingersProtocol           @"search/singer/recommend.json"
#define VODSingersClassifiedProtocol    @"search/singer/singerType.json"
#define VODSongsByLanguageProtocol      @"search/song/language.json"
#define VODSongCategoriesProtocol       @"song/songtype.json"
#define VODSongsProtocol                @"search/button/newsong.json"
#define VODRecommendedAlbumSongsProtocol    @"search/song/theme.json"
#define SelectSongProtocol              @"roomsong/addRoomSong.json"//
#define SearchSongBySingerProtocol      @"search/song/singer.json"
#define ChangeRSongProtocol             @"roomsong/changeRSong.json"
#define HistorySongProtocol             @"my/song/history/get.json"
#define UnsingedProtocol                @"roomsong/unsinged.json"

/******************************* 发现页面相关协议 ****************************/
#define DiscoveryThemeProtocol      @"discovery/querySpecial.json"
#define DiscoveryThemeDetailProtocol @"discovery/querySpecialList.json?specialId=1"
#define DiscoveryRecordsProtocol    @"discovery/get.json"
#define DiscoveryPlayerProtocol     @"discovery/play.json"//此接口需返回 在播放页面，当前用户点赞状态
#define DiscoveryPraiseProtocol     @"discovery/praise/add.json"

/******************************* 首页活动相关协议 ****************************/
#define HomeActivitiesProtocol           @"activity/get.json" // @"home/activities/get.json"
#define HomeRecommendActivitiesProtocol  @"home/recommend/get.json"
#define HomeAdBannersProtocol            @"home/top/image/get.json"
#define HomeActivityTagProtocol          @"home/navigation/get.json"

/******************************* 活动页相关协议 ****************************/
#define ActivityProtocol            @"activity/get.json"
#define ActivityPraiseProtocol      @"activity/praise/add.json"
#define ActivityTagProtocol         @"activity/tag/get.json"
#define ActivityCityProtocol        @"activity/city/get.json"

/******************************* 我的录音相关协议 ****************************/
#define MyRecordsProtocol           @"my/record.json"

#define bindingRoomProtocol [NSString stringWithFormat:@"%@banding/registered.json",ServiceKTVURL]

#define NET_WORK_ERROR -1004 // 无网络
#define NET_WORK_TIME_OUT -1001 // 请求超时
#define NET_WORK_BREAK -1005 // 网络连接中断
#define NET_WORK_BREAK_1 -1009 // 网络连接中断


#define StartIndexPara          @"startIndex"
#define VODSongTypePara         @"type"
#define VODSongFlagPara         @"flag"
#define VODActionPara           @"action"

#define UserToken               @"UserToken"
#define UserID                  @"UserID"
#define VODButtonVersion        @"VODButtonVersion"
#define VODRecommendedAlbumsVersion @"VODRecommendedAlbumsVersion"

#define ResponseStateSuccess    (0)
#define NoKTVRoomAvailable      (1)
#define SongHasBeenSelected     (1)

#define ResponseMsg         @"message"
#define ResponseData        @"data"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height


#define BACK_FROM_WECHAT @"backFromWechat"
#define USER_INFO_UPDATED @"userInfoUpdated"
#define USER_ROOM_UPDATED @"userRoomUpdated"
#define ROOM_STATUS_CHANGED @"roomStatusChanged"
#define SONGS_STATUS_CHANGED @"songStatusChanged"
#define NET_WORK_REACHABILITY @"networkReachability"

#define DISCOVER_NET_BAD @"networkunability"
#define STARTPLAY @"StartPlay"



// 判断当前设备型号
#define iPhone4 (SCREENHEIGHT == 480.f)
#define iPhone5 (SCREENHEIGHT == 568.f)
#define iPhone6 (SCREENWIDTH == 375.f)
#define iPhone6Plus (SCREENWIDTH == 414.f)

#define AUTOLENGTH(x) (x / 320.0 * SCREENWIDTH)

// DEBUG
#if DEBUG
#define CSLog(...) NSLog(__VA_ARGS__)
#else
#define CSLog(...)
#endif

typedef NS_ENUM(NSInteger, CSPayMethodType) {
    CSPayMethodTypeWechat = 1,      // 微信支付
    CSPayMethodTypeAlipay           // 支付宝支付
};

//typedef NS_ENUM(NSInteger, CSMyCostStatusType) {
//    CSMyCostStatusTypeNotPay,               // 未付款
//    CSMyCostStatusTypeHasPay,               // 已支付
//    CSMyCostStatusTypeRefunding,            // 退款中
//    CSMyCostStatusTypeDone,                 // 已完成
//    CSMyCostStatusTypeCanceled              // 已取消
//};
typedef NS_ENUM(NSInteger, CSMyCostStatusType) {                  /* 包厢 */
    CSMyCostStatusTypeHasPayEnableRefunding,                    // 已付款可退款
    CSMyCostStatusTypeHasPayDisableRefunding,                   // 已付款不可退款
    CSMyCostStatusTypeInCost,                                   // 已支付,活动进行中
    CSMyCostStatusTypeCanceled,                                 // 已取消
    CSMyCostStatusTypeNotPay ,                                  // 未付款
    CSMyCostStatusTypeRefunding,                                // 退款中
};

typedef NS_ENUM(NSInteger, CSMyCostDishStatusType) {            /* 酒水 */
    CSMyCostDishStatusTypeNotPay = 1,                           // 未付款
    CSMyCostDishStatusTypeHasPay,                               // 已支付
    CSMyCostDishStatusTypeRefunding,                            // 退款中
    CSMyCostDishStatusTypeDone,                                 // 已完成
    CSMyCostDishStatusTypeCanceled,                             // 已取消
};


typedef NS_ENUM(NSInteger, CSMessageType) {
    CSMessageTypeText,                  // 文本
    CSMessageTypePicture,               // 图片
    CSMessageTypeMagicFace,             // 表情
    CSMessageTypeStatus                 // 状态
};

typedef NS_ENUM(NSInteger, CSPlayStatus){
    CSPlayStatusPause ,            // 暂停
    CSPlayStatusPlaying            // 正在播放
};

typedef NS_ENUM(NSInteger, CSHomeActivityType) {
    
    CSHomeActivityTypeNational ,             // 全国活动
    CSHomeActivityTypeHot,                    // 热门活动
    CSHomeActivityTypeBoutique              // 精品活动

};

typedef NS_ENUM(NSInteger, CSShareCategory) {
    CSShareCategoryCancel, // 取消分享
    CSShareCategoryWechat,
    CSShareCategoryTimeLine,
    CSShareCategoryQQ,
    CSShareCategoryWeibo
};

// rgb颜色转换（16进制->10进制）
#define HEX_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 尺寸在不同的scale下转换，参数是按point计的
#define TRANSFER_SIZE(a) (a * (ABS([UIScreen mainScreen].scale - 3) < 0.01 ? 1.15 : 1))

// 定个不同的颜色信息，为了解决以下问题：在storyboard里面取色器取的颜色和实际运行起来模拟器里面的颜色不一致
#define Color_168_168_165 [UIColor colorWithRed:168/255.0 green:168/255.0 blue:165/255.0 alpha:1]
#define Color_147_43_96 [UIColor colorWithRed:147/255.0 green:43/255.0 blue:96/255.0 alpha:1]
#define Color_21_20_23 [UIColor colorWithRed:21/255.0 green:20/255.0 blue:23/255.0 alpha:1]
#define Color_22_22_25 [UIColor colorWithRed:22/255.0 green:22/255.0 blue:25/255.0 alpha:1]
#define Color_252_65_171 [UIColor colorWithRed:252/255.0 green:65/255.0 blue:171/255.0 alpha:1]


#define Color_Hex_97_99_a2 [UIColor colorWithRed:0x97/255.0 green:0x99/255.0 blue:0xa2/255.0 alpha:1]
#define WhiteColor_Alpha_2 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.02]
#define WhiteColor_Alpha_4 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.04]
#define WhiteColor_Alpha_6 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.06]
//#define DIVIDER_COLOR HEX_COLOR(0x3f2757)


#endif


/******************** 快速的定义一个weakSelf 用于block里面  ***************/
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self


/*********************************************************************************************
 
 关于实例化的那几个宏定义
 
 ********************************************************************************************/

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define DOCUMENT_DIRECTION [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] // document路径

#define CACHE_DIRECTION [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] // cache路径

#define GlobalObj [GlobalVar sharedSingleton]//保存全局变量类

#define PubObj [PublicMethod sharedSingleton]//公用方法类
