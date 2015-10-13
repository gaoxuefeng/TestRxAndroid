//
//  CSDataService.h
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

@class CSSong;
@class CSKTVBookingOrder;
@class CSPlayingModel ;
@class CSHomeActivityModel ;
@class CSQueryKTVPriceItem ;

typedef NS_ENUM(NSUInteger, CSDataServiceSongType) {
    CSDataServiceSongTypeMain = 0,
    CSDataServiceSongTypeAll,
    CSDataServiceSongTypeHotList,
};

/**
 *  点歌界面，“大家都在唱”的接口
 */
typedef NS_ENUM(NSUInteger, CSDataServiceAllSingSongsType){
    CSDataServiceAllSingSongsTypeOpertion = 0,
    CSDataServiceAllSingSongsTypeMore,
};

typedef NS_ENUM(NSUInteger, CSDataServiceKTVBookingSortType) {
    CSDataServiceKTVBookingSortTypeDefault = 0,
    CSDataServiceKTVBookingSortTypeDistance,
    CSDataServiceKTVBookingSortTypePopularity,
    CSDataServiceKTVBookingSortTypePrice,
};

@interface CSDataService : NSObject

+ (instancetype)sharedInstance;

/**
 *  KTV预定界面，根据条件获取KTV数据
 *
 *  @param coordinate   用户当前的地理位置
 *  @param startIndex   分页显示
 *  @param cityName     当前城市名字
 *  @param range        半径（米）（可选）默认
 *  @param businessName 商圈名称（可选）
 *  @param sortType     智能排序（1:智能排序 2:离我最近；3:人气最高；4:全网最低）
 *  @param handler      回调
 */
- (void)asyncGetKTVDataWithCoordinate:(CLLocationCoordinate2D)coordinate
                           startIndex:(NSInteger)startIndex
                             cityName:(NSString *)cityName
                                range:(CGFloat)range
                         businessName:(NSString *)businessName
                             sortType:(int)sortType
                              handler:(void(^)(NSArray *bldKTVData, NSArray *dianpingKTVData))handler;

/**
 *  KTV预订界面，获取商圈
 *
 *  @param city    城市名
 *  @param handler
 */
- (void)asyncGetBusinessDistrictsWithCity:(NSString *)city handler:(void(^)(NSArray *districts))handler;

/**
 *  预定KTV，查询KTV价格
 *
 *  @param day      预定日期，格式：06-27
 *  @param time     开始时间，格式：19：30
 *  @param duration 预定时长
 *  @param handler
 */
- (void)asyncGetKTVPriceWithBLDID:(NSString *)BLDID day:(NSString *)day time:(NSString *)time duration:(NSInteger)duration handler:(void(^)(CSQueryKTVPriceItem *item))handler;

/**
 *  预定
 *
 *  @param theme    主题
 *  @param day      开始日期，格式：06-27
 *  @param time     开始时间，格式：19：30
 *  @param duration 时长
 *  @param handler
 */
- (void)asyncBookKTVWithBLDKTVId:(NSString *)BLDKTVId
                       boxTypeId:(NSNumber *)boxTypeId
                     boxTypeName:(NSString *)boxTypeName
                             day:(NSString *)day
                        duration:(NSNumber *)duration
                            hour:(NSString *)hour
                           theme:(NSString *)theme
                         handler:(void(^)(CSKTVBookingOrder *order))handler;


/**
 *  获取团购信息
 *
 *  @param BLDKTVId
 *  @param handler
 */
- (void)asyncGetTuanGouWithBLDKTVId:(NSString *)BLDKTVId handler:(void(^)(NSArray *items))handler;

/**
 *  点歌界面，获取本地的Button数据，此时
     1、如果没有数据，则将默认的数据写入相应的路径
     2、如果有数据，肯定是最新的数据
 *
 *  @return 数组，其中每个元素都是CSButtonItem
 */
- (NSArray *)vodCategoryButtonItems;

/**
 *  点歌界面，获取分类按钮数据
 *
 *  @param refreshhHandler 从服务端取回数据之后的处理放在此block里面
 */
- (void)asyncGetVODButtonDataRefreshHandler:(void(^)())refreshHandler;

/**
 *  点歌界面，获取本地的“大家都在唱”数据，此时
     1、如果没有数据，则将默认的数据写入相应的路径
     2、如果有数据，肯定是最新的数据
 *
 *  @return 数组，其中每个元素都是CSSong
 */
- (NSArray *)allSingSongs;

/**
 *  点歌界面，获取“大家都在唱”的运营和更多数据
 *
 *  @param type           是首页的运营数据还是更多里面的数据
 *  @param index          支持分页显示的startIndex
 *  @param refreshHandler 如果是运营数据，则refreshHandler的参数为空，用不到；如果是“更多”的数据，则refreshHandler的参数包含着新请求的数据
 */
- (void)asyncGetVODAllSingSongsType:(CSDataServiceAllSingSongsType)type startIndex:(NSInteger)index refreshHandler:(void(^)(NSArray *songs))refreshHandler;

- (NSArray *)recommendedAlbums;

/**
 *  点歌界面，获取推荐专辑的数据
 *
 *  @param handler 成功后的回调
 */
- (void)asyncGetVODAlbumsHandler:(void(^)(NSArray *albums))handler;

/**
 *  点歌界面，获取已点歌曲或者已唱歌曲
 *
 *  @param type       0:已点歌曲； 1：已唱歌曲
 *  @param startIndex 开始获取的下标
 *  @param handler    获取数据后的回调
 */
- (void)asyncGetSongsInRoomWithType:(int)type startIndex:(int)startIndex handler:(void(^)(NSArray *songs))handler;

/**
 *  点歌界面，搜索歌星或歌曲 -> 搜索歌曲
 *
 *  @param keyword
 *  @param startIndex
 *  @param handler
 */
- (void)asyncSearchSongsWithKeyword:(NSString *)keyword startIndex:(int)startIndex handler:(void(^)(NSArray *songs))handler;

/**
 *  点歌界面，搜索歌星或歌曲 -> 搜索歌星
 *
 *  @param keyword    keyword
 *  @param startIndex startIndex
 *  @param handler
 */
- (void)asyncSearchSingersWithKeyword:(NSString *)keyword startIndex:(int)startIndex handler:(void(^)(NSArray *songs))handler;

/**
 *  点歌界面，获取热门歌星推荐
 *
 *  @param handler
 */
- (void)asyncGetHotSingersWithHandler:(void(^)(NSArray *singers))handler;

/**
 *  点歌界面，根据某一分类获取歌手列表
 *
 *  @param type       例如：华语男歌星、华语女歌星...
 *  @param startIndex 支持分页显示
 *  @param handler
 */
- (void)asyncGetSingersClassifiedWithType:(NSInteger)type startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *singers))handler;

/**
 *  点歌界面，获取某一种语言对应的歌曲
 *
 *  @param type       语言种类
 *  @param startIndex 分页显示
 *  @param handler
 */
- (void)asyncGetSongsWithLanguageType:(NSInteger)type startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler;

/**
 *  点歌界面，获取歌曲分类
 *
 *  @param handler
 */
- (void)asyncGetSongCategoriesWithHandler:(void(^)(NSArray *songs))handler;

/**
 *  点歌界面，根据分类获取歌曲列表
 *
 *  @param type       分类
 *  @param startIndex 分页显示
 *  @param handler
 */
- (void)asyncGetSongsWithCategoryType:(NSInteger)type startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler;

/**
 *  点歌界面，获取新歌或者热榜
 *
 *  @param type       1：新歌 2、热榜
 *  @param startIndex 分页显示
 *  @param handler
 */
- (void)asyncGetSongsWithType:(NSInteger)type startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler;

/**
 *  点歌界面，获取推荐专辑中的歌
 *
 *  @param identifier   专辑的ID
 *  @param startIndex   分页显示
 *  @param handler
 */
- (void)asyncGetRecommendedAlbumSongsWithID:(NSNumber *)identifier startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler;

/**
 *  点歌接口
 *
 *  @param song    歌曲模型
 *  @param success
 */
//- (void)asyncSelectSong:(CSSong *)song forcely:(BOOL)forcely handler:(void(^)(BOOL success))handler;
- (void)asyncSelectSong:(CSSong *)song forcely:(BOOL)forcely handler:(void(^)(BOOL success))handler;
/**
 *  点歌界面
 *
 *  @param singID     歌手ID
 *  @param startIndex 分页展示
 *  @param handler
 */
- (void)asyncGetSongsBySingerID:(NSString *)singID startIndex:(NSInteger)startIndex handler:(void(^)(NSArray *songs))handler;

- (void)asyncDeleteSelectedSongByRoomSongID:(NSString *)roomSongID roomNum:(NSString *) roomNum handler:(void(^)(NSArray *songs))handler;

- (void)asyncPutFrontSelectedSongByRoomSongID:(NSString *)roomSongID roomNum:(NSString *) roomNum handler:(void(^)(NSArray *songs))handler;



// 城市选择界面数据
- (NSArray *)hotCityData;
// allCities 返回值的dict的所有key需要和 cityChoosingTitles: 返回的值一一对应，除了“热门国内城市”
- (NSDictionary *)allCities;
- (NSArray *)cityChoosingTitles;
- (NSArray *)cityChoosingIndexTitles;
// KTV预定界面的“智能排序”数据
- (NSArray *)smartSortData;


/*****************************************  获取发现页面  *******************************************/
/**
 *  获取发现页面录音数据
 *
 *  @param startIndex 请求开始标记
 *  @param handler
 */
- (void)asyncGetDiscoveryRecordsWithStartIndex:(NSInteger)startIndex handler:(void(^)(NSArray *records))handler ;
/**
 *  获取发现二级页面（播放页面）
 *
 *  @param discoveryId 发现ID
 */
- (void)asyncGetDiscoveryPlayerDataByDiscoveryId:(NSString *)discoveryId handler:(void(^)(CSPlayingModel *))handler ;


/*****************************************  获取首页活动页面 *******************************************/
/**
 *  获取首页活动数据
 *
 *  @param activityType 活动类型（全国、精品、热门）
 */
- (void)asyncGetHomeActivityDataByactivityType:(NSNumber *)activityType startIndex:(NSNumber *)startIndex handler:(void (^)(NSArray *activities))handler ;


- (void)asyncGetHomeRecommendActivityDatahandler:(void (^)(NSArray *activities))handler;
/*****************************************  获取我的录音页面 *******************************************/
/**
 *  获取我的录音页面数据
 *
 *  @param startIndex 请求开始标记
 */
- (void)asyncGetMyRecordDataWithStartIndex:(NSInteger)startIndex handler:(void(^)(NSArray *myRecords))handler ;

#pragma mark   获取活动列表
- (void)asyncGetActivityWithCityName:(NSString *)cityName Tag:(NSString *) tag StartIndex:(NSNumber *)startIndex handler:(void(^)(NSArray *acitivity))handler;

#pragma make 活动活动tag
- (void)asyncGetActivityTag:(void(^)(NSArray *Acitivity))handler;

#pragma mark   置顶已点歌曲

-(void)asyncGetFrontSong:(CSSong *)song handler:(void(^)(BOOL success))handler ;

#pragma mark  点赞
- (void)asyncGetActivityClickPraiseByActivityId:(NSNumber * )activityId Type :(NSNumber* )type handler:(void(^)(BOOL success))handler;

#pragma mark   点唱历史
- (void)asyncGetHistorySongsInRoomWithStartIndex:(int)startIndex handler:(void(^)(NSArray *songs))handler;

// TODO 上传歌曲接口
- (void)asyncUploadAudioFileWithURL:(NSURL *)url handler:(void(^)(BOOL success))handler;

@end

