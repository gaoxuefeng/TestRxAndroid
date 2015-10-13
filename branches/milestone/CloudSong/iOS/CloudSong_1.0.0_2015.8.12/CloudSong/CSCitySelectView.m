//
//  CSCitySelectView.m
//  CloudSong
//
//  Created by youmingtaizi on 5/18/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSCitySelectView.h"
#import "CSDefine.h"
#import "CSUtil.h"
#import <Masonry.h>
#import "CSDataService.h"

@interface CSCitySelectView () <UISearchBarDelegate>{
    UISearchBar*    _searchBar;
    UITableView*   _tableView;
}

@property (nonatomic, weak) UIScrollView *searchResultView ; // 搜索结果view
@end

@implementation CSCitySelectView

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)reloadData {
    _tableView.dataSource = self.dataSource;
    _tableView.delegate = self.delegate;
    [_tableView reloadData];
}

- (void)hideKeyboard {
    [_searchBar resignFirstResponder];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.backgroundColor = HEX_COLOR(0x151417);
    // searchBar容器
    UIView* searchBarBgView = [[UIView alloc] initWithFrame:CGRectZero];
    searchBarBgView.backgroundColor = HEX_COLOR(0x1c1c20);
    [self addSubview:searchBarBgView];
    [searchBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(TRANSFER_SIZE(43));
    }];
    
    // 生成searchBar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.barTintColor = HEX_COLOR(0x1c1c20);
    _searchBar.placeholder = @"搜索城市或地点";
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = HEX_COLOR(0xb5b7bf);
    
    _searchBar.backgroundImage = [UIImage imageNamed:@"schedule_search_bg_1"];
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"schedule_search_bg_2"]
                                    forState:UIControlStateNormal];
    _searchBar.delegate = self;
    [searchBarBgView addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchBar.superview).offset(TRANSFER_SIZE(2));
        make.right.equalTo(_searchBar.superview).offset(TRANSFER_SIZE(-38));
        make.top.equalTo(_searchBar.superview);
        make.bottom.equalTo(_searchBar.superview);
    }];
    
    // 生成定位 button
    UIButton *locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locateButton setImage:[UIImage imageNamed:@"schedule_pin_icon"] forState:UIControlStateNormal];
    [locateButton addTarget:self action:@selector(locateBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [searchBarBgView addSubview:locateButton];
    [locateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchBarBgView);
        make.top.equalTo(searchBarBgView);
        make.bottom.equalTo(searchBarBgView);
        make.width.mas_equalTo(TRANSFER_SIZE(43));
    }];
    
    // 生成TableView
    WS(ws) ;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = HEX_COLOR(0x151417);
    _tableView.sectionIndexColor = [HEX_COLOR(0xff42ab) colorWithAlphaComponent:.4];
    _tableView.sectionIndexBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    _tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    
    [CSUtil hideEmptySeparatorForTableView:_tableView];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws);
        make.right.equalTo(ws);
        make.top.equalTo(searchBarBgView.mas_bottom);
        make.bottom.equalTo(ws).offset(-TRANSFER_SIZE(100));
    }];

}

// 显示搜索结果
- (void)showSearchResultWithCities:(NSArray *)cities{

    // 创建搜索结果视图
    UIScrollView *searchResultView = [[UIScrollView alloc] init] ;
    searchResultView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3] ;
    [self addSubview:searchResultView] ;
    self.searchResultView = searchResultView ;

    [searchResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(searchResultView.superview) ;
        make.top.equalTo(_searchBar.mas_bottom) ;
    }] ;
    
    UIView *containerView = [[UIView alloc] init] ;
    [searchResultView addSubview:containerView] ;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView.superview) ;
        make.width.equalTo(containerView.superview) ; // 垂直布局时设置width
    }] ;
    
    UIButton *lastButton = nil ;// 记录最新添加的button，以方便布局
    for (int i = 0; i < cities.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
        button.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)] ;
        button.backgroundColor = [HEX_COLOR(0x151417) colorWithAlphaComponent:0.5] ;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [button setTitle:cities[i] forState:UIControlStateNormal] ;
        [button addTarget:self action:@selector(searchRowClick:) forControlEvents:UIControlEventTouchUpInside] ;
        [containerView addSubview:button] ;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(button.superview) ;
            make.height.equalTo(@35) ;
            if (lastButton) {
                make.top.mas_equalTo(lastButton.mas_bottom) ;
            }else{
                make.top.mas_equalTo(containerView.mas_top) ;
            }
        }] ;
        lastButton = button ;
    }
    // 添加containerView的底线
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastButton.mas_bottom) ;
    }] ;

}

// 点击搜索结果列表行
- (void)searchRowClick:(UIButton *)sender{
    CSLog(@"sender title = %@", sender.currentTitle) ;
    [self resignFirstResponder] ;
    if ([self.searchDelegate respondsToSelector:@selector(citySelectViewWillSearchCity:)]) {
        [self.searchDelegate citySelectViewWillSearchCity:sender.currentTitle] ;
    }
    [self.searchResultView removeFromSuperview] ;
}

#pragma mark - Action Methods

- (void)locateBtnPressed {
    if ([self.locationDelegate respondsToSelector:@selector(citySelectViewDidPressLocationBtn:)]) {
        [self.locationDelegate citySelectViewDidPressLocationBtn:self];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil ;
}

// 搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    CSLog(@"searchText = %@", searchText) ;
    
    if (searchText != nil) {
        NSArray *matchingArr = [self searchCityByKeyword:searchText] ;
        if (matchingArr.count) {
            // 删除前一个
            [self.searchResultView removeFromSuperview] ;
            [self showSearchResultWithCities:matchingArr] ;
        }
    }
}

#pragma mark - 遍历匹配城市
- (NSArray *)searchCityByKeyword:(NSString *)keyword{

    NSMutableArray *matchingArray = [NSMutableArray array] ;
    
    NSDictionary *allCities = [[CSDataService sharedInstance] allCities] ;
    
    for (char c = 'A'; c < 'Z'; c++) {
       NSString *keyStr = [NSString stringWithFormat:@"%c", c] ;
        // 根据健值取出对应城市
        NSArray *cityArray = [allCities objectForKey:keyStr] ;
        // 遍历该关键字对应的城市列表
        for (NSString *cityName in cityArray) {
            // [cityName containsString:keyword] iOS 8.0之后才可用
            NSRange isContain = [cityName rangeOfString:keyword] ;
            if (isContain.location != NSNotFound) {
                [matchingArray addObject:cityName] ;
            }
        }
    }
    return matchingArray ;
}

@end
