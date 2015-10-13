//
//  CSCategoryCollectionViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/10/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSCategoryCollectionViewController.h"
#import "CSDataService.h"
#import <UIImageView+WebCache.h>
#import "CSSongCategoryItem.h"
#import "CSSongListTableViewController.h"
#import <MJExtension.h>
#import "CSSongCategoryCell.h"
#import "CSDefine.h"

@interface CSCategoryCollectionViewController () {
    NSMutableArray* _category;
}
@end

@implementation CSCategoryCollectionViewController

static NSString * const reuseIdentifier = @"CSSongCategoryCell";

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[CSSongCategoryCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = HEX_COLOR(0x1c1c20);
    _category = [NSMutableArray array];
    self.title = @"分类";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self asyncGetCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)asyncGetCategory {
    [[CSDataService sharedInstance] asyncGetSongCategoriesWithHandler:^(NSArray *songs) {
        [_category removeAllObjects];
        [_category addObjectsFromArray:songs];
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _category.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSSongCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setDataWithCategory:_category[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CSSongCategoryItem *item = _category[indexPath.row];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:1001];
    [imgView sd_setImageWithURL:[NSURL URLWithString:item.imageSrc]];
    UILabel *label = (UILabel *)[cell viewWithTag:1002];
    label.text = item.listTypeName;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    vc.type = CSSongListTableViewControllerTypeCategory;
    vc.categoryType = indexPath.row;
    CSSongCategoryItem *item = _category[indexPath.row];
    vc.title = item.listTypeName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(TRANSFER_SIZE(15), TRANSFER_SIZE(10), 0, TRANSFER_SIZE(10));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - TRANSFER_SIZE(40))/3, TRANSFER_SIZE(116));
}

@end
