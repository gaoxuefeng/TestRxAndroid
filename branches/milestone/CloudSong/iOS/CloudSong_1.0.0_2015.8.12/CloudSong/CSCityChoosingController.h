//
//  CSCityChoosingController.h
//  CloudSong
//
//  Created by youmingtaizi on 5/20/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CSCityChoosingControllerDelegate;

@interface CSCityChoosingController : NSObject
@property (nonatomic, weak)id<CSCityChoosingControllerDelegate> delegate;

- (void)hideKeyboard;
- (UIView *)citySelectView;
- (void)reloadData;
@end

@protocol CSCityChoosingControllerDelegate <NSObject>
- (void)cityChoosingController:(CSCityChoosingController *)controller didSelectCity:(NSString *)city;
@end