//
//  CSUserDataWrapperModel.h
//  CloudSong
//
//  Created by Ronnie on 15/6/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSUserDataResponeModel.h"
@interface CSUserDataWrapperModel : CSBaseResponseModel
@property (nonatomic ,strong)  CSUserDataResponeModel *data;
@end
