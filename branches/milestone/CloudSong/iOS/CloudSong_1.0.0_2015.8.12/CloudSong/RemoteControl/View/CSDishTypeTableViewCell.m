//
//  CSDishTypeTableViewCell.m
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDishTypeTableViewCell.h"
#import <Masonry.h>
#import "CSDefine.h"
@interface CSDishTypeTableViewCell ()
@end

@implementation CSDishTypeTableViewCell


#pragma mark - Public Methods
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier =  @"dishType";
    CSDishTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSDishTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor blackColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self setupTitleLabel];
    }
    return self;
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        _titleLabel.textColor = HEX_COLOR(0xf2f2f2);
        self.backgroundColor = HEX_COLOR(0x852660);
    }else
    {
        _titleLabel.textColor = HEX_COLOR(0x404148);
        self.backgroundColor = HEX_COLOR(0x000000);
    }
}
@end
