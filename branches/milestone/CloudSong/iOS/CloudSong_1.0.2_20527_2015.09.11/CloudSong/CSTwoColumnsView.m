//
//  CSTwoColumnsView.m
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSTwoColumnsView.h"
#import "CSDefine.h"
#import "CSDistrictLeftCell.h"
#import "CSDistrictItem.h"
#import <Masonry.h>
#import "CSUtil.h"
#import "CSDistrictRightCell.h"

// columnsData 的数据格式
/*
 columnsData = (
 {
 category0 : (
 item0,
 item1,
 ...
 )
 },
 {
 category1 : (
 item0,
 item1,
 ...
 )
 }
 ...
 )
 */

//static NSString *kLeftCellIdentifier = @"CSDistrictLeftCell";
//static NSString *kRightCellIdentifier = @"CSDistrictRightCell";
//
//@interface CSTwoColumnsView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
//    UIView*        _container;
//    MASConstraint*  _containerTop;
//    UITableView*   _leftTableView;
//    UITableView*   _rightTableView;
//    NSInteger               _selectedLeftIndex;
//    NSInteger               _selectedRightIndex;
//    NSMutableArray*         _columnsData;
//    CGPoint         _initialPanPoint;
//}
//@end
//
//@implementation CSTwoColumnsView
//
//#pragma mark - Life Cycle
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        _columnsData = [NSMutableArray array];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        tap.delegate = self;
//        [self addGestureRecognizer:tap];
//        [self setupSubviews];
//    }
//    return self;
//}
//
//#pragma mark - Public Methods
//
//- (void)setData:(NSArray *)data {
//    _selectedLeftIndex = 0;
//    _selectedRightIndex = 1;
//    [_columnsData removeAllObjects];
//
//    for (CSDistrictItem *item in data) {
//        NSDictionary *dict = @{item.district:item.circleName};
//        [_columnsData addObject:dict];
//    }
//
//    [_columnsData insertObject:@{@"全城":@[@"全城"]} atIndex:0];
//    [self reloadData];
//}
//
//- (void)reloadData {
//    [_leftTableView reloadData];
//    [_rightTableView reloadData];
//}
//
//- (void)resetPosition {
//    _containerTop.offset = 0;
//}
//
//- (NSString *)defaultDistrictInCity:(NSString *)city {
//    NSString *result;
//    if (_columnsData.count > 0) {
//        NSDictionary *dict = _columnsData[1];
//        if ([dict allKeys].count > 1) {
//            result = dict[[dict allKeys][1]][0];
//        }
//    }
//    return result;
//}
//
//#pragma mark - Private Methods
//
//- (void)setupSubviews {
//    _container = [[UIView alloc] init];
//    [self addSubview:_container];
//    _container.backgroundColor = [UIColor clearColor];
//    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_container.superview);
//        _containerTop = make.top;
//    }];
//
//    // 左边的TableView
//    _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    [_container addSubview:_leftTableView];
//    _leftTableView.dataSource = self;
//    _leftTableView.delegate = self;
//    _leftTableView.backgroundColor = HEX_COLOR(0x3c2456);
//    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [CSUtil hideEmptySeparatorForTableView:_leftTableView];
//    [_leftTableView registerClass:[CSDistrictLeftCell class] forCellReuseIdentifier:kLeftCellIdentifier];
//    [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(_leftTableView.superview);
//        make.width.equalTo(_leftTableView.superview).multipliedBy(133.0/320);
//        make.height.mas_equalTo(TRANSFER_SIZE(296));
//    }];
//
//    // 右边的TableView
//    _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    [_container addSubview:_rightTableView];
//    _rightTableView.dataSource = self;
//    _rightTableView.delegate = self;
//    _rightTableView.backgroundColor = HEX_COLOR(0x2c1746);
//    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [CSUtil hideEmptySeparatorForTableView:_rightTableView];
//    [_rightTableView registerClass:[CSDistrictRightCell class] forCellReuseIdentifier:kRightCellIdentifier];
//    [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_leftTableView.mas_right);
//        make.right.equalTo(_rightTableView.superview);
//        make.top.equalTo(_rightTableView.superview);
//        make.height.mas_equalTo(TRANSFER_SIZE(296));
//    }];
//
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
//    [_container addSubview:bottomView];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    pan.delegate = self;
//    [bottomView addGestureRecognizer:pan];
//    bottomView.backgroundColor = HEX_COLOR(0x341f49);
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(bottomView.superview);
//        make.top.equalTo(_rightTableView.mas_bottom);
//        make.height.mas_equalTo(TRANSFER_SIZE(20));
//    }];
//
//    // 横向分隔线
//    UIImageView *sep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_on"]];
//    [bottomView addSubview:sep];
//    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(sep.superview);
//        make.top.equalTo(bottomView);
//        make.height.mas_equalTo(1);
//    }];
//
//    // 两条横杠
//    UIImageView *lineTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_on"]];
//    [bottomView addSubview:lineTop];
//    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(20, 1));
//        make.centerX.equalTo(lineTop.superview);
//        make.top.equalTo(lineTop.superview).offset(TRANSFER_SIZE(7));
//    }];
//    UIImageView *lineBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_durn"]];
//    [bottomView addSubview:lineBottom];
//    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(20, 1));
//        make.centerX.equalTo(lineBottom.superview);
//        make.bottom.equalTo(lineBottom.superview.mas_bottom).offset(TRANSFER_SIZE(-7));
//    }];
//}
//
//#pragma mark - Action Methods
//
//- (void)handleTap:(UITapGestureRecognizer *)tap {
//    if ([self.delegate respondsToSelector:@selector(twoColumnsViewDidHide:)]) {
//        [self.delegate twoColumnsViewDidHide:self];
//    }
//}
//
//- (void)handlePan:(UIPanGestureRecognizer *)pan {
//    CGPoint location = [pan locationInView:self];
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        _initialPanPoint = location;
//    }
//    else if (pan.state == UIGestureRecognizerStateChanged) {
//        _containerTop.offset = MIN(0, location.y - _initialPanPoint.y);
//    }
//    else if (pan.state == UIGestureRecognizerStateEnded) {
//        if (location.y - _initialPanPoint.y > -_leftTableView.height/2)
//            _containerTop.offset = 0;
//        else {
//            _containerTop.offset = -_leftTableView.height;
//            if ([self.delegate respondsToSelector:@selector(twoColumnsViewDidClose:)])
//                [self.delegate twoColumnsViewDidClose:self];
//        }
//    }
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSInteger result = 0;
//    if (tableView == _leftTableView) {
//        result = _columnsData.count;
//    }
//    else if (tableView == _rightTableView) {
//        if (_columnsData.count > 0) {
//            NSDictionary *itemsDict = _columnsData[_selectedLeftIndex];
//            NSArray *items = [itemsDict objectForKey:[itemsDict allKeys][0]];
//            result = items.count;
//        }
//    }
//    return result;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == _leftTableView) {
//        CSDistrictLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftCellIdentifier];
//        [cell setTitle:[_columnsData[indexPath.row] allKeys][0]];
//        cell.backgroundColor= [UIColor clearColor];
//        return cell;
//    }
//    else if (tableView == _rightTableView) {
//        CSDistrictRightCell *cell = [tableView dequeueReusableCellWithIdentifier:kRightCellIdentifier];
//        NSDictionary *dict = _columnsData[_selectedLeftIndex];
//        NSArray *items = [dict objectForKey:[dict allKeys][0]];
//        [cell setTitle:items[indexPath.row]];
//        [cell setSelectedStated:_selectedRightIndex == indexPath.row];
//        cell.backgroundColor= [UIColor clearColor];
//        return cell;
//    }
//    return nil;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == _leftTableView) {
//        [cell setSelected:indexPath.row == _selectedLeftIndex];
////        if (indexPath.row == 0) {
////            cell.selectionStyle = UITableViewCellSelectionStyleNone;
////        }
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (tableView == _leftTableView) {
//            _selectedLeftIndex = indexPath.row;
//            _selectedRightIndex = -1;
//            // 左侧的tableView reload是为了更新cell的选中状态
//            [_leftTableView reloadData];
//            [_rightTableView reloadData];
//        }
//    else if (tableView == _rightTableView) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            NSDictionary *dict = _columnsData[_selectedLeftIndex];
//            NSArray *items = [dict objectForKey:[dict allKeys][0]];
////            if (indexPath.row == 0) {
//                _businessDistrict = [dict allKeys][0];
////                if ([[dict allKeys][0] isEqualToString:@"全称"]) {
////                    _businessDistrict = @"全区";
////                }else{
////                    _businessDistrict = [dict allKeys][0];
////                }
////            }else{
//                _businessDistrict = items[indexPath.row];
////            }
//            _selectedRightIndex = indexPath.row;
//
//
//        if ([self.delegate respondsToSelector:@selector(twoColumnsView:businessDistrict:)]) {
//            [self.delegate twoColumnsView:self businessDistrict:_businessDistrict];
//        }
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return TRANSFER_SIZE(38);
//}
//
//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    CGPoint point = [gestureRecognizer locationInView:self];
//    return !CGRectContainsPoint(_leftTableView.frame, point) && !CGRectContainsPoint(_rightTableView.frame, point);
//}


static NSString *kLeftCellIdentifier = @"CSDistrictLeftCell";
static NSString *kRightCellIdentifier = @"CSDistrictRightCell";

@interface CSTwoColumnsView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    UIView*        _container;
    MASConstraint*  _containerTop;
    UITableView*   _leftTableView;
    UITableView*   _rightTableView;
    NSInteger               _selectedLeftIndex;
    NSInteger               _selectedRightIndex;
    NSMutableArray*         _columnsData;
    CGPoint         _initialPanPoint;
}
@end

@implementation CSTwoColumnsView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _columnsData = [NSMutableArray array];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setData:(NSArray *)data {
    _selectedLeftIndex = 0;
    //    _selectedRightIndex = 1;
    _selectedRightIndex = 0;//默认显示第一行  +
    [_columnsData removeAllObjects];
    
    for (CSDistrictItem *item in data) {
        NSDictionary *dict = @{item.district:item.circleName};
        [_columnsData addObject:dict];
    }
    
    [_columnsData insertObject:@{@"全城":@[@"全城"]} atIndex:0];
    [self reloadData];
}

- (void)reloadData {
    [_leftTableView reloadData];
    [_rightTableView reloadData];
}

- (void)resetPosition {
    _containerTop.offset = 0;
}

- (NSString *)defaultDistrictInCity:(NSString *)city {
    NSString *result;
    if (_columnsData.count > 0) {
        NSDictionary *dict = _columnsData[1];
        if ([dict allKeys].count > 1) {
            result = dict[[dict allKeys][1]][0];
        }else{
            result = @"全城";
        }
    }
    return result;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    _container = [[UIView alloc] init];
    [self addSubview:_container];
    _container.backgroundColor = [UIColor clearColor];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_container.superview);
        _containerTop = make.top;
    }];
    
    // 左边的TableView
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_container addSubview:_leftTableView];
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.backgroundColor = HEX_COLOR(0x3c2456);
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [CSUtil hideEmptySeparatorForTableView:_leftTableView];
    [_leftTableView registerClass:[CSDistrictLeftCell class] forCellReuseIdentifier:kLeftCellIdentifier];
    [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_leftTableView.superview);
        make.width.equalTo(_leftTableView.superview).multipliedBy(133.0/320);
        make.height.mas_equalTo(TRANSFER_SIZE(296));
    }];
    
    // 右边的TableView
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_container addSubview:_rightTableView];
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    //    _selectedRightIndex = 0;////////////////////////////////////////////////////
    _rightTableView.backgroundColor = HEX_COLOR(0x2c1746);
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [CSUtil hideEmptySeparatorForTableView:_rightTableView];
    [_rightTableView registerClass:[CSDistrictRightCell class] forCellReuseIdentifier:kRightCellIdentifier];
    [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTableView.mas_right);
        make.right.equalTo(_rightTableView.superview);
        make.top.equalTo(_rightTableView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(296));
    }];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    [_container addSubview:bottomView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    [bottomView addGestureRecognizer:pan];
    bottomView.backgroundColor = HEX_COLOR(0x341f49);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView.superview);
        make.top.equalTo(_rightTableView.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(20));
    }];
    
    // 横向分隔线
    UIImageView *sep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_on"]];
    [bottomView addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sep.superview);
        make.top.equalTo(bottomView);
        make.height.mas_equalTo(1);
    }];
    
    // 两条横杠
    UIImageView *lineTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_on"]];
    [bottomView addSubview:lineTop];
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 1));
        make.centerX.equalTo(lineTop.superview);
        make.top.equalTo(lineTop.superview).offset(TRANSFER_SIZE(7));
    }];
    UIImageView *lineBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_durn"]];
    [bottomView addSubview:lineBottom];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 1));
        make.centerX.equalTo(lineBottom.superview);
        make.bottom.equalTo(lineBottom.superview.mas_bottom).offset(TRANSFER_SIZE(-7));
    }];
}

#pragma mark - Action Methods

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(twoColumnsViewDidHide:)]) {
        [self.delegate twoColumnsViewDidHide:self];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint location = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _initialPanPoint = location;
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        _containerTop.offset = MIN(0, location.y - _initialPanPoint.y);
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        if (location.y - _initialPanPoint.y > -_leftTableView.height/2)
            _containerTop.offset = 0;
        else {
            _containerTop.offset = -_leftTableView.height;
            if ([self.delegate respondsToSelector:@selector(twoColumnsViewDidClose:)])
                [self.delegate twoColumnsViewDidClose:self];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = 0;
    if (tableView == _leftTableView) {
        result = _columnsData.count;
    }
    else if (tableView == _rightTableView) {
        if (_columnsData.count > 0) {
            NSDictionary *itemsDict = _columnsData[_selectedLeftIndex];
            NSArray *items = [itemsDict objectForKey:[itemsDict allKeys][0]];
            result = items.count;
        }
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        CSDistrictLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftCellIdentifier];
        [cell setTitle:[_columnsData[indexPath.row] allKeys][0]];
        cell.backgroundColor= [UIColor clearColor];
        return cell;
    }
    else if (tableView == _rightTableView) {
        CSDistrictRightCell *cell = [tableView dequeueReusableCellWithIdentifier:kRightCellIdentifier];
        NSDictionary *dict = _columnsData[_selectedLeftIndex];
        NSArray *items = [dict objectForKey:[dict allKeys][0]];
        [cell setTitle:items[indexPath.row]];
        [cell setSelectedStated:_selectedRightIndex == indexPath.row];
        cell.backgroundColor= [UIColor clearColor];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        [cell setSelected:indexPath.row == _selectedLeftIndex];
        //        if (indexPath.row == 0) {
        //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _leftTableView) {
        _selectedLeftIndex = indexPath.row;
        //一下四行修改
        _selectedRightIndex = -1;
        if (indexPath.row == 0) {
            _selectedRightIndex = 0;//默认显示第一行
        }
        // 左侧的tableView reload是为了更新cell的选中状态
        //        [_leftTableView reloadData];
        //        [_rightTableView reloadData];
        [self reloadData];
    }
    else if (tableView == _rightTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary *dict = _columnsData[_selectedLeftIndex];
        NSArray *items = [dict objectForKey:[dict allKeys][0]];
        if (indexPath.row == 0) {
            _businessDistrict = [dict allKeys][0];
            //                if ([[dict allKeys][0] isEqualToString:@"全称"]) {
            //                    _businessDistrict = @"全区";
            //                }else{
            //                    _businessDistrict = [dict allKeys][0];
            //                }
        }else{
            _businessDistrict = items[indexPath.row];
        }
        _selectedRightIndex = indexPath.row;
        
        
        if ([self.delegate respondsToSelector:@selector(twoColumnsView:businessDistrict:)]) {
            [self.delegate twoColumnsView:self businessDistrict:_businessDistrict];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANSFER_SIZE(38);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    return !CGRectContainsPoint(_leftTableView.frame, point) && !CGRectContainsPoint(_rightTableView.frame, point);
}

@end
