//
//  CSCityChoosingController.m
//  CloudSong
//
//  Created by youmingtaizi on 5/20/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSCityChoosingController.h"
#import <UIKit/UIKit.h>
#import "CSDataService.h"
#import "CSDefine.h"
#import "CSCitySelectView.h"
#import <Masonry.h>
#import "CSHotCityCollectionViewCell.h"
#import "CSLocationService.h"
#import "SVProgressHUD.h"

@interface CSCityChoosingController () <CSCitySelectViewDelegate, CSLocationServiceDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> {
    CSCitySelectView*   _citySelectView;
}
@end

@implementation CSCityChoosingController

#pragma mark - Life Cycle

- (id)init {
    if (self = [super init]) {
        [self prepareForUse];
    }
    return self;
}

#pragma mark - Public Methods

- (void)hideKeyboard {
    [_citySelectView hideKeyboard];
}

- (UIView *)citySelectView {
    return _citySelectView;
}

- (void)reloadData {
    [_citySelectView reloadData];
}

#pragma mark - Private Methods

- (void)prepareForUse {
    _citySelectView = [[CSCitySelectView alloc] initWithFrame:CGRectZero];
    _citySelectView.dataSource = self;
    _citySelectView.delegate = self;
    _citySelectView.searchDelegate = self ;
    _citySelectView.locationDelegate = self;
    _citySelectView.collectionViewDataSource = self;
    _citySelectView.collectionViewDelegate = self;
}

#pragma mark - CSCitySelectViewDelegate

- (void)citySelectViewDidPressLocationBtn:(CSCitySelectView *)view {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"定位服务未开启，请在系统设置中开启定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [[CSLocationService sharedInstance] addDelegate:self];
    [SVProgressHUD showWithStatus:@"正在定位..." maskType:SVProgressHUDMaskTypeGradient] ;
    [[CSLocationService sharedInstance] startGetLocation];

    
}

// 点击搜索结果选中城市
- (void)citySelectViewWillSearchCity:(NSString *)selectCity{
    GlobalObj.currentCity = selectCity ;
    if ([self.delegate respondsToSelector:@selector(cityChoosingController:didSelectCity:)]) {
        [self.delegate cityChoosingController:self didSelectCity:GlobalObj.currentCity];
    }
}

#pragma mark - CSLocationServiceDelegate

- (void)locationService:(CSLocationService *)svc didGetCoordinate:(CLLocationCoordinate2D)coordinate {
    [[CSLocationService sharedInstance] getCityWithCoordinate:coordinate];
}

- (void)locationService:(CSLocationService *)svc didLocationInCity:(NSString *)city {
    GlobalObj.currentCity = city;
    if ([self.delegate respondsToSelector:@selector(cityChoosingController:didSelectCity:)]) {
        [self.delegate cityChoosingController:self didSelectCity:GlobalObj.currentCity];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_citySelectView hideKeyboard];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    static BOOL hasSetHeaderView = NO;
    if (!hasSetHeaderView) {
        hasSetHeaderView = YES;
        CGRect headerFrame = tableView.tableHeaderView.frame;
        headerFrame.size.height = 28;
        tableView.tableHeaderView.frame = headerFrame;
        tableView.tableHeaderView = tableView.tableHeaderView;
    }
    return [[CSDataService sharedInstance] cityChoosingTitles].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = 0;
    // 国内热门城市
    if (section == 0)
        result = 1;
    else {
        NSString *title = [[CSDataService sharedInstance] cityChoosingTitles][section];
        result = ((NSArray *)([[CSDataService sharedInstance] allCities][title])).count;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 国内热门城市
    if (indexPath.section + indexPath.row == 0) {
        static NSString *identifier = @"HotCityCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                                  collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            [cell.contentView addSubview:collectionView];
            [collectionView registerClass:[CSHotCityCollectionViewCell class] forCellWithReuseIdentifier:@"CSHotCityCollectionViewCell"];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView.backgroundColor = [UIColor clearColor];

            [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(TRANSFER_SIZE(8));
                make.right.equalTo(cell.contentView).offset(TRANSFER_SIZE(-16));
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];
        }
        cell.backgroundColor = WhiteColor_Alpha_4;
        return cell;
    }
    // 其他cell
    else {
        static NSString *identifier = @"CityChoosingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *title = [[CSDataService sharedInstance] cityChoosingTitles][indexPath.section];
        NSArray *cities = [[[CSDataService sharedInstance] allCities] objectForKey:title];
        cell.textLabel.text = cities[indexPath.row];
        cell.textLabel.textColor = [HEX_COLOR(0x9799a1) colorWithAlphaComponent:.5];
        cell.textLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
        cell.backgroundColor = WhiteColor_Alpha_4;
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;
    }
}

/**
 *  右边索引条
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[CSDataService sharedInstance] cityChoosingIndexTitles];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = WhiteColor_Alpha_4;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    title.textColor = [HEX_COLOR(0x9799a1) colorWithAlphaComponent:.8];
    title.text = [[CSDataService sharedInstance] cityChoosingTitles][section];

    [header addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(TRANSFER_SIZE(12));
        make.right.equalTo(header);
        make.top.equalTo(header);
        make.bottom.equalTo(header);
    }];
    
    if (section > 0) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"song_line_durn"];
        [header addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header);
            make.right.equalTo(header);
            make.bottom.equalTo(header);
            make.height.mas_equalTo(TRANSFER_SIZE(1));
        }];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return TRANSFER_SIZE(135);
    }
    return TRANSFER_SIZE(39);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TRANSFER_SIZE(section == 0 ? 39 : 32);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > 0) {
        NSString *title = [[CSDataService sharedInstance] cityChoosingTitles][indexPath.section];
        GlobalObj.currentCity = [[CSDataService sharedInstance] allCities][title][indexPath.row];
        if ([self.delegate respondsToSelector:@selector(cityChoosingController:didSelectCity:)]) {
            [self.delegate cityChoosingController:self didSelectCity:GlobalObj.currentCity];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"CSHotCityCollectionViewCell";
    CSHotCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[CSHotCityCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    [cell setTitle:[[CSDataService sharedInstance] hotCityData][indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(TRANSFER_SIZE(87), TRANSFER_SIZE(29));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return TRANSFER_SIZE(6);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GlobalObj.currentCity = [[CSDataService sharedInstance] hotCityData][indexPath.row];
    if ([self.delegate respondsToSelector:@selector(cityChoosingController:didSelectCity:)]) {
        [self.delegate cityChoosingController:self didSelectCity:GlobalObj.currentCity];
    }
}

@end



