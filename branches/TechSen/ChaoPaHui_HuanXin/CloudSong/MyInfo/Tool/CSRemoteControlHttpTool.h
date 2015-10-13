//
//  CSRemoteControlHttpTool.h
//  CloudSong
//
//  Created by sen on 15/6/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseHttpTool.h"
#import "CSBaseResponseModel.h"
@interface CSRemoteControlHttpTool : CSBaseHttpTool
/**
 *  远程遥控
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)remoteControlWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure;
@end
