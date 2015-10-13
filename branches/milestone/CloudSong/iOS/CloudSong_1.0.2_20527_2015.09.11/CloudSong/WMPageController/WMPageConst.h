//
//  WMPageConst.h
//  WMPageController
//
//  Created by Mark on 15/6/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//
//  WMPageController的导航栏的一些默认属性
//  如懒得设置PageController的属性，可在此自行修改

//  标题的尺寸(选中/非选中)
#define WMTitleSizeSelected 18
#define WMTitleSizeNormal   15

//  标题的颜色(选中/非选中) (P.S.标题颜色是可动画的)
#define WMTitleColorSelected [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1]
#define WMTitleColorNormal   [UIColor colorWithRed:0 green:0 blue:0 alpha:1]

//  导航菜单栏的背景颜色
#define WMMenuBGColor [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]
//  导航菜单栏的高度
#define WMMenuHeight  30
//  导航菜单栏每个item的宽度
#define WMMenuItemWidth 65
//
//  如需要利用观察者来订阅通知，请将 pageController 的 postNotification 设置为 YES
//
//  当一个控制器 init 完成且被添加成为子控制的时候会发布一个通知
//  可用于判断当前控制器的序号，主要用于当同一个控制器管理时，通过判断序号来加载相应数据
//  传递的数据包含两个信息，当前序号 (index) 以及标题 (title)
//
//  Note：由于在滚动中，上一个控制器还未被销毁，若两个相邻控制器都添加了观察，则都会收到通知。
//  视图复用版本详见：https://github.com/wangmchn/YKPageView
static NSString *const WMControllerDidFinishInitNotification = @"WMControllerDidFinishInitNotification";

//  当一个控制器完全被展示在用户面前时发送的通知
//  可用于判断当前控制器的序号，加载或者刷新当前数据.
//  传递的数据包含两个信息，当前序号 (index) 以及标题 title
static NSString *const WMControllerDidFullyDisplayedNotification = @"WMControllerDidFullyDisplayedNotification";
//
//
//
//
//
//
//
//
//
//
//  如果你遇到任何问题，或者有什么更好地建议，都可以联系我.
//  有什么能改进的都可以PR哦~ github有你更美好!~
//  好用的话还希望能够小小star一下~ :)
//  Github: https://github.com/wangmchn
//  Email:  mailto:wangmchn@163.com
