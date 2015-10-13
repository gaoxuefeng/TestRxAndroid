//
//  CSSingerHeaderView.m
//  CloudSong
//
//  Created by EThank on 15/6/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSingerHeaderView.h"
#import "CSHotSingersCollectionViewCell.h"
#import "CSDataService.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSSingerHeaderView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UICollectionView*   _hotSingerCollectionView;
}
@property (nonatomic, strong) NSArray *hotSingers ;
@end

@implementation CSSingerHeaderView

static NSString *identifier = @"CSHotSingersCollectionViewCell";

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        // 获取热门歌手数据
        [self asyncGetHotSingers];
    }
    return self;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void)setupSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    // 粉色竖线
    UIView *vSep = [[UIView alloc] init];
    [self addSubview:vSep];
    vSep.backgroundColor = HEX_COLOR(0x762652);
    [vSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vSep.superview).offset(TRANSFER_SIZE(20));
        make.top.equalTo(vSep.superview).offset(TRANSFER_SIZE(17));
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(1), TRANSFER_SIZE(12)));
    }];
    
    // 热门歌星推荐
    UILabel *hotSingersLabel = [[UILabel alloc] init];
    [self addSubview:hotSingersLabel];
    hotSingersLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    hotSingersLabel.textColor = [HEX_COLOR(0xffffff) colorWithAlphaComponent:.6];
    hotSingersLabel.text = @"热门歌星推荐";
    [hotSingersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vSep.mas_right).offset(TRANSFER_SIZE(7));
        make.right.equalTo(hotSingersLabel.superview);
        make.centerY.equalTo(vSep);
        make.height.mas_equalTo(TRANSFER_SIZE(13));
    }];
    
    // collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _hotSingerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:_hotSingerCollectionView];
    _hotSingerCollectionView.dataSource = self;
    _hotSingerCollectionView.delegate = self;
    [_hotSingerCollectionView registerClass:[CSHotSingersCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    _hotSingerCollectionView.backgroundColor = [UIColor clearColor];
    [_hotSingerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_hotSingerCollectionView.superview);
        CSLog(@"+++++++++%@",_hotSingerCollectionView.superview);
        make.top.equalTo(hotSingersLabel.mas_bottom);
        make.bottom.equalTo(_hotSingerCollectionView.superview);
    }];
}

#pragma mark - 获取collectionView上的热门歌手数据

- (void)asyncGetHotSingers {
    [[CSDataService sharedInstance] asyncGetHotSingersWithHandler:^(NSArray *singers) {
        _hotSingers = singers;
        [_hotSingerCollectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _hotSingers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSHotSingersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setDataWithSingerItem:_hotSingers[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(singerHeaderView:didSelectSinger:)]) {
        [self.delegate singerHeaderView:self didSelectSinger:_hotSingers[indexPath.row]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(TRANSFER_SIZE(15), 0, TRANSFER_SIZE(25), 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellW = SCREENWIDTH / 2.0;
    CGFloat cellH = TRANSFER_SIZE(35);
    return CGSizeMake(cellW, cellH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return TRANSFER_SIZE(15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
