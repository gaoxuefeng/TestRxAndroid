//
//  CSKTVDetailAddressCell.h
//  CloudSong
//
//  Created by youmingtaizi on 7/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseTableViewCell.h"

@protocol CSKTVDetailAddressCellDelegate;

@interface CSKTVDetailAddressCell : CSBaseTableViewCell
@property (nonatomic, weak)id<CSKTVDetailAddressCellDelegate>  delegate;
- (void)setAddress:(NSString *)address phoneNum:(NSString *)phoneNum;
@end

@protocol CSKTVDetailAddressCellDelegate <NSObject>
- (void)KTVDetailAddressCellDidPressLocateBtn:(CSKTVDetailAddressCell *)cell;
@end