//
//  CSSelectedSongController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ;. All rights reserved.
//

#import "CSSelectedSongController.h"
#import <UIKit/UIKit.h>
#import "CSDataService.h"
#import "CSExpandSongCell.h"
#import "CSDefine.h"
#import "CSRoomSongData.h"
#import "CSUtil.h"
#import "CSRequest.h"
#import "CSRemoteControlHttpTool.h"
#import "SVProgressHUD.h"
#import "CSSong.h"

static NSString *identifier = @"CSExpandSongCell";

@interface CSSelectedSongController () <UITableViewDataSource, UITableViewDelegate>{
    UITableView*    _tableView;
    NSArray*        _songs;
    NSInteger       _selectedRow;
}
@end

@implementation CSSelectedSongController
@synthesize tableView;

#pragma mark - Public Methods 

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = HEX_COLOR(0x1c1c20);
        _tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[CSExpandSongCell class] forCellReuseIdentifier:identifier];
        [CSUtil hideEmptySeparatorForTableView:_tableView];
    }
    return _tableView;
}

- (void)refreshData {
    _selectedRow = -1;
    [[CSDataService sharedInstance] asyncGetSongsInRoomWithType:0 startIndex:0 handler:^(NSArray *songs) {
        _songs = songs;
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSExpandSongCell *cell = [theTableView dequeueReusableCellWithIdentifier:identifier];
    [cell setDataWithSong:[(CSRoomSongData *)_songs[indexPath.row] song]];
    cell.roomSong =_songs[indexPath.row];
    [cell.arrowBut addTarget:self action:@selector(publicMethod:) forControlEvents:UIControlEventTouchDown];
    cell.arrowBut.tag = 100 +indexPath.row;
    if (indexPath.row == 0)
        [cell setState:NO];
    else
        [cell setState:YES];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANSFER_SIZE(70);

//    return indexPath.row == _selectedRow ? TRANSFER_SIZE(125) : TRANSFER_SIZE(70);
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedRow == indexPath.row)
        _selectedRow = -1;
    else
        _selectedRow = indexPath.row;
    [theTableView reloadData];
}

-(void)publicMethod:(UIButton *)button{
    if (button.tag==100) {
        [self nextSongBtnPressed];
    }else{
        
        [self frontSong:_songs[button.tag-100]];
    }
        
    
}
//切歌
-(void)nextSongBtnPressed{
    CSRequest *param = [[CSRequest alloc] init];
    param.controlType = @101;
    [CSRemoteControlHttpTool remoteControlWithParam:param success:^(CSBaseResponseModel *result)
     {
         if (result.code == ResponseStateSuccess) {
             [SVProgressHUD showSuccessWithStatus:@"切歌成功"];
             [self refreshData];
         }else
         {
             [SVProgressHUD showErrorWithStatus:result.message];
         }
     } failure:^(NSError *error) {
         CSLog(@"%@",error);
         [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];

     }];
    
}

//置顶
- (void)frontSong:(CSSong *)song {
    
    [[CSDataService sharedInstance]asyncGetFrontSong:song handler:^(BOOL success) {
        if (success) {
            [self refreshData];
        }
    }];
    
}
#pragma mark


@end
