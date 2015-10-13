//
//  CSUserInfoModel.m
//  CloudSong
//
//  Created by Ronnie on 15/6/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSUserInfoModel.h"
#import <MJExtension.h>
//#import <SDWebImageDownloader.h>
//#import "Header.h"
@implementation CSUserInfoModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"signature":@"whatIsUp"};
}

- (void)setHeadUrl:(NSString *)headUrl
{
    _headUrl = headUrl;
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_headUrl] options:SDWebImageDownloaderIgnoreCachedResponse progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        GlobalObj.userIcon = image;
//    }];
}
@end
