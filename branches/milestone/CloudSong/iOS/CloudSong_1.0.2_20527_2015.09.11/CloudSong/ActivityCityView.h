//
//  ActivityCityView.h
//  CloudSong
//
//  Created by 汪辉 on 15/7/28.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCityView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,assign)int cityLine;
@property(nonatomic,strong)NSMutableArray * cityName;
-(void)cityAnimate;
@end
