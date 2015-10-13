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

- (instancetype)copyWithZone:(NSZone *)zone
{
    CSUserInfoModel *userInfo = [[[self class] allocWithZone:zone] init];
    userInfo.phoneNum = self.phoneNum;
    userInfo.gender = self.gender;
    userInfo.age = self.age;
    userInfo.headUrl = self.headUrl;
    userInfo.nickName = self.nickName;
    userInfo.bloodType = self.bloodType;
    userInfo.constellation = self.constellation;
    userInfo.signature = self.signature;
    userInfo.loveSingers = self.loveSingers;
    userInfo.loveSongs = self.loveSongs;
    return userInfo;
}

- (BOOL)isEqualUserInfo:(CSUserInfoModel *)userInfo
{
    BOOL isEqual = YES;
    if (![self.phoneNum isEqualToString:userInfo.phoneNum]) {
        return NO;
    }
    if (![self.gender isEqualToString:userInfo.gender]) {
        return NO;
    }
    if (![self.age isEqualToNumber:userInfo.age]) {
        return NO;
    }
    if (![self.nickName isEqualToString:userInfo.nickName]) {
        return NO;
    }
    if (![self.bloodType isEqualToString:userInfo.bloodType]) {
        return NO;
    }
    if (![self.constellation isEqualToString:userInfo.constellation]) {
        return NO;
    }
    return isEqual;
}
@end
