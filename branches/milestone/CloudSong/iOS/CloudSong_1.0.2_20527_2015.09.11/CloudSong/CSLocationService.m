//
//  CSLocationService.m
//  CloudSong
//
//  Created by youmingtaizi on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSLocationService.h"
#import <BaiduMapAPI/BMapKit.h>
#import "Header.h"

@interface CSLocationService () <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>{
    BOOL            _isLocating;
    NSMutableSet*   _delegates;
    BMKLocationService* _locService;
    BMKGeoCodeSearch*   _geocodesearch;
}
@end

@implementation CSLocationService

#pragma mark - Life Cycle

- (id)init {
    if (self = [super init]) {
        _delegates = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Public Methods

+ (instancetype)sharedInstance {
    static CSLocationService *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)addDelegate:(id<CSLocationServiceDelegate>)delegate {
    [_delegates addObject:delegate];
}

- (void)removeDelegate:(id<CSLocationServiceDelegate>)delegate {
    [_delegates removeObject:delegate];
}

// 开始定位
- (void)startGetLocation {
    if (!_locService) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    [_locService startUserLocationService];
}

// 结束定位
- (void)didStopLocatingUser{
    [SVProgressHUD dismiss] ;
}


- (void)getCityWithCoordinate:(CLLocationCoordinate2D)coordinate {
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    
    if (!_geocodesearch) {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;
    }
    if (![_geocodesearch reverseGeoCode:reverseGeocodeSearchOption])
        CSLog(@"反geo检索发送失败");
}

#pragma mark - BMKLocationServiceDelegate

// 获取用户的坐标
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    if (userLocation.location) {
        [_locService stopUserLocationService];
        
        for (id<CSLocationServiceDelegate>delegate in _delegates) {
            if ([delegate respondsToSelector:@selector(locationService:didGetCoordinate:)]) {
                [delegate locationService:self didGetCoordinate:userLocation.location.coordinate];
            }
        }
    }
}

#pragma mark - BMKGeoCodeSearchDelegate

// 根据坐标获取城市名
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    BOOL shouldTryAgain = YES;
    if (!error) {
        NSString *city = result.addressDetail.city;
        if ([city hasSuffix:@"市"])
            city = [city substringToIndex:city.length - 1];

        if (city.length > 0) {
            shouldTryAgain = NO;
            [_locService stopUserLocationService];
            
            [[GlobalVar sharedSingleton] setCurrentCity:city];
            for (id<CSLocationServiceDelegate> delegate in _delegates) {
                if ([delegate respondsToSelector:@selector(locationService:didLocationInCity:)])
                    [delegate locationService:self didLocationInCity:city];
            }
        }
    }
    if (shouldTryAgain) {
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
        reverseGeocodeSearchOption.reverseGeoPoint = result.location;
        if (![_geocodesearch reverseGeoCode:reverseGeocodeSearchOption])
            CSLog(@"反geo检索发送失败");
    }
}

@end
