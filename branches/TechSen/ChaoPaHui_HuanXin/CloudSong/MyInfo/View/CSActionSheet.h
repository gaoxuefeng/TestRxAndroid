//
//  CSActionSheet.h
//  CloudSong
//
//  Created by sen on 15/6/19.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSActionSheet;
@protocol CSActionSheetDelegate <NSObject>

- (void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface CSActionSheet : UIView
@property(nonatomic, weak) id<CSActionSheetDelegate> delegate;
/**
 *  返回一个CSActionSheet对象
 *
 *  @param delegate    代理
 *  @param cancelTitle 取消按钮文字
 *  @param otherTitles 其他按钮文字
 */
- (instancetype)initWithDelegate:(id<CSActionSheetDelegate>)delegate headerTitle:(NSString *)headerTitle cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *)otherTitles;
- (NSString *)buttonTitleAtIndex:(NSInteger)index;
- (void)show;
@end
