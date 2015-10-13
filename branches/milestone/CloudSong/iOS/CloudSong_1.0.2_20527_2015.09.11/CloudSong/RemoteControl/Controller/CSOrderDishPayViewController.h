//
//  CSOrderDishPayViewController.h
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSKTVDishListResponseDataModel.h"
typedef NS_ENUM(NSInteger, CSDishPayViewControllerType) {
    CSDishPayViewControllerTypeNomal,               // 普通
    CSDishPayViewControllerTypeRepay                // 再次支付
};

typedef void(^PaySuccess)(BOOL success);

@interface CSOrderDishPayViewController : CSBaseViewController
@property(nonatomic, strong) CSKTVDishListResponseDataModel *data;

@property(copy, nonatomic) PaySuccess payBlock;

- (instancetype)initWithType:(CSDishPayViewControllerType)type;

@end
