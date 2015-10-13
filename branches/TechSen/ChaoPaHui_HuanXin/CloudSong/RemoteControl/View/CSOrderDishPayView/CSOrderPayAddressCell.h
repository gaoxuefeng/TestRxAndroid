//
//  CSOrderPayAddressCell.h
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CSOrderPayAddressCellTypedrinks,
    CSOrderPayAddressCellTypeReserve
    
}CSOrderPayAddressCellType;

@interface CSOrderPayAddressCell : UIView
- (instancetype)initWithType:(CSOrderPayAddressCellType)type;
@property(nonatomic, copy) NSString *address;
@end
