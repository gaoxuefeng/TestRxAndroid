//
//  NBReadCodeController.h
//  NoodleBar
//
//  Created by sen on 5/28/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBViewController.h"
@class NBReadCodeController;

@protocol NBReadCodeControllerDelegate <NSObject>
@optional
- (void)readCodeControllerDidFinishReadWithMerchentID:(NSString *)merchantID tableCode:(NSString *)tableCode;

@end

@interface NBReadCodeController : NBViewController
@property(nonatomic, weak) id<NBReadCodeControllerDelegate> delegate;
@end
