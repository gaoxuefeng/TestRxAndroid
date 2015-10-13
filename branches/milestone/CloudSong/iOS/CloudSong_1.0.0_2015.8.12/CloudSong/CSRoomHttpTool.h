//
//  CSRoomHttpTool.h
//  CloudSong
//
//  Created by sen on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseHttpTool.h"
#import "CSChatMessageResponseModel.h"
#import "CSRoomInfoResponseModel.h"
#import "CSRoomQRResponseModel.h"
@interface CSRoomHttpTool : CSBaseHttpTool

/** 获取房间动态 */
+ (void)getRoomStatusWithParam:(CSRequest *)param success:(void(^)(CSChatMessageResponseModel *result))success failure:(void(^)(NSError *error))failure;

/** 发送房间消息 */
+ (void)sendChatMessageWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure;

/** 获取包厢详情 */
+ (void)getRoomInfoWithParam:(CSRequest *)param success:(void(^)(CSRoomInfoResponseModel *result))success failure:(void(^)(NSError *error))failure;

/** 获取房间二维码 */
+ (void)getRoomQRWithParam:(CSRequest *)param success:(void(^)(CSRoomQRResponseModel *result))success failure:(void(^)(NSError *error))failure;
@end
