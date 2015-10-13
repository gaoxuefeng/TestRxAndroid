//
//  CSSongSelectPlatformView.m
//  CloudSong
//
//  Created by youmingtaizi on 7/9/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSongSelectPlatformView.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "CSVODButton.h"
#import "CSUtil.h"

@interface CSSongSelectPlatformView () <UISearchBarDelegate>{
    UITableView*    _tableView;
}
@end

@implementation CSSongSelectPlatformView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HEX_COLOR(0x1c1c20);
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (UITableView *)tableView {
    return _tableView;
}

- (void)reloadData {
    [_tableView reloadData];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    // Search Bar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [self addSubview:searchBar];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索歌星或歌曲";
    [searchBar setBackgroundImage:[UIImage imageNamed:@"schedule_search_bg_1"]];
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"schedule_search_bg_2"]
                                     forState:UIControlStateNormal];

    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(searchBar.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(52));
    }];
    
    // TODO 数据获取
    // 歌星 button
    CSVODButton *singerBtn = [CSVODButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:singerBtn];
    [singerBtn addTarget:self action:@selector(singBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [singerBtn setTitle:@"歌星" image:[UIImage imageNamed:@"song_singer"]];
    [singerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(singerBtn.superview);
        make.top.equalTo(searchBar.mas_bottom).offset(TRANSFER_SIZE(4));
        make.width.equalTo(self).multipliedBy(1.0/5);
        make.height.mas_equalTo(TRANSFER_SIZE(TRANSFER_SIZE(47)));
    }];
    
    // 语种 button
    CSVODButton *languageBtn = [CSVODButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:languageBtn];
    [languageBtn addTarget:self action:@selector(languageBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [languageBtn setTitle:@"语种" image:[UIImage imageNamed:@"song_language"]];
    [languageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(singerBtn.mas_right);
        make.top.equalTo(searchBar.mas_bottom).offset(TRANSFER_SIZE(4));
        make.width.equalTo(self).multipliedBy(1.0/5);
        make.height.mas_equalTo(TRANSFER_SIZE(TRANSFER_SIZE(47)));
    }];

    // 分类 button
    CSVODButton *categoryBtn = [CSVODButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:categoryBtn];
    [categoryBtn addTarget:self action:@selector(categoryBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn setTitle:@"分类" image:[UIImage imageNamed:@"song_classification"]];
    [categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(languageBtn.mas_right);
        make.top.equalTo(searchBar.mas_bottom).offset(TRANSFER_SIZE(4));
        make.width.equalTo(self).multipliedBy(1.0/5);
        make.height.mas_equalTo(TRANSFER_SIZE(TRANSFER_SIZE(47)));
    }];

    // 新歌 button
    CSVODButton *newSongBtn = [CSVODButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:newSongBtn];
    [newSongBtn addTarget:self action:@selector(newSongBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [newSongBtn setTitle:@"新歌" image:[UIImage imageNamed:@"song_new"]];
    [newSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(categoryBtn.mas_right);
        make.top.equalTo(searchBar.mas_bottom).offset(TRANSFER_SIZE(4));
        make.width.equalTo(self).multipliedBy(1.0/5);
        make.height.mas_equalTo(TRANSFER_SIZE(TRANSFER_SIZE(47)));
    }];

    // 热榜 button
    CSVODButton *hotListBtn = [CSVODButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:hotListBtn];
    [hotListBtn addTarget:self action:@selector(hotListBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [hotListBtn setTitle:@"热榜" image:[UIImage imageNamed:@"song_hot"]];
    [hotListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newSongBtn.mas_right);
        make.top.equalTo(searchBar.mas_bottom).offset(TRANSFER_SIZE(4));
        make.width.equalTo(self).multipliedBy(1.0/5);
        make.height.mas_equalTo(TRANSFER_SIZE(TRANSFER_SIZE(47)));
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.backgroundColor = HEX_COLOR(0x1c1c20);
    _tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    [CSUtil hideEmptySeparatorForTableView:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_tableView.superview);
        make.top.equalTo(searchBar.mas_bottom).offset(TRANSFER_SIZE(68));
    }];

    // 横向分割线
    UIImageView *sep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_on"]];
    [self addSubview:sep];
    sep.alpha = .55;
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sep.superview);
        make.top.equalTo(_tableView);
        make.height.mas_equalTo(TRANSFER_SIZE(1));
    }];
}

#pragma mark - Action Methods

- (void)singBtnPressed {
    if ([self.delegate respondsToSelector:@selector(songSelectPlatformViewDidPressSingerButton:)]) {
        [self.delegate songSelectPlatformViewDidPressSingerButton:self];
    }
}

- (void)languageBtnPressed {
    if ([self.delegate respondsToSelector:@selector(songSelectPlatformViewDidPressLanguageButton:)]) {
        [self.delegate songSelectPlatformViewDidPressLanguageButton:self];
    }
}

- (void)categoryBtnPressed {
    if ([self.delegate respondsToSelector:@selector(songSelectPlatformViewDidPressCategoryButton:)]) {
        [self.delegate songSelectPlatformViewDidPressCategoryButton:self];
    }
}

- (void)newSongBtnPressed {
    if ([self.delegate respondsToSelector:@selector(songSelectPlatformViewDidPressNewSongButton:)]) {
        [self.delegate songSelectPlatformViewDidPressNewSongButton:self];
    }
}

- (void)hotListBtnPressed {
    if ([self.delegate respondsToSelector:@selector(songSelectPlatformViewDidPressHotListButton:)]) {
        [self.delegate songSelectPlatformViewDidPressHotListButton:self];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if ([self.delegate respondsToSelector:@selector(songSelectPlatformViewDidBeginSearch:)])
        [self.delegate songSelectPlatformViewDidBeginSearch:self];
    return NO;
}

@end
