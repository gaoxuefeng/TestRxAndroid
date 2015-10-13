//
//  CSKTVMapViewController.m
//  CloudSong
//
//  Created by sen on 15/7/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSKTVMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "CSMapPaoPaoView.h"
#import "CSActionSheet.h"
#import <MapKit/MapKit.h>
#import "CLLocation+YCLocation.h"
@interface CSKTVMapViewController ()<BMKMapViewDelegate,CSActionSheetDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService *_locationService;
}
@property(nonatomic, copy) NSString *ktvName;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, assign) CGFloat lon;
@property(nonatomic, assign) CGFloat lat;
@property(nonatomic, weak) BMKMapView *mapView;
@property(nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@property(nonatomic, strong) BMKAnnotationView *annotationView;
@property(nonatomic, assign) CLLocationCoordinate2D destination;
@property(nonatomic, assign) CLLocationCoordinate2D selfLocation;

@end

@implementation CSKTVMapViewController
- (instancetype)initWithKTVName:(NSString *)ktvName address:(NSString *)address longitude:(CGFloat)lon latitude:(CGFloat)lat
{
    _ktvName = ktvName;
    _address = address;
    _lon = lon;
    _lat = lat;
    _destination.latitude = lat;
    _destination.longitude = lon;
    return [self init];
}
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"地图";
    [self setupSubviews];
    //初始化定位信息类
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    [_locationService startUserLocationService];
}

#pragma mark - Setup

- (void)setupSubviews
{
    BMKMapView *mapView = [[BMKMapView alloc] init];
    mapView.zoomLevel = 19.0;
    [self.view addSubview:mapView];
    _mapView = mapView;
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mapView.superview);
    }];
    
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _selfLocation = userLocation.location.coordinate;
    [_locationService stopUserLocationService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    [self addPointAnnotationWithLatitude:_lat longitude:_lon];
    [_mapView selectAnnotation:_pointAnnotation animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

#pragma mark - Private Methods
- (void)addPointAnnotationWithLatitude:(CGFloat)lat longitude:(CGFloat)lon
{
    if (_pointAnnotation) return;
    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lon;
    _pointAnnotation.coordinate = coor;
    _pointAnnotation.title = @"导航";
    _pointAnnotation.subtitle = @"导航";
    [_mapView addAnnotation:_pointAnnotation];
    [_mapView setCenterCoordinate:coor animated:NO];
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *annotationViewID = @"renameMark";
    if (_annotationView == nil) {
        _annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
        // 设置颜色
        ((BMKPinAnnotationView *)_annotationView).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        ((BMKPinAnnotationView *)_annotationView).animatesDrop = YES;
        // 设置可拖拽
        ((BMKPinAnnotationView *)_annotationView).draggable = YES;
        
        CSMapPaoPaoView *customView = [[CSMapPaoPaoView alloc] initWithKTVName:_ktvName address:_address];
        [customView addTareget:self action:@selector(navButtonPressed)];
        [customView layoutIfNeeded];
        
        BMKActionPaopaoView* customPaoPaoView = [[BMKActionPaopaoView alloc] initWithCustomView:customView];
        ((BMKPinAnnotationView *)_annotationView).paopaoView = customPaoPaoView;
//        ((BMKPinAnnotationView *)_annotationView).image = [UIImage imageNamed:@"map_end"];
    }
    return _annotationView;
}


#pragma mark - Touch Action
- (void)navButtonPressed
{
    NSString *baiduUrlStr = [NSString stringWithFormat:@"baidumap://map/"];
    NSURL *baiduUrl = [NSURL URLWithString:baiduUrlStr];
    
    NSString *gaodeUrlStr = [NSString stringWithFormat:@"iosamap://"];
    NSURL *gaodeUrl = [NSURL URLWithString:gaodeUrlStr];
    
    
    if (![[UIApplication sharedApplication]canOpenURL : baiduUrl] && ![[UIApplication sharedApplication] canOpenURL:gaodeUrl]) {
//        [self appleMaps];
    }
    else
    {

        NSMutableArray *buttonArrays = [[NSMutableArray alloc] init];
            [buttonArrays addObject:@"使用苹果地图导航"];

        if([[UIApplication sharedApplication]canOpenURL : baiduUrl])
        {
            [buttonArrays addObject:@"使用百度地图导航"];
        }
        
        if([[UIApplication sharedApplication] canOpenURL:gaodeUrl])
        {
            [buttonArrays addObject:@"使用高德地图导航"];
        }
        
        CSActionSheet *actionSheet = [[CSActionSheet alloc] initWithDelegate:self headerTitle:@"请选择地图" cancelButtonTitle:@"取消" otherButtonTitles:buttonArrays];
        [actionSheet show];
    }
}

-(void)appleMaps
{
    
    CLLocationCoordinate2D coords1 = _selfLocation;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_destination.latitude longitude:_destination.longitude];
    location = location.locationMarsFromBaidu;
    CLLocationCoordinate2D coords2 = location.coordinate;
//    CLLocationCoordinate2D coords2 = _destination;
    
    //起点
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
    toLocation.name = _ktvName;
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],MKLaunchOptionsShowsTrafficKey:@YES
                              };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

-(void)baiduMaps
{
    CLLocationCoordinate2D coords1 = _selfLocation;
    CLLocationCoordinate2D coords2 = _destination;
    NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving",coords1.latitude,coords1.longitude,coords2.latitude,coords2.longitude];
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [[UIApplication sharedApplication] openURL:url];
}



-(void)gaodeMaps
{
//    CLLocationCoordinate2D coords1 = _selfLocation;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_destination.latitude longitude:_destination.longitude];
    location = location.locationMarsFromBaidu;
    CLLocationCoordinate2D coords2 = location.coordinate;
    NSString *stringURL = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=0&style=2",@"CloundSong",@"CloundSong",_ktvName,coords2.latitude, coords2.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - CSActionSheetDelegate
- (void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"使用苹果地图导航"]) {
        [self appleMaps];
    }else if ([title isEqualToString:@"使用百度地图导航"])
    {
        [self baiduMaps];
    }else if ([title isEqualToString:@"使用高德地图导航"])
    {
        [self gaodeMaps];
    }
}
@end
