//
//  CSConfigNavigationBar.h
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#ifndef CloudSong_CSConfigNavigationBar_h
#define CloudSong_CSConfigNavigationBar_h

@protocol CSConfigNavigationBar <NSObject>
@required
- (void)configNavigationBar;
- (void)backBtnOnClick;
- (void)setNavigationBarBGHidden;
@end

#endif
