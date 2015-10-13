//
//  CSSongHistoryController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSongHistoryController.h"
#import <UIKit/UIKit.h>
#import "CSDataService.h"
#import "CSDefine.h"
#import "CSRoomSongData.h"
#import "CSUtil.h"
#import "CSVODAllSingingCell.h"
#import "CSSong.h"
#import "SVProgressHUD.h"

static NSString*  identifier = @"CSExpandSongCell";

@interface CSSongHistoryController () <UITableViewDataSource, UITableViewDelegate,CSVODAllSingingCellDelegate> {
    UITableView*    _tableView;
    NSArray*        _songs;
    NSInteger       _selectedRow;
}
@end

@implementation CSSongHistoryController
@synthesize tableView;

#pragma mark - Public Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = HEX_COLOR(0x1c1c20);
        _tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[CSVODAllSingingCell class] forCellReuseIdentifier:identifier];
        [CSUtil hideEmptySeparatorForTableView:_tableView];
    }
    return _tableView;
}

- (void)refreshData {
    _selectedRow = -1;
//    [[CSDataService sharedInstance] asyncGetSongsInRoomWithType:1 startIndex:0 handler:^(NSArray *songs) {
//        _songs = songs;
//        [_tableView reloadData];
//    }];
    
    [[CSDataService sharedInstance]asyncGetHistorySongsInRoomWithStartIndex:0 handler:^(NSArray *songs) {
        _songs = songs;
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"CSExpandSongCell";
//    CSExpandSongCell *cell = [theTableView dequeueReusableCellWithIdentifier:identifier];
//    [cell setDataWithSong:[_songs[indexPath.row] song]];
    
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
    if ([array containsObject:[_songs [indexPath.row] songId]]) {
        for (id obj in cell.contentView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * button = obj;
                button.selected=YES;
            }
        }
    }
    [cell setDataWithSong:_songs[indexPath.row]];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81;
//    return indexPath.row == _selectedRow ? 125 : 81;
}

//- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_selectedRow == indexPath.row)
//        _selectedRow = -1;
//    else
//        _selectedRow = indexPath.row;
//    [theTableView reloadData];
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(CSVODAllSingingCell *)cell setDataWithSong:_songs[indexPath.row]];
}


#pragma mark - CSVODAllSingingCellDelegate

- (void)allSingingCell:(CSVODAllSingingCell *)cell didSelectSong:(CSSong *)song {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    NSArray * array = [dic objectForKey:roomInfo.reserveBoxId];
    if (![array containsObject:song.songId]) {
        
        [[CSDataService sharedInstance] asyncSelectSong:song forcely:NO handler:^(BOOL success) {

            UIButton * button = nil;
            CSVODAllSingingCell *cell = (CSVODAllSingingCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            for (id obj in cell.contentView.subviews) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    button = obj;
                }
            }
            if (success) {
                
                [SVProgressHUD showSuccessWithStatus:@"点歌成功"];
                NSMutableArray * identArray = [NSMutableArray arrayWithArray:array];
                [identArray addObject:song.songId];
                NSMutableDictionary * identDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [identDic setObject:identArray forKey:roomInfo.reserveBoxId];
                NSData * identData =[NSKeyedArchiver archivedDataWithRootObject:identDic];
                [[NSUserDefaults standardUserDefaults]setObject:identData forKey:@"songIdentifier"];
                button.enabled=YES;
                button.selected=YES;
            }else{
                button.selected=NO;
                button.enabled=YES;
                [SVProgressHUD showErrorWithStatus:@"点歌失败"];
            }

            
        }];
    }
}

@end
