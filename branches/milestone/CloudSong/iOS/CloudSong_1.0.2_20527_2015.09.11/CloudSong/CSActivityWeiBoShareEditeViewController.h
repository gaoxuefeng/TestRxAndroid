//
//  CSActivityWeiBoShareEditeViewController.h
//  CloudSong
//
//  Created by 汪辉 on 15/8/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSActivityWeiBoShareEditeViewController : CSBaseViewController
@property (strong, nonatomic) IBOutlet UITextView *shareContentText;
@property (weak, nonatomic) IBOutlet UIImageView *shareUimgeView;
@property (weak, nonatomic) IBOutlet UIButton *shareAt;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)atFriends:(id)sender;

- (instancetype)initWithShareContentText:(NSString *)shareContentText htmlUrl:(NSString *)htmlUrl shareImage:(UIImage *)shareImage;
@end
