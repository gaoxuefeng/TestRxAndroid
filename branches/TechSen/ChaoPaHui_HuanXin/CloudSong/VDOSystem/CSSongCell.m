//
//  CSSongCell.m
//  CloudSong
//
//  Created by youmingtaizi on 7/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSongCell.h"
#import "CSDefine.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "CSSong.h"
#import "CSSinger.h"

@interface CSSongCell () {
    UILabel*    _icon;
    UILabel*        _title;
    UILabel*        _subTitle;
    UIButton * _addSongBut;
    CSSong*         _song;
}
@end

@implementation CSSongCell

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Action Methods

- (void)addBtnPressed {
    if ([self.delegate respondsToSelector:@selector(songCell:didSelectSong:)]) {
        _addSongBut.enabled = _addSongBut.selected ? YES :NO;
        [self.delegate songCell:self didSelectSong:_song];
    }
}

#pragma mark - Public Methods

- (void)setDataWithSong:(CSSong *)song {
    _song = song;
    _title.text = song.songName;
    CSSinger *singer;
    if (song.singers.count > 0) {
        singer = song.singers[0];
        _subTitle.text = [NSString stringWithFormat:@"%@-%@", song.language, singer.singerName];
//        [_icon sd_setImageWithURL:[NSURL URLWithString:singer.singerImageUrl] placeholderImage:[UIImage imageNamed:@"find_default_img"]];
    }
    else {
        _subTitle.text = song.language;
//        _icon.image = [UIImage imageNamed:@"find_default_img"];
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // icon
    _icon = [[UILabel alloc] init];
    _icon.text=@"1";
    _icon.font=[UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    _icon.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.6];
    _icon.textAlignment =NSTextAlignmentCenter ;
    [self.contentView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_icon.superview);
        make.left.equalTo(_icon.superview).offset(TRANSFER_SIZE(10));
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(44), TRANSFER_SIZE(44)));
    }];

    // title
    _title = [[UILabel alloc] init];
    [self.contentView addSubview:_title];
    _title.font = [UIFont systemFontOfSize:TRANSFER_SIZE(16)];
    _title.textColor = [HEX_COLOR(0xffffff) colorWithAlphaComponent:1];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).offset(TRANSFER_SIZE(10));
        make.right.equalTo(_title.superview).offset(TRANSFER_SIZE(-75));
        make.top.equalTo(_title.superview).offset(TRANSFER_SIZE(12));
        make.height.mas_equalTo(TRANSFER_SIZE(16));
    }];

    // subtitle
    _subTitle = [[UILabel alloc] init];
    [self.contentView addSubview:_subTitle];
    _subTitle.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    _subTitle.textColor = [HEX_COLOR(0xffffff) colorWithAlphaComponent:.6];
    [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).offset(TRANSFER_SIZE(10));
        make.right.equalTo(_subTitle.superview).offset(TRANSFER_SIZE(-75));
        make.top.equalTo(_title.mas_bottom).offset(TRANSFER_SIZE(7));
        make.height.mas_equalTo(TRANSFER_SIZE(13));
    }];
    
    // addButton
    _addSongBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_addSongBut];
    [_addSongBut setImage:[UIImage imageNamed:@"song_selected_btn_normal"] forState:UIControlStateNormal];
    [_addSongBut setImage:[UIImage imageNamed:@"song_selected_btn_press"] forState:UIControlStateSelected];
    [_addSongBut addTarget:self action:@selector(addBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_addSongBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_addSongBut.superview).offset(TRANSFER_SIZE(-11));
        make.top.bottom.equalTo(_addSongBut.superview);
        make.width.mas_equalTo(TRANSFER_SIZE(62));
    }];

}

@end
