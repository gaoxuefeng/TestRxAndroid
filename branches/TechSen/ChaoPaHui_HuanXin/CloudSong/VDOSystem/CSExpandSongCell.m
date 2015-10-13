//
//  CSExpandSongCell.m
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSExpandSongCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "CSSong.h"
#import "CSSinger.h"
#import "CSDefine.h"
#import "CSDataService.h"
#import "CSRequest.h"
#import "CSRemoteControlHttpTool.h"
#import "SVProgressHUD.h"

@interface CSExpandSongCell () {
    UIImageView*    _iconImageView;
    UILabel * _nickname;
    UILabel*        _titleLabel;
    UILabel*        _subtitleLabel;
//    UIView*         _buttonsContainer;
    CSSong*         _song;
}
@end

@implementation CSExpandSongCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setDataWithSong:(CSSong *)song {
    _song = song;
    _titleLabel.text = song.songName;

    NSMutableString *subtitle = [NSMutableString string];
    if (song.language.length > 0)
        [subtitle appendString:song.language];
    if (song.singers.count > 0) {
        CSSinger *singer = song.singers[0];
        [subtitle appendFormat:@"-%@", singer.singerName];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:singer.singerImageUrl] placeholderImage:[UIImage imageNamed:@"find_default_img"]];
    }
    _subtitleLabel.text = subtitle;
    
}
-(void)setRoomSong:(CSRoomSongData *)roomSong{
    _nickname.text =roomSong.userName;
}
- (void)setState:(BOOL)state{
    [_arrowBut setImage:[UIImage imageNamed:state ? @"song_toup_btn" : @"song_cut_btn"] forState:UIControlStateNormal];
    if (!state) {
        _songPlaying.hidden = NO;
        [_songPlaying startAnimating];//启动动画
    }
    else {
        _songPlaying.hidden = YES;
        [_songPlaying stopAnimating];//停止动画
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    // icon
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.layer.cornerRadius = TRANSFER_SIZE(4);
    _iconImageView.layer.masksToBounds = YES;
    [_iconImageView.layer setCornerRadius:TRANSFER_SIZE(31)/2];
    _iconImageView.image =[UIImage imageNamed:@"find_default_img"];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.superview).offset(TRANSFER_SIZE(15));
        make.top.equalTo(_iconImageView.superview).offset(TRANSFER_SIZE(8));
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(31), TRANSFER_SIZE(31)));
    }];
    
    //singer
    
    _nickname = [[UILabel alloc]init];
    [self.contentView addSubview:_nickname];
    _nickname.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11)];
    _nickname.textColor =[HEX_COLOR(0xffffff)colorWithAlphaComponent:.6];
//    _nickname.text=@"昵称";
    [_nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(10));
        make.top.equalTo(@(TRANSFER_SIZE(10)));
        make.height.mas_equalTo(TRANSFER_SIZE(11));
    }];
    
    // title
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
    _titleLabel.textColor = [HEX_COLOR(0xffffff)colorWithAlphaComponent:1];;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(10));
        make.right.equalTo(@(TRANSFER_SIZE(-82)));
        make.top.equalTo(_nickname.mas_bottom).offset(TRANSFER_SIZE(7));
        make.height.mas_equalTo(TRANSFER_SIZE(14));
    }];
    
    // subtitle
    _subtitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_subtitleLabel];
    _subtitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10)];
    _subtitleLabel.textColor = [HEX_COLOR(0xffffff) colorWithAlphaComponent:.6];
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(10));
        make.right.equalTo(@(TRANSFER_SIZE(-50)));
        make.top.equalTo(_titleLabel.mas_bottom).offset(TRANSFER_SIZE(7));
        make.height.mas_equalTo(TRANSFER_SIZE(10));
    }];

    
    //
    _arrowBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_arrowBut];
    [_arrowBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_arrowBut.superview).offset(TRANSFER_SIZE(-12));
        make.top.equalTo(_arrowBut.superview).offset(TRANSFER_SIZE(23));
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(43), TRANSFER_SIZE(23)));
    }];
    
    //


    _songPlaying = [[UIImageView alloc] init];
    NSMutableArray * imageArray=[NSMutableArray array];
    for (int i = 1; i<=15; i++) {
        UIImage * image=[UIImage imageNamed:[NSString stringWithFormat:@"playing_%03d",i]];
        [imageArray addObject:image];
    }
    _songPlaying.animationImages = imageArray;
    _songPlaying.animationDuration=.5;
    [_songPlaying startAnimating];//启动动画
    [self.contentView addSubview:_songPlaying];
//    _songPlaying.alpha=0;
    [_songPlaying mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(15), TRANSFER_SIZE(15)));
        make.right.equalTo(_arrowBut.mas_left).offset(TRANSFER_SIZE(-12));
        make.centerY.mas_equalTo(_arrowBut);
    }];
  /*  // 底部两个button的container
    _buttonsContainer = [[UIView alloc] init];
    [self.contentView addSubview:_buttonsContainer];
    _buttonsContainer.backgroundColor = HEX_COLOR(0x151417);
    [_buttonsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_buttonsContainer.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(44));
    }];
    
    
    // 删除 Button
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonsContainer addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteSongBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(deleteBtn.superview);
        make.width.equalTo(deleteBtn.superview).multipliedBy(.5);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_bin_icon"]];
    [deleteBtn addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.superview).offset(TRANSFER_SIZE(41));
        make.centerY.equalTo(imgView.superview);
    }];
    
    UILabel *delLabel = [[UILabel alloc] init];
    [deleteBtn addSubview:delLabel];
    delLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    delLabel.textColor = [HEX_COLOR(0x9799a1) colorWithAlphaComponent:.5];
    delLabel.text = @"删除歌曲";
    [delLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(delLabel.superview).offset(TRANSFER_SIZE(63));
        make.top.bottom.equalTo(delLabel.superview);
        make.width.mas_equalTo(65);
    }];
   
    // 置顶 Button
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonsContainer addSubview:topBtn];
    [topBtn addTarget:self action:@selector(frontSongBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deleteBtn.mas_right);
        make.bottom.equalTo(topBtn.superview);
        make.width.equalTo(topBtn.superview).multipliedBy(.5);
        make.height.mas_equalTo(TRANSFER_SIZE(44));
    }];
    
    imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_top_icon"]];
    [topBtn addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.superview).offset(TRANSFER_SIZE(41));
        make.centerY.equalTo(imgView.superview);
    }];
    
    UILabel *topLabel = [[UILabel alloc] init];
    [topBtn addSubview:topLabel];
    topLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    topLabel.textColor = [HEX_COLOR(0x9799a1) colorWithAlphaComponent:.5];
    topLabel.text = @"置顶歌曲";
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLabel.superview).offset(TRANSFER_SIZE(63));
        make.top.bottom.equalTo(topLabel.superview);
        make.width.mas_equalTo(65);
    }];*/
}

#pragma mark - Action Methods

- (void)deleteSongBtnPressed {
    [[CSDataService sharedInstance] asyncDeleteSelectedSongByRoomSongID:_song.roomSongId roomNum:GlobalObj.roomNum handler:^(NSArray *songs) {
        CSLog(@"%@", songs);
    }];
}




@end






