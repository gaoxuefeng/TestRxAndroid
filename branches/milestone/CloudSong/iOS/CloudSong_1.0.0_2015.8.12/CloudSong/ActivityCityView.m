//
//  ActivityCityView.m
//  CloudSong
//
//  Created by 汪辉 on 15/7/28.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "ActivityCityView.h"
#import "CSDefine.h"
#import "ActivityCityCell.h"
#import "CSDataService.h"
#import "CSHttpTool.h"
#import "SVProgressHUD.h"

@implementation ActivityCityView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 
 }*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getActivityCity];
    }
    return self;
}
-(void)getActivityCity{
    [CSHttpTool get:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, ActivityCityProtocol] params:nil success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"]intValue]==ResponseStateSuccess) {
            _cityName = [NSMutableArray arrayWithArray:[[responseObj objectForKey:@"data"] objectForKey:@"cityNames"]];
            [_cityName insertObject:@"全国" atIndex:0];
            [self UI];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
    }];

}
-(void)UI{
    
    int lineNum = (unsigned)_cityName.count/3;
    _cityLine = _cityName.count%3 ? ++lineNum : lineNum;
    
    self.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIView * collectBGView =[[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREENWIDTH, TRANSFER_SIZE(29)*(_cityLine+1) + TRANSFER_SIZE(8) *(_cityLine-1))];
    collectBGView.backgroundColor =HEX_COLOR(0x251e3b);
    [self addSubview:collectBGView];
    
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
    flow.headerReferenceSize = CGSizeMake(SCREENWIDTH, TRANSFER_SIZE(8));
    flow.minimumInteritemSpacing = TRANSFER_SIZE(8);
    flow.minimumLineSpacing = TRANSFER_SIZE(8);
    UICollectionView * collection = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 1, SCREENWIDTH-40, TRANSFER_SIZE(29)*(_cityLine+1) + TRANSFER_SIZE(8) *(_cityLine-1)) collectionViewLayout:flow];
    collection.delegate = self;
    collection.dataSource = self;
    [collection registerClass:[ActivityCityCell class] forCellWithReuseIdentifier:@"ActivityCityCell"];
    collection.backgroundColor = HEX_COLOR(0x251e3b);
    [self addSubview:collection];

    
}
#pragma mark ---- collection delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(TRANSFER_SIZE(87),TRANSFER_SIZE(29));
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cityName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    ActivityCityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCityCell" forIndexPath:indexPath];
    cell.cityName.text= [_cityName objectAtIndex:indexPath.row];
    if ([[NSUserDefaults standardUserDefaults]floatForKey:@"cityRow"]==indexPath.row+1) {
        cell.cityBGView.backgroundColor=HEX_COLOR(0x524582);
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第%ld区,第%ld行",(long)indexPath.section,(long)indexPath.row);
    [self cityAnimate];
    NSString * cityName =[_cityName objectAtIndex:indexPath.row];
    NSDictionary *info = @{
                           @"cityName":cityName,
                           };
    [[NSUserDefaults standardUserDefaults]setObject:cityName forKey:@"cityName"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCityName"
                                                        object:info];
    
    NSIndexPath * oldIndexPath = [NSIndexPath indexPathForRow:[[NSUserDefaults standardUserDefaults]floatForKey:@"cityRow"]-1 inSection:0];
    ActivityCityCell * oldCell  =(ActivityCityCell * )[collectionView cellForItemAtIndexPath:oldIndexPath];
    oldCell.cityBGView.backgroundColor=HEX_COLOR(0x372e57);
    
    [[NSUserDefaults standardUserDefaults] setFloat:indexPath.row+1 forKey:@"cityRow"];
    ActivityCityCell * newCell  =(ActivityCityCell * )[collectionView cellForItemAtIndexPath:indexPath];
    newCell.cityBGView.backgroundColor=HEX_COLOR(0x524582);
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self cityAnimate];
}

-(void)cityAnimate{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect cityframe = self.frame;
                         cityframe.origin.y =self.frame.origin.y == -664 ?  64 : -664;
                         self.frame=cityframe;
                     } completion:^(BOOL finished) {
                     }];
}
@end
