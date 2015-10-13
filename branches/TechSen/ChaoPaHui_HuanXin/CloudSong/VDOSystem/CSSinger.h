//
//  CSSinger.h
//  CloudSong
//
//  Created by youmingtaizi on 6/5/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSSinger : NSObject
@property (nonatomic, strong)NSString*  singerId;
@property (nonatomic, strong)NSString*  singerImageUrl;
@property (nonatomic, strong)NSString*  singerName;
@property (nonatomic, strong)UIImage*   singerImage;
@end