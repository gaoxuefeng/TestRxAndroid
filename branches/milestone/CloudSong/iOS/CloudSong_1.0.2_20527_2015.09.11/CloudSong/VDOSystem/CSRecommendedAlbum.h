//
//  CSAlbum.h
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSRecommendedAlbum : NSObject
@property (nonatomic, strong)NSNumber*  identifier;
@property (nonatomic, strong)NSString*  imageUrl;
@property (nonatomic, strong)NSString*  listTypeName;
@property (nonatomic, strong)UIImage*   image;
@end
