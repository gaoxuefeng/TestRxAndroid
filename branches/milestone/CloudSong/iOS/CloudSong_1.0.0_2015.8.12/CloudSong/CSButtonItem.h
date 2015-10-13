//
//  CSButtonItem.h
//  CloudSong
//
//  Created by youmingtaizi on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSButtonItem : NSObject
@property (nonatomic, assign)NSInteger  identifier;
@property (nonatomic, strong)NSString*  imageSrc;
@property (nonatomic, strong)UIImage*   image;
@property (nonatomic, strong)NSString*  title;
@end