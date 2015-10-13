//
//  CSCategoryTableViewCell.m
//  CloudSong
//
//  Created by 汪辉 on 15/8/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSCategoryTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation CSCategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCategory:(CSSongCategoryItem *)category{

    [_icon sd_setImageWithURL:[NSURL URLWithString:category.imageSrc] placeholderImage:[UIImage imageNamed:@""]];
    _title.text = category.listTypeName;
    NSArray * songArray = @[_song1,_song2,_song3];
    for (int i = 0; i <category.threeSong.count; i ++) {
        UILabel * song = songArray[i];
        song.text=[category.threeSong[i]objectForKey:@"songName"];
    }
}
@end
