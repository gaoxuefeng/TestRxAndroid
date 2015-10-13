//
//  CSRequestUrl.h
//  CloudSong
//
//  Created by Ronnie on 15/6/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//
#import "CSDefine.h"

#ifndef CloudSong_CSRequestUrl_h
#define CloudSong_CSRequestUrl_h

#define GET_SMS_CODE_URL [NSString stringWithFormat:@"%@Sms/getSms.json",ServiceCloudURL]//获取短信验证码
#define CHECK_SMS_CODE_URL [NSString stringWithFormat:@"%@Sms/checkSms.json",ServiceCloudURL]//验证短信码
#define USER_REGISTER_URL [NSString stringWithFormat:@"%@login/register.json",ServiceCloudURL]//注册
#define USER_LOGIN_URL [NSString stringWithFormat:@"%@login/login.json",ServiceCloudURL]//登录
#define PIC_UPLOAD_URL [NSString stringWithFormat:@"%@login/savePic.json",ServiceCloudURL]//图片上传

#define DYNAMIC_LOGIN_URL [NSString stringWithFormat:@"%@login/dynamicLogin.json",ServiceCloudURL]//动态密码登录
#define ALTER_PWD_URL [NSString stringWithFormat:@"%@login/modifypw.json",ServiceCloudURL]//修改密码

#define USER_Binding_URL [NSString stringWithFormat:@"%@login/binding.json",ServiceCloudURL]//手机号绑定
#define USER_THREE_PART_URL [NSString stringWithFormat:@"%@login/threePart.json",ServiceCloudURL]//第三方登录
#define USER_PROFILE_URL [NSString stringWithFormat:@"%@login/profile.json",ServiceCloudURL]//完善个人资料
#define GET_USER_INFO_URL [NSString stringWithFormat:@"%@login/queryinfo.json",ServiceCloudURL]//获取个人资料
#define REMOTE_CONTROL_URL [NSString stringWithFormat:@"%@controller",ServiceBoxURL]//遥控器


/** 点餐 */
#define DISH_LIST_CLOUD_URL [NSString stringWithFormat:@"%@goods/getall.json",ServiceCloudURL]//云服务菜品接口
#define DISH_LIST_KTV_URL [NSString stringWithFormat:@"%@goods/getall.json",ServiceKTVURL]//包厢菜品接口
/** 提交菜品订单接口(云服) */
#define SUBMIT_DISH_ORDER_URL [NSString stringWithFormat:@"%@goods/genorder.json",ServiceCloudURL]
/** 提交菜品订单接口(KTV服) */
#define SUBMIT_KTV_DISH_ORDER_URL [NSString stringWithFormat:@"%@goods/genorder.json",ServiceKTVURL]
/** 获取微信支付预订单号 */
#define GET_WEICHAT_PREPAY_ID_URL [NSString stringWithFormat:@"%@ktvorder/genPreOrder.json",ServiceCloudURL]
/** 获取用户消费列表 */
#define GET_COST_LIST_URL [NSString stringWithFormat:@"%@ktvorder/getorders.json",ServiceCloudURL]
/** 获取房间消费详情 */
#define GET_ROOM_COST_DETAIL_URL [NSString stringWithFormat:@"%@ktvorder/ktvorderDetail.json",ServiceCloudURL]
/** 获取房间消费详情 */
#define GET_DISH_COST_DETAIL_URL [NSString stringWithFormat:@"%@goods/goodsorderDetail.json",ServiceCloudURL]
/** 获取房间列表 */
#define GET_ROOM_LIST_URL [NSString stringWithFormat:@"%@my/room/get.json",ServiceCloudURL]
/** 取消酒水订单 */
#define CANCEL_ORDER_URL [NSString stringWithFormat:@"%@ktvorder/cancleOrder.json",ServiceCloudURL]


/** 获取房间成员列表 */
#define GET_ROOM_MEMBER_LIST_URL [NSString stringWithFormat:@"%@my/join/people/get.json",ServiceCloudURL]



/** 获取房间动态(云服务器) */
#define GET_CLOUD_ROOM_STATUS_URL [NSString stringWithFormat:@"%@roomdynamic/getnew.json",ServiceCloudURL]
/** 获取房间动态(KTV服务器) */
#define GET_KTV_ROOM_STATUS_URL [NSString stringWithFormat:@"%@roomdynamic/getnew.json",ServiceKTVURL]

/** 发送房间动态(KTV服务器) */
#define SEND_KTV_STATUS_URL [NSString stringWithFormat:@"%@roomdynamic/add.json",ServiceKTVURL]


/** 获取房间详情 */
#define GET_ROOM_INFO_URL [NSString stringWithFormat:@"%@my/box/detail.json",ServiceCloudURL]

/** 获取二维码 */
#define GET_ROOM_QR_URL [NSString stringWithFormat:@"%@banding/genQRCode.json",ServiceKTVURL]

/** 发送用户反馈 */
#define SEND_FEEDBACK_URL [NSString stringWithFormat:@"%@feedbackmessage/getinfo.json",ServiceCloudURL]
#endif
