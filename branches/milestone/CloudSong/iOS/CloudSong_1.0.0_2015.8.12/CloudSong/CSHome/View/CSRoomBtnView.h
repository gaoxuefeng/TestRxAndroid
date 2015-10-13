//
//  CSRoomBtnView.h
//  CloudSong
//
//  Created by EThank on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSRoomBtnView  ;

@protocol RoomBtnViewDelegate <NSObject>

@optional
- (void)roomBtnView:(CSRoomBtnView *)roomBtnView didClickRoomBtn:(UIButton *)roomBtn ;

@end

@interface CSRoomBtnView : UIView

@property (nonatomic, weak) id <RoomBtnViewDelegate> delegate ;
@property (nonatomic, copy) NSString *roomBtnTitle ;
/** 描述信息 */
@property (nonatomic, weak) UILabel *descInfoLabel ;



- (void)roomBtnViewanimateWithTimeInterval:(NSTimeInterval )interval ;
@end
