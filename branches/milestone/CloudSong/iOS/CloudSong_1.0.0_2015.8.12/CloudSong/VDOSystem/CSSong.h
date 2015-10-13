//
//  CSSong.h
//  CloudSong
//
//  Created by youmingtaizi on 5/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSSinger.h"

@interface CSSong : NSObject
//@property (nonatomic, strong)NSNumber*  identifier;
@property (nonatomic, strong)NSNumber*  songId;

@property (nonatomic, strong)NSString*  language;
@property (nonatomic, strong)NSArray*   singers;
@property (nonatomic, strong)NSString*  songImageUrl;
@property (nonatomic, strong)NSString*  songName;
@property (nonatomic, strong)UIImage*   image;
@property (nonatomic, strong)NSString*  roomSongId;
@end
