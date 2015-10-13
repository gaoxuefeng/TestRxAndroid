//
//  NBLocation.m
//  NoodleBar
//
//  Created by sen on 6/3/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBLocation.h"

@interface NBLocation ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locationService;
    BMKGeoCodeSearch *_geoCodeSearch;
}

@end


@implementation NBLocation

static NSString *_currentCity;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setDelegate:(id<NBLocationDelegate>)delegate
{
    _delegate = delegate;
    
    if (_currentCity) {
        if ([self.delegate respondsToSelector:@selector(didGetCurrentCity:)]) {
            [self.delegate didGetCurrentCity:_currentCity];
        }
        return;
    }
    
    _locationService = [[BMKLocationService alloc] init];
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        
//        //由于IOS8中定位的授权机制改变 需要进行手动授权
//        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
//        //获取授权认证
//        [locationManager requestAlwaysAuthorization];
//        [locationManager requestWhenInUseAuthorization];
//    }
    _locationService.delegate = self;
    [_locationService startUserLocationService];
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    BMKReverseGeoCodeOption *geoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    geoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [_geoCodeSearch reverseGeoCode:geoCodeOption];
    _geoCodeSearch.delegate = self;
    if ([self.delegate respondsToSelector:@selector(didGetCurrentLocation:)]) {
        [self.delegate didGetCurrentLocation:userLocation.location.coordinate];
    }
    [_locationService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{

}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if ([self.delegate respondsToSelector:@selector(didGetCurrentCity:)]) {
        _currentCity = result.addressDetail.city;
        [self.delegate didGetCurrentCity:result.addressDetail.city];
    }
}

- (void)dealloc
{
    _locationService.delegate = nil;
    _geoCodeSearch.delegate = nil;
}

@end
