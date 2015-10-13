//
//  CSAvailableRoomsCell.h
//  CloudSong
//
//  Created by youmingtaizi on 7/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseTableViewCell.h"

@class CSKTVRoomItem;
@protocol CSAvailableRoomsCellDelegate;

@interface CSAvailableRoomsCell : CSBaseTableViewCell
@property (nonatomic, assign)id<CSAvailableRoomsCellDelegate>  delegate;
- (void)setDataWithRoomItem:(CSKTVRoomItem *)item;
@end

@protocol CSAvailableRoomsCellDelegate <NSObject>
- (void)availableRoomsCell:(CSAvailableRoomsCell *)cell didBookingRoomItem:(CSKTVRoomItem *)item;
@end
