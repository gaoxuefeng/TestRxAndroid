//
//  CSMyRecordCell.m
//  CloudSong
//
//  Created by EThank on 15/7/22.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyRecordCell.h"
#import "CSDefine.h"
#import "CSMyRecordModel.h"
#import <Masonry.h>
#import "SGActionView.h"

#define SONG_NAME_LABEL_FONT [UIFont systemFontOfSize:17]
#define DATE_LABEL_FONT [UIFont systemFontOfSize:12]

#define CELL_BACK_COLOR [UIColor colorWithRed:22/255.0 green:21/255.0 blue:25/255.0 alpha:1]
#define Cell_BackView_Color [UIColor colorWithRed:194/255.0 green:34/255.0 blue:125/255.0 alpha:1]

@interface CSMyRecordCell ()

/** 歌曲名字 */
@property (nonatomic, weak) UILabel *songNameLabel ;
/** 日期 */
@property (nonatomic, weak) UILabel *dateLabel ;
/** 手表图标 */
@property (nonatomic, weak) UIImageView *watchImage ;
/** 时长 */
@property (nonatomic, weak) UILabel *durationLabel ;
/** 分享按钮 */
@property (nonatomic, weak) UIButton *shareBtn ;

@property (nonatomic, assign, getter=isSetupConstaint) BOOL setupConstraint ;

@end

@implementation CSMyRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
    }
    return self ;
}

- (void)setupSubViews{
    // 1. 歌曲名
    UILabel *songNameLabel = [[UILabel alloc] init] ;
    songNameLabel.text = @"一生中最爱" ;
    songNameLabel.font = SONG_NAME_LABEL_FONT ;
    songNameLabel.textColor = [UIColor whiteColor] ;
    songNameLabel.textAlignment = NSTextAlignmentCenter ;
    [self.contentView addSubview:songNameLabel] ;
    self.songNameLabel = songNameLabel ;
    
    // 2. 日期
    UILabel *dateLabel = [[UILabel alloc] init] ;
    dateLabel.text = @"07-15分" ;
    dateLabel.font = DATE_LABEL_FONT ;
    dateLabel.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4] ;

    dateLabel.textAlignment = NSTextAlignmentCenter ;
    [self.contentView addSubview:dateLabel] ;
    self.dateLabel = dateLabel ;
    
    // 3. 手表图标
    UIImageView *watchImage = [[UIImageView alloc] init] ;
    watchImage.image = [UIImage imageNamed:@"mine_time_icon"] ;
    [self.contentView addSubview:watchImage] ;
    self.watchImage = watchImage ;

    // 4. 时长
    UILabel *durationLabel = [[UILabel alloc] init] ;
    durationLabel.text = @"4分25秒" ;
    durationLabel.font = DATE_LABEL_FONT ;
    durationLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4] ;
    durationLabel.textAlignment = NSTextAlignmentLeft ;
    [self.contentView addSubview:durationLabel] ;
    self.durationLabel = durationLabel ;

    // 5. 分享
    UIButton *shareBtn = [[UIButton alloc] init] ;
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"mine_share_btn"] forState:UIControlStateNormal] ;
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside] ;
    [self.contentView addSubview:shareBtn] ;
    self.shareBtn = shareBtn ;

    [self updateConstraintsIfNeeded] ;
}

#pragma mark - 更新约束
- (void)updateConstraints{
    
    if (![self isSetupConstaint]) {
        
        WS(ws) ;
        // 1. 歌曲名布局
        [_songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(TRANSFER_SIZE(23)) ;
            make.top.equalTo(ws.contentView).offset(TRANSFER_SIZE(18)) ;
//            NSDictionary *attrs = @{NSFontAttributeName : SONG_NAME_LABEL_FONT} ;
//            CGSize songLabelSize = [_songNameLabel.text sizeWithAttributes:attrs] ;
//            make.size.mas_equalTo(songLabelSize) ;
        }] ;
        
        // 2. 日期布局
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(TRANSFER_SIZE(23)) ;
            make.top.mas_equalTo(_songNameLabel.mas_bottom).offset(TRANSFER_SIZE(10)) ;
        }] ;
        
        // 3. 手表图标
        [_watchImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateLabel.mas_right).offset(TRANSFER_SIZE(55)) ;
            make.top.mas_equalTo(_songNameLabel.mas_bottom).offset(TRANSFER_SIZE(10)) ;
            make.size.mas_equalTo(CGSizeMake(15, 15)) ;
        }] ;

        // 4. 时长布局
        [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_watchImage.mas_right).offset(TRANSFER_SIZE(5)) ;
            make.top.mas_equalTo(_songNameLabel.mas_bottom).offset(TRANSFER_SIZE(10)) ;
        }] ;

        // 5. 分享
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.contentView).offset(-TRANSFER_SIZE(20)) ;
            make.centerY.equalTo(ws.contentView) ;
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(42), TRANSFER_SIZE(21))) ;
        }] ;

        self.setupConstraint = YES ;
    }
    [super updateConstraints] ;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"myRecordCell";
    CSMyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSMyRecordCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [Cell_BackView_Color colorWithAlphaComponent:0.4] ;
        [cell setBackgroundColor:CELL_BACK_COLOR];
    }
    return cell;
}


- (void)setRecordModel:(CSMyRecordModel *)recordModel{
    _recordModel = recordModel ;
    self.songNameLabel.text = recordModel.musicName ;
    self.durationLabel.text = [NSString stringWithFormat:@"%d分%d秒", [recordModel.duration intValue] / 60, [recordModel.duration intValue] % 60] ;
    self.dateLabel.text = recordModel.recordTime ;
    
    // 设置完数据之后在更新约束（上面的label的size是动态计算的，更加label上的文字内容）
    [self updateConstraintsIfNeeded] ;

}

- (void)shareBtnClick
{
    NSArray *titleArray = @[@"微信", @"朋友圈", @"QQ", @"微博"] ;
    
    NSArray *images = @[[UIImage imageNamed:@"player_wechat_icon"],
                        [UIImage imageNamed:@"player_friends_icon"],
                        [UIImage imageNamed:@"player_qq_icon"],
                        [UIImage imageNamed:@"player_weibo_icon"],] ;
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:titleArray
                                 images:images
                         selectedHandle:^(NSInteger index) {
                             // 处理分享
                             [self handleShare:index] ;
                         }] ;
}

#pragma mark - 处理分享
- (void)handleShare:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(myRecordCell:didSelectShareBtnIndex:)]) {
        
        [self.delegate myRecordCell:self didSelectShareBtnIndex:index] ;
    }
}

@end
