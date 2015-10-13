//
//  CSDistrictLeftCell.m
//  CloudSong
//
//  Created by youmingtaizi on 5/21/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDistrictLeftCell.h"
#import "CSDefine.h"

@implementation CSDistrictLeftCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = HEX_COLOR(0x9799a1);
        self.textLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
//        self.backgroundColor = HEX_COLOR(0x151417);
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [HEX_COLOR(0x2c1746) colorWithAlphaComponent:.8];
        self.selectedBackgroundView = bgView;
    }
    return self;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title {
    self.textLabel.text = title;
}

@end
