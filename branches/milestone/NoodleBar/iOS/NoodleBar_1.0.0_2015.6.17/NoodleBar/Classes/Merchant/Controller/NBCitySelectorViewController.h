//
//  NBCitySelectorViewController.h
//  NoodleBar
//
//  Created by sen on 6/8/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBViewController.h"

@class NBCitySelectorViewController;

@protocol NBCitySelectorViewControllerDelegate <NSObject>

- (void)citySelectorViewControllerDidSelectCity:(NSString *)city;

@end

@interface NBCitySelectorViewController : NBViewController

@property(nonatomic, weak) id<NBCitySelectorViewControllerDelegate> delegate;
@end
