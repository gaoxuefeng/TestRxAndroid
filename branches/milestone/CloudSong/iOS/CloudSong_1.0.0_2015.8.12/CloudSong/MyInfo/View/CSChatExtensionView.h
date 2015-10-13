//
//  CSChatExtensionView.h
//  CloudSong
//
//  Created by sen on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger {
    CSChatExtensionTypeMagicFace,
    CSChatExtensionTypePhoto,
    CSChatExtensionTypeDoodle
} CSChatExtensionType;

@class CSChatExtensionView;
@protocol CSChatExtensionViewDelegate <NSObject>
@optional
- (void)chatExtensionView:(CSChatExtensionView *)chatExtensionView extensionButtonPressed:(CSChatExtensionType)type;

@end


@interface CSChatExtensionView : UIView
@property(nonatomic, weak) id<CSChatExtensionViewDelegate> delegate;
@end
