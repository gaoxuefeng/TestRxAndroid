//
//  CSAvailableRoomsCell.m
//  CloudSong
//
//  Created by youmingtaizi on 7/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSAvailableRoomsCell.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "CSKTVRoomItem.h"

@interface CSAvailableRoomsCell () {
    UILabel*    _roomLabel;
    UILabel*    _personCountLabel;
    UILabel*    _priceLabel;
    UIButton*   _bookBtn;
    CSKTVRoomItem*  _roomItem;
}
@end

@implementation CSAvailableRoomsCell

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}
#pragma mark - Public Methods

- (void)setDataWithRoomItem:(CSKTVRoomItem *)item {
    _roomItem = item;
    _roomLabel.text = item.boxTypeName;
    //添加---
    NSRange rangeLoc = [item.boxTypeChoice rangeOfString:@"("];
    NSRange rangeEnd = [item.boxTypeChoice rangeOfString:@")"];
    if (rangeLoc.location != NSNotFound) {
        NSInteger loc = rangeLoc.location;
        NSInteger len = rangeEnd.location - rangeLoc.location;
        NSString * str = [NSString stringWithFormat:@"适合%@",[[item.boxTypeChoice substringWithRange:NSMakeRange(loc+1, len-1)] length]>0?[item.boxTypeChoice substringWithRange:NSMakeRange(loc+1, len-1)]:@"未知"];
        _personCountLabel.text = str;
    }
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", item.price];
    
    if (item.boxTypeState) {
        [_bookBtn setBackgroundColor:HEX_COLOR(0x98356d)];
        _bookBtn.enabled = YES;
        
    }else{
        [_bookBtn setBackgroundColor:[UIColor grayColor]];
        _bookBtn.enabled = NO;
    }
}
#pragma mark - Private Metthods

- (void)setupSubviews {
    self.backgroundColor = HEX_COLOR(0x1f1f1f);
    _roomLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_roomLabel];
    _roomLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(17)];
    _roomLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_roomLabel.superview).offset(TRANSFER_SIZE(20));
        make.width.mas_lessThanOrEqualTo(TRANSFER_SIZE(100));//将包间的类型名设为定长，超过限制就省略
        make.bottom.equalTo(_roomLabel.superview.mas_centerY).offset(TRANSFER_SIZE(2.0));//添加--
    }];
    //添加---
    _personCountLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_personCountLabel];
    _personCountLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11)];
    _personCountLabel.textColor = [HEX_COLOR(0xffffff)colorWithAlphaComponent:.5];
    [_personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_roomLabel.superview).offset(TRANSFER_SIZE(20));
        make.width.mas_lessThanOrEqualTo(TRANSFER_SIZE(100));
        make.top.equalTo(_personCountLabel.superview.mas_centerY).offset(TRANSFER_SIZE(4.0));
    }];
    
    _priceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_priceLabel];
    _priceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _priceLabel.textColor = HEX_COLOR(0xff00ab);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_priceLabel.superview);
        make.centerY.equalTo(_priceLabel.superview);
        make.top.bottom.equalTo(_priceLabel.superview);
    }];
    
    UIButton *bookingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contentView addSubview:bookingBtn];
    bookingBtn.layer.cornerRadius = 4;
    bookingBtn.layer.masksToBounds = YES;
    [bookingBtn setBackgroundColor:HEX_COLOR(0x98356d)];
    [bookingBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.8] forState:UIControlStateNormal];
    [bookingBtn setTitle:@"预订" forState:UIControlStateNormal];
    bookingBtn.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    [bookingBtn addTarget:self action:@selector(bookingBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [bookingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bookingBtn.superview).offset(TRANSFER_SIZE(-20));
        make.centerY.equalTo(bookingBtn.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(43), TRANSFER_SIZE(29)));
    }];
    _bookBtn = bookingBtn;
}

#pragma mark - Action Methods

- (void)bookingBtnPressed {
    if ([self.delegate respondsToSelector:@selector(availableRoomsCell:didBookingRoomItem:)])
        [self.delegate availableRoomsCell:self didBookingRoomItem:_roomItem];
}

@end
