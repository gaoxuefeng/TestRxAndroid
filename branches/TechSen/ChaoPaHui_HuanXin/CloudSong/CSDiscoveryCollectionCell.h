//
//  CSDiscoveryCollectionCell.h
//  CloudSong
//
//  Created by EThank on 15/6/12.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSRecordsModel ;

@interface CSDiscoveryCollectionCell : UICollectionViewCell
/** 赞的次数 */
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (nonatomic, strong) CSRecordsModel *recordsData ;
/** 听的次数 */
@property (weak, nonatomic) IBOutlet UILabel *listenedCount;

@end
