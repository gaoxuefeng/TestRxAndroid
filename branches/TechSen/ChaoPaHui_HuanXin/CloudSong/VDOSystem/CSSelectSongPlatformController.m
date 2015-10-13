//
//  CSSelectSongPlatformController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSelectSongPlatformController.h"
#import <UIKit/UIKit.h>
#import "CSDefine.h"
#import "CSVODAllSingingCell.h"
#import "CSRecommendedAlbumCollectionCell.h"
#import "CSDataService.h"
#import "CSSongSelectPlatformView.h"
#import <Masonry.h>
#import "CSSong.h"
#import <MJRefresh.h>

static NSString *identifier = @"CSRecommendedAlbumCollectionCell";

@interface CSSelectSongPlatformController () <CSSongSelectPlatformViewDelegate, CSVODAllSingingCellDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CSSongSelectPlatformView* _platformView;
    NSArray*         _allSingSongs;
    NSArray*         _albums;
}
@end

@implementation CSSelectSongPlatformController
@synthesize platformView;

#pragma mark - Public Methods

- (CSSongSelectPlatformView *)platformView {
    if (!_platformView) {
        _platformView = [[CSSongSelectPlatformView alloc] init];
        _platformView.tableView.dataSource = self;
        _platformView.tableView.delegate = self;
        _platformView.tableView.backgroundColor =[UIColor clearColor];
        _platformView.delegate = self;
        [self setupRefreshView];
    }
    return _platformView;
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    _platformView.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getUnsinged];
        [self refreshData];
        [_platformView.tableView.header endRefreshing] ;
    }] ;
}
- (void)refreshData {
    [self getUnsinged];
    CSDataService *svc = [CSDataService sharedInstance];
    [svc asyncGetVODAllSingSongsType:CSDataServiceAllSingSongsTypeOpertion startIndex:0 refreshHandler:^(NSArray *songs) {
        _allSingSongs = songs;
        [_platformView reloadData];
    }];
    [svc asyncGetVODAlbumsHandler:^(NSArray *albums) {
        _albums = albums;
        [_platformView reloadData];
    }];

}
//获取已点未唱
- (void)getUnsinged{
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    if (roomInfo.starting) {
        [[CSDataService sharedInstance]asyncGetUnsingedhandlerhandler:^(NSArray *songId) {
            CSLog(@"%@",songId);
            NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            
            NSMutableDictionary * identDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [identDic setObject:[NSMutableArray arrayWithArray:songId] forKey:roomInfo.reserveBoxId];
            NSData * identData =[NSKeyedArchiver archivedDataWithRootObject:identDic];
            [[NSUserDefaults standardUserDefaults]setObject:identData forKey:@"songIdentifier"];
            [_platformView reloadData];
        }];
    }
    
}
#pragma mark - Action Methods

- (void)moreBtnPressed {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformControllerDidPressMoreButton:)]) {
        [self.delegate selectSongPlatformControllerDidPressMoreButton:self];
    }
}

#pragma mark - CSSongSelectPlatformViewDelegate

- (void)songSelectPlatformViewDidBeginSearch:(CSSongSelectPlatformView *)view {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformControllerDidBeginSearach:)]) {
        [self.delegate selectSongPlatformControllerDidBeginSearach:self];
    }
}

- (void)songSelectPlatformViewDidPressSingerButton:(CSSongSelectPlatformView *)view {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformControllerDidPressSingerButton:)]) {
        [self.delegate selectSongPlatformControllerDidPressSingerButton:self];
    }
}

- (void)songSelectPlatformViewDidPressLanguageButton:(CSSongSelectPlatformView *)view {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformControllerDidPressLanguageButton:)]) {
        [self.delegate selectSongPlatformControllerDidPressLanguageButton:self];
    }
}

- (void)songSelectPlatformViewDidPressCategoryButton:(CSSongSelectPlatformView *)view {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformControllerDidPressCategoryButton:)]) {
        [self.delegate selectSongPlatformControllerDidPressCategoryButton:self];
    }
}

- (void)songSelectPlatformViewDidPressNewSongButton:(CSSongSelectPlatformView *)view {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformControllerDidPressNewSongButton:)]) {
        [self.delegate selectSongPlatformControllerDidPressNewSongButton:self];
    }
}

- (void)songSelectPlatformViewDidPressHotListButton:(CSSongSelectPlatformView *)view {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformControllerDidPressHotListButton:)]) {
        [self.delegate selectSongPlatformControllerDidPressHotListButton:self];
    }
}

#pragma mark - CSVODAllSingingCellDelegate

- (void)allSingingCell:(CSVODAllSingingCell *)cell didSelectSong:(CSSong *)song {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformController:didSelectSong:)]) {
        NSIndexPath *path = [_platformView.tableView indexPathForCell:cell];
//        [self.delegate selectSongPlatformController:self didSelectSong:_allSingSongs[path.row]];
        [self.delegate selectSongPlatformController:self didSelectIndexPath:path Song:_allSingSongs[path.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? _allSingSongs.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"CSVODAllSingingCell";
        CSVODAllSingingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CSVODAllSingingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        UILabel * numLabel = [cell.contentView.subviews objectAtIndex:0];
        NSString * numText = [NSString string];
        numText = [NSString stringWithFormat:@"%02ld",indexPath.row+1];
        numLabel.text = numText;
        NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
        NSArray * array = [dic objectForKey:roomInfo.reserveBoxId];
        UIButton * cellBut=nil;
        for (id obj in cell.contentView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                cellBut = obj;
            }
        }
        if ([array containsObject:[_allSingSongs [indexPath.row] songId]]) {
                cellBut.selected=YES;
        }else{
                cellBut.selected=NO;
        }
        [cell setDataWithSong:_allSingSongs[indexPath.row]];
        cell.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:.04];
        return cell;
    }
    else {
        static NSString *identifier = @"RecommendedAlbumCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.backgroundColor = HEX_COLOR(0x1c1c20);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CSLog(@"%@",cell);
        });
        cell.backgroundColor = WhiteColor_Alpha_4;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? TRANSFER_SIZE(36) : TRANSFER_SIZE(51);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    
    if (section == 0) {
        UIImageView * backImage= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_2"]];
        backImage.userInteractionEnabled=YES;
        [header addSubview:backImage];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header);
            make.right.equalTo(header);
            make.top.equalTo(header);
            make.bottom.equalTo(header);
        }];
        // 粉色竖线
        UIView *vSep = [[UIView alloc] init];
        [header addSubview:vSep];
        vSep.backgroundColor = HEX_COLOR(0xff41ab);
        [vSep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vSep.superview).offset(TRANSFER_SIZE(12));
            make.centerY.equalTo(header);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(1), TRANSFER_SIZE(12)));
        }];
        
        // label
        UILabel *title = [[UILabel alloc] init];
        [header addSubview:title];
        title.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
        title.textColor = HEX_COLOR(0xffffff);
        title.text = @"大家都在唱";
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.superview).offset(TRANSFER_SIZE(22));
            make.centerY.equalTo(header);
            make.width.mas_equalTo(TRANSFER_SIZE(100));
            make.height.mas_equalTo(TRANSFER_SIZE(14));
        }];

        // 更多 button
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [header addSubview:moreButton];
        [moreButton addTarget:self action:@selector(moreBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//        [moreButton setTitle:@"更多 >" forState:UIControlStateNormal];
//        moreButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
//        [moreButton setTitleColor:[HEX_COLOR(0x898b93) colorWithAlphaComponent:.8] forState:UIControlStateNormal];
        [moreButton setImage:[UIImage imageNamed:@"song_more_icon"] forState:UIControlStateNormal];
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moreButton.superview).offset(TRANSFER_SIZE(-13));
            make.top.bottom.equalTo(moreButton.superview);
        }];
    }
    else {
        
        UIImageView * backImage= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_2"]];
        backImage.userInteractionEnabled=YES;
        [header addSubview:backImage];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header);
            make.right.equalTo(header);
            make.top.mas_equalTo(header).offset(15);
            make.bottom.equalTo(header);
        }];
        // 横向分隔线
//        UIImageView *sep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_on"]];
//        [header addSubview:sep];
//        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(sep.superview);
//            make.height.mas_equalTo(1);
//        }];
        
        // 粉色竖线
        UIView *vSep = [[UIView alloc] init];
        [header addSubview:vSep];
        vSep.backgroundColor = HEX_COLOR(0xff41ab);
        [vSep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backImage).offset(TRANSFER_SIZE(12));
            make.centerY.equalTo(backImage);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(1), TRANSFER_SIZE(12)));
        }];
        
        // label
        UILabel *title = [[UILabel alloc] init];
        [header addSubview:title];
        title.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
        title.textColor = HEX_COLOR(0xffffff);
        title.text = @"推荐专辑";
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.superview).offset(TRANSFER_SIZE(22));
            make.centerY.equalTo(vSep);
            make.width.mas_equalTo(TRANSFER_SIZE(100));
            make.height.mas_equalTo(TRANSFER_SIZE(14));
        }];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return TRANSFER_SIZE(60);
    else
        return TRANSFER_SIZE(125) * ((_albums.count + 1)/2);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UICollectionView *collectionView = (UICollectionView *)[cell viewWithTag:1023];
        if (!collectionView) {
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            [cell.contentView addSubview:collectionView];
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.scrollEnabled = NO;
            [collectionView registerClass:[CSRecommendedAlbumCollectionCell class] forCellWithReuseIdentifier:identifier];
            [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
//                make.left.equalTo(cell.contentView);
//                make.right.equalTo(cell.contentView);
//                make.top.mas_equalTo(cell.contentView).offset(10);
//                make.bottom.equalTo(cell.contentView);
            }];
            collectionView.dataSource = self;
            collectionView.delegate = self;
        }
        [collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSRecommendedAlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setDataWithAlbum:_albums[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(selectSongPlatformController:didSelectAlbum:)]) {
        [self.delegate selectSongPlatformController:self didSelectAlbum:_albums[indexPath.row] ];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20 * SCREENWIDTH/640, 10, 20 * SCREENWIDTH/640);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(290 * SCREENWIDTH/640, 166 * SCREENWIDTH/640 + 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return TRANSFER_SIZE(0);
}
@end
