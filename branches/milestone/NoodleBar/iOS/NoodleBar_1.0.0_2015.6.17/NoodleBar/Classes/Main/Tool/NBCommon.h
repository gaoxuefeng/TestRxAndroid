//
//  NBCommon.h
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Extension.h"
#import "UIImage+Extension.h"
#import "NSString+Extension.h"
#import <SVProgressHUD.h>
#import <Masonry.h>
#import <PureLayout.h>
#define VERSION_KEY @"versionKey"
#define BAIDU_MAP_KEY @"WmlX51VDdqeN1r6N4tAkqq1l"
#define UM_KEY @"5541a9d267e58e98ea001122"
#define WECHAT_KEY @"wxab2825a937bc65f9"


#define TIMEOUT_INTERVAL 20
#define TIMEOUT_ERROR -1001
#define FAIL_CONNECT  -1004

//#define SERVER_BASE @"http://202.142.16.99:9981/"
#define SERVER_BASE @"http://touch.youpin88.cn/"
//#define SERVER_BASE @"http://192.168.1.223:9981/"



#define SERVER_ADDRESS [NSString stringWithFormat:@"%@noodle/",SERVER_BASE]
#define MERCHANT_URL [NSString stringWithFormat:@"%@getAllBussinessByCity.json",SERVER_ADDRESS]
#define GET_MERTHANT_BY_ID_URL [NSString stringWithFormat:@"%@getBusinessById.json",SERVER_ADDRESS]
#define DISHES_URL [NSString stringWithFormat:@"%@dish/getAllDishList.json",SERVER_ADDRESS]
#define APP_ADS_URL [NSString stringWithFormat:@"%@picture/getAPPAD.json",SERVER_ADDRESS]
#define ADES_URL [NSString stringWithFormat:@"%@picture/getADbyBusinessid.json",SERVER_ADDRESS]
#define GET_LOGIN_CODE_URL [NSString stringWithFormat:@"%@Sms/getSms.json",SERVER_ADDRESS]
#define CHECK_LOGIN_CODE_URL [NSString stringWithFormat:@"%@Sms/checkSms.json",SERVER_ADDRESS]
#define GET_USER_INFO_URL [NSString stringWithFormat:@"%@user/getUserinfo.json",SERVER_ADDRESS]
#define GET_USER_ADDRESSES_URL [NSString stringWithFormat:@"%@address/getAddressList.json",SERVER_ADDRESS]
#define ADD_USER_ADDRESSES_URL [NSString stringWithFormat:@"%@address/addAddress.json",SERVER_ADDRESS]
#define DELETE_USER_ADDRESSES_URL [NSString stringWithFormat:@"%@address/removeAddress.json",SERVER_ADDRESS]
#define EDIT_USER_ADDRESSES_URL [NSString stringWithFormat:@"%@address/updateAddress.json",SERVER_ADDRESS]
#define SUBMIT_ORDER_URL [NSString stringWithFormat:@"%@addOrder.json",SERVER_ADDRESS]
#define GET_TAKE_CODE_URL [NSString stringWithFormat:@"%@payOrderStatus.json",SERVER_ADDRESS]
#define GET_ALL_ORDERES_URL [NSString stringWithFormat:@"%@getAllOrder.json",SERVER_ADDRESS]
#define DELETE_ORDERE_URL [NSString stringWithFormat:@"%@removeOrder.json",SERVER_ADDRESS]
#define UPDATE_ORDERE_PAY_METHOD_URL [NSString stringWithFormat:@"%@updateOrderPayType.json",SERVER_ADDRESS]
#define GET_ORDERES_DETAIL_URL [NSString stringWithFormat:@"%@getOrderDetail.json",SERVER_ADDRESS]
#define SUBMIT_FEEDBACK_URL [NSString stringWithFormat:@"%@feedBack/insertFeedBack.json",SERVER_ADDRESS]

#define ABOUT_US_URL [NSString stringWithFormat:@"%@about.json",SERVER_ADDRESS]
#define NO_MERCHANT_URL [NSString stringWithFormat:@"%@nocity.json",SERVER_ADDRESS]



// 屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 屏幕Bounds
#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)

// 判断当前设备型号
#define iPhone4 (SCREEN_HEIGHT == 480.f)
#define iPhone6 (SCREEN_WIDTH == 375.f)
#define iPhone6Plus (SCREEN_WIDTH == 414.f)

// NavBar高度
#define NAVIGATION_BAR_HEIGHT 44.f
// 状态栏高度
#define STATUS_BAR_HEIGHT 20.f
// Tabbar高度
#define TAB_BAR_HEIGHT 49.f

// DEBUG
#if DEBUG
#define NBLog(...) NSLog(__VA_ARGS__)
#else
#define NBLog(...)
#endif

// rgb颜色转换（16进制->10进制）
#define HEX_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 背景色
#define BACKGROUND_COLOR HEX_COLOR(0xeeeeee)

// NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define MAXSIZE CGSizeMake(MAXFLOAT, MAXFLOAT)

#define AUTOLENGTH(x) (x / 320.0 * SCREEN_WIDTH)

// 通知
#define MENU_CATEGORY_DETAIL_PLUS_ON_CLICK @"menuCategoryDetailPlusOnClick" // 用户加号按钮点击抛物线动画
#define CART_CONTENT_CHANGED @"cartContentChanged"
#define CART_VIEW_OPERATE @"cartViewOperate"                                // 购物车View操作,用于刷新MenuView中的菜单列表
#define ORDER_STATUS_CHANGED @"orderStatusChanged"                          // 订单状态改变通知
#define ORDER_BE_PAY @"orderBePay"
#define BACK_FROM_WECHAT_WITH_NO_PAY @"backFromWechatWithNoPay"

typedef enum {
    NBOrderStatusTypeNotPay,            // 未支付
    NBOrderStatusTypeJustPay,           // 刚支付
    NBOrderStatusTypeInMaking,          // 制作中
    NBOrderStatusTypeWaitingForTaking,  // 等待取餐
    NBOrderStatusTypeDone,              // 完成订单
    NBOrderStatusTypeCancel             // 取消订单
}NBOrderStatusType;

typedef enum {
    NBPayMethodTypeWechat = 1,          // 微信支付
    NBPayMethodTypeAlipay               // 支付宝支付
}NBPayMethodType;

typedef enum {
    NBAddressTypeInShop = 1,            // 店中
    NBAddressTypeTakeOut                // 外卖
}NBAddressType;

typedef enum{
    GenderTypeMale, // 男性
    GenderTypeFemale // 女性
}GenderType;





@interface NBCommon : NSObject

@end
