//
//  YSBeaconTableViewCell.m
//  YSBeaconDemo
//
//  Created by sen on 8/13/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "YSBeaconTableViewCell.h"

@implementation YSBeaconTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"beaconCell";
    YSBeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[YSBeaconTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}


#pragma mark - Setup
- (void)setupSubviews
{
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
}

#pragma mark - Public Methods
- (void)setBeacon:(CLBeacon *)beacon
{
    _beacon = beacon;
    self.textLabel.text = [NSString stringWithFormat:@"UUID = %@ \n major = %@ \n minor = %@, \n rssi = %ld \n 距离 = %.2f米 ",beacon.proximityUUID.UUIDString,beacon.major , beacon.minor ,beacon.rssi,beacon.accuracy];
    
}

@end
