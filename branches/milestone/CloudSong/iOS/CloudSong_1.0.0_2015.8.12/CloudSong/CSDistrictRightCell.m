//
//  CSDistrictRightCell.m
//  CloudSong
//
//  Created by youmingtaizi on 7/7/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDistrictRightCell.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSDistrictRightCell () {
    UIImageView*    _sep;
}
@end

@implementation CSDistrictRightCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [HEX_COLOR(0x9799a1) colorWithAlphaComponent:.8];
        self.textLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
        self.backgroundColor = HEX_COLOR(0x1c1c20);
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [HEX_COLOR(0x1c1c20) colorWithAlphaComponent:.8];
        self.selectedBackgroundView = bgView;
        _sep = [[UIImageView alloc] init];
        [self.contentView addSubview:_sep];
        [_sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sep.superview).offset(TRANSFER_SIZE(15));
            make.right.equalTo(_sep.superview);
            make.bottom.equalTo(_sep.superview);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setSelectedStated:(BOOL)selected {
    self.textLabel.textColor = selected ? HEX_COLOR(0xcd418f) : HEX_COLOR(0x9799a1);
    _sep.image = [UIImage imageNamed:selected ? @"schedule_line-1" : @"song_line_durn"];
}

- (void)setTitle:(NSString *)title {
    self.textLabel.text = title;
}

@end
