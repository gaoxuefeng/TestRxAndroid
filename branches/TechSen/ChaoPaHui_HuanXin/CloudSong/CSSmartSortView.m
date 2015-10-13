//
//  CSSmartSortView.m
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSmartSortView.h"
#import "CSDefine.h"
#import "CSUtil.h"
#import "CSSmartSortCell.h"
#import <Masonry.h>

@interface CSSmartSortView ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    UIView*         _container;
    MASConstraint*  _containerTop;
    UITableView*    _tableView;
    NSInteger       _selectedIndex;
    CGPoint         _initialPanPoint;
}
@end

static NSString *identifier = @"SmartSortCell";

@implementation CSSmartSortView

#pragma mark _ Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)reloadData {
    [_tableView reloadData];
}

- (void)resetPosition {
    _containerTop.offset = 0;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    _container = [[UIView alloc] init];
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_container.superview);
        _containerTop = make.top;
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_container addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[CSSmartSortCell class] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = HEX_COLOR(0x2c1746);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_tableView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(152));
    }];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    [_container addSubview:bottomView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [bottomView addGestureRecognizer:pan];
    bottomView.backgroundColor = HEX_COLOR(0x341f49);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView.superview);
        make.top.equalTo(_tableView.mas_bottom);
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
    if ([self.delegate respondsToSelector:@selector(smartSortViewDidHide:)]) {
        [self.delegate smartSortViewDidHide:self];
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
        if (location.y - _initialPanPoint.y > -_tableView.height/2)
            _containerTop.offset = 0;
        else {
            _containerTop.offset = -_tableView.height;
            if ([self.delegate respondsToSelector:@selector(smartSortViewDidHide:)])
                [self.delegate smartSortViewDidHide:self];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSSmartSortCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setTitle:self.data[indexPath.row]];
    [cell setSelectedStated:_selectedIndex == indexPath.row];
    cell.backgroundColor =[UIColor clearColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            _type = CSSmartSortViewTypeSmartSort;
            break;
        case 1:
            _type = CSSmartSortViewTypeNearest;
            break;
        case 2:
            _type = CSSmartSortViewTypeHottest;
            break;
        case 3:
            _type = CSSmartSortViewTypeCheapest;
            break;
            
        default:
            break;
    }
    _selectedIndex = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(smartSortView:didSelectType:)]) {
        [self.delegate smartSortView:self didSelectType:_type];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANSFER_SIZE(38);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:_tableView.superview];
    return !CGRectContainsPoint(_tableView.frame, point);
}

@end
