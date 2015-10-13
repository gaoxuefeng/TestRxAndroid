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

@implementation ActivityCityView{
    UIView * _collectBGView;
    float _collectHeight;
}
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
        [self UI];
    }
    return self;
}

-(void)UI{
    
    self.cityName =GlobalObj.cityName;
    int lineNum = (unsigned)_cityName.count/3;
    _cityLine = _cityName.count%3 ? ++lineNum : lineNum;
    _collectHeight = TRANSFER_SIZE(29)*(_cityLine+1) + TRANSFER_SIZE(8) *(_cityLine-1);
    self.backgroundColor =[UIColor clearColor];
    _collectBGView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _collectHeight)];
    _collectBGView.backgroundColor =HEX_COLOR(0x281a40);
    [self addSubview:_collectBGView];
    
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
    flow.headerReferenceSize = CGSizeMake(SCREENWIDTH, TRANSFER_SIZE(8));
    flow.minimumInteritemSpacing = TRANSFER_SIZE(8);
    flow.minimumLineSpacing = TRANSFER_SIZE(8);
    UICollectionView * collection = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 1, SCREENWIDTH-40, TRANSFER_SIZE(29)*(_cityLine+1) + TRANSFER_SIZE(8) *(_cityLine-1)) collectionViewLayout:flow];
    collection.delegate = self;
    collection.dataSource = self;
    [collection registerClass:[ActivityCityCell class] forCellWithReuseIdentifier:@"ActivityCityCell"];
    collection.backgroundColor = HEX_COLOR(0x281a40);
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
//    CSLog(@"%ld",(long)indexPath.row);
    ActivityCityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCityCell" forIndexPath:indexPath];
    cell.cityName.text= [_cityName objectAtIndex:indexPath.row];
    if ([[NSUserDefaults standardUserDefaults]floatForKey:@"cityRow"]==indexPath.row+1) {
        cell.cityBGView.backgroundColor=HEX_COLOR(0x623c96);
    }else{
        cell.cityBGView.backgroundColor=HEX_COLOR(0x382559);
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CSLog(@"第%ld区,第%ld行",(long)indexPath.section,(long)indexPath.row);
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
    oldCell.cityBGView.backgroundColor=HEX_COLOR(0x382559);
    
    [[NSUserDefaults standardUserDefaults] setFloat:indexPath.row+1 forKey:@"cityRow"];
    ActivityCityCell * newCell  =(ActivityCityCell * )[collectionView cellForItemAtIndexPath:indexPath];
    newCell.cityBGView.backgroundColor=HEX_COLOR(0x623c96);
    
    
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
