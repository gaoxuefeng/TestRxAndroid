//
//  CSRequest.h
//  CloudSong
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//  网络请求基类

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CSRequest : NSObject
/** token */
@property(nonatomic, copy) NSString *token;
/** 手机号 */
@property(nonatomic, copy) NSString *phoneNum;
/** 密码 */
@property(nonatomic, copy) NSString *password;
/** 修改的新密码 */
@property(nonatomic, copy) NSString *alterPassword;
/** 动态密码 */
@property(nonatomic, copy) NSString *dynamicPw;
/** 设备类型 iOS:1 */
@property(nonatomic, copy) NSString *dev;
/** 用户设备唯一标识 */
@property(nonatomic, copy) NSString *did;
/** 极光推送id */
@property(nonatomic, copy) NSString *registrationId;
/** iOS传当前的操作系统 */
@property(nonatomic, copy) NSString *rom;
/** 验证码 */
@property(nonatomic, copy) NSString *verifyCode;
/** 注册方式 0:app */
@property(nonatomic, strong) NSNumber *regisType;
/** 设备唯一标示等设备相关信息 */
@property(nonatomic, copy) NSString *deviceJsonString;
/** 年龄 */
@property(nonatomic, strong) NSNumber *age;
/** 血型 */
@property(nonatomic, copy) NSString *bloodType;
/** 星座 */
@property(nonatomic, copy) NSString *constellation;
/** 喜爱的歌手 */
@property(nonatomic, copy) NSString *loveSingers;
/** 喜爱的歌曲 */
@property(nonatomic, copy) NSString *loveSongs;
/** 个性签名 */
@property(nonatomic, copy) NSString *whatIsUp;
/** 昵称 */
@property(nonatomic, copy) NSString *nickName;
/** 性别 */
@property(nonatomic, copy) NSString *gender;
/** 第三方ID 可选 */
@property(nonatomic, copy) NSString *openid;
/** 头像URL */
@property(nonatomic, copy) NSString *profileUrl;
/**
 *  当用于第三方登陆时 1:微博 2:微信 3:QQ
 *  当用于歌手分类时 ......
 *  当用于歌曲分类时 ......
 *  当用于语言类型时 1:国语 2:粤语 3:台语 4:英语 5:日语 6:韩语 7:其他
 *  当用于新歌/热版按钮时 1:新歌 2:热版
 */
@property(nonatomic, copy) NSNumber *type;
/** 歌手ID */
@property(nonatomic, copy) NSString *singerId;
/** 开始页索引 */
@property(nonatomic, copy) NSNumber *startIndex;
/** 第几页 */
@property(nonatomic, copy) NSString *pageNum;
/** 每页多少个 */
@property(nonatomic, copy) NSString *perPage;
/** 歌手名或唯一ID */
@property(nonatomic, copy) NSString *keyWord;
/** 版本号 */
@property(nonatomic, copy) NSNumber *version;
/** 是否是更多 0:返回4条 1:返回30条 */
@property(nonatomic, copy) NSNumber *flag;
/**
 *  具体推荐的类型
 *  歌曲分类ID
 */
@property(nonatomic, copy) NSString *ID;
/** 0:已点歌曲 1:已唱歌曲 
 *  0:注册 会检查该手机是否已注册 1:获取动态密码 2;修改密码 会检查该手机是否已注册
 */
@property(nonatomic, copy) NSNumber *action;
/** 房间编号 */
@property(nonatomic, copy) NSString *roomNum;
/** 已点歌曲操作 0:置顶 1:删除 */
@property(nonatomic, copy) NSNumber *operationType;
/** 房间歌曲ID */
@property(nonatomic, copy) NSString *roomSongId;
/** 二维码中的随机编码 */
@property(nonatomic, copy) NSString *code;
/** 歌曲ID */
@property(nonatomic, copy) NSNumber *songId;
/** 商圈名称(可选) */
@property(nonatomic, copy) NSString *businessName;
/** 城市名称(可选) */
@property(nonatomic, copy) NSString *cityName;
/** 标签(可选) */
@property(nonatomic, copy) NSString * tag; //活动
/** 活动ID */
@property(nonatomic, copy) NSNumber * activityId;
/** 纬度 */
@property(nonatomic, copy) NSString *lat;
/** 经度 */
@property(nonatomic, copy) NSString *lng;
/** 智能排序(1:智能排序 2:离我最近 3:人气最高 4:全网最低) */
@property(nonatomic, copy) NSNumber *orderType;
/** 半径(米) (可选)默认 */
@property(nonatomic, copy) NSNumber *range;
/** 用户ID */
@property(nonatomic, copy) NSString *userID;
/** 菜品ID  */
@property(nonatomic, copy) NSString *typeID;
/** 推荐专辑的ID */
@property(nonatomic, copy) NSNumber *themeId;
/** 控制命令 */
@property(nonatomic, strong) NSNumber *controlType;
/** 宝乐迪KTV的ID */
@property(nonatomic, copy) NSString *BLDKTVId;
/** KTV预定日期，格式是06-27 */
@property(nonatomic, copy) NSString *day;
/** 预定KTV的时间，格式是19：30 */
@property(nonatomic, copy) NSString *hour;
/** 预定时常，以小时为单位 */
@property(nonatomic, strong) NSNumber *duration;
/** 包厢类型的枚举值 */
@property(nonatomic, strong) NSNumber *boxTypeId;
/** 包厢类型的文字说明，例如：小包、中包 */
@property(nonatomic, strong) NSString *boxTypeName;
/** 预定KTV时的主题 */
@property(nonatomic, strong) NSString *theme;
/** 下单酒水列表 */
@property(nonatomic, copy) NSString *goodsList;
/** 包厢预定单号 */
@property(nonatomic, copy) NSString *reserveBoxId;
/** 酒水订单号 */
@property(nonatomic, copy) NSString *reserveGoodsId;
/** 用于取消订单借口 可传酒水ID或包厢ID */
@property(nonatomic, copy) NSString *orderId;
/** 乱七八糟字段 */
@property(nonatomic, copy) NSString *goMoney;
///** 订单列表字符串数组 */
//@property(nonatomic, copy) NSString *orderDetailListJsonString;

@property(nonatomic, copy) NSString *picName;
@property(nonatomic, copy) NSString *picValue;
@property(nonatomic, copy) NSString * isForce;
/****************************用于聊天*********************/
@property(nonatomic, copy) NSString *msgContent;
/** 0:文字 1：图片 2：表情 */
@property(nonatomic, strong) NSNumber *msgType;


/************************************ 发现页面相关参数 ***********************/
/** 发现页面ID */
@property (nonatomic, copy) NSString *discoveryId ;
/**  专题ID **/
@property (nonatomic, copy) NSString *specialId ;
/************************************ 首页相关参数 ***********************/
/** 活动类型 */
@property (nonatomic, strong) NSNumber *activityType ;

@property(nonatomic, copy) NSString *msgId;

@property(nonatomic, copy) NSString *message;

/************遥控 ***********/
@property(nonatomic, copy) NSString *boxToken;

@end
