//
//  CSQRCodeReadHttpTool.h
//  CloudSong
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseHttpTool.h"
#import "CSBaseResponseModel.h"
#import "CSBindingRoomResponseModel.h"
@interface CSQRCodeReadHttpTool : CSBaseHttpTool
/**
 *  绑定包厢
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)bindingRoomWithParam:(CSRequest *)param success:(void(^)(CSBindingRoomResponseModel *result))success failure:(void(^)(NSError *error))failure;

@end
