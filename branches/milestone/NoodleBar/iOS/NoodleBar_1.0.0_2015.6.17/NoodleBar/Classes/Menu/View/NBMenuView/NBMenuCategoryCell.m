//
//  NBMenuCategoryCell.m
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMenuCategoryCell.h"
#import "NBCommon.h"

@interface NBMenuCategoryCell ()
@property(nonatomic, weak) UIView *underlineView;
@end

@implementation NBMenuCategoryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"menuCategoryCell";
    NBMenuCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NBMenuCategoryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setHighlighted:NO animated:NO];
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:14.f];
//        self.opaque = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *underlineView = [UIView newAutoLayoutView];
    [self.contentView addSubview:underlineView];
    underlineView.backgroundColor = HEX_COLOR(0xeda300);
    [underlineView autoSetDimension:ALDimensionHeight toSize:3.f];
    [underlineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    underlineView.hidden = YES;
    _underlineView = underlineView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = HEX_COLOR(0xeda300);
        self.underlineView.hidden = NO;
        self.backgroundColor = [UIColor whiteColor];
    }else
    {
        self.textLabel.textColor = HEX_COLOR(0x000000);
        self.underlineView.hidden = YES;
        self.backgroundColor = HEX_COLOR(0xefefef);
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.x = (self.width - self.textLabel.width) * 0.5;
    
}


@end
