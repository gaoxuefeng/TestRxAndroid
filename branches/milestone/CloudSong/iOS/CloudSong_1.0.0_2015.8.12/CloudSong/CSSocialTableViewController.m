//
//  CSSocialTableViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 15/4/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSocialTableViewController.h"
#import "UMSocial.h"

@interface CSSocialTableViewController ()

@end

@implementation CSSocialTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

-(void)onSwitchOauth:(UISwitch *)switcher
{
//    _changeSwitcher = switcher;
    
    if (switcher.isOn == YES) {
        [switcher setOn:NO];
        
//        // QQ登录
//        //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
//                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            }
//        });
        
//        // 微信登录
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
//                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            }
//        });

        // 新浪微博登录
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            // 获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            }});
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UMSnsAccountCellIdentifier = @"UMSnsAccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSnsAccountCellIdentifier];
    // 已经授权的社交账户信息
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    
    UMSocialSnsPlatform *snsPlatform = nil;
    if (indexPath.row == 0) {
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    }
    else if(indexPath.row == 1){
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    }
    else {
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    }
    
    UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:UMSnsAccountCellIdentifier] ;
    }
    
    // 生成、布局cell上面的开关
    UISwitch *oauthSwitch = nil;
    if ([cell viewWithTag:snsPlatform.shareToType]) {
        oauthSwitch = (UISwitch *)[cell viewWithTag:snsPlatform.shareToType];
    }
    else{
        oauthSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 10, 40, 20)];
        oauthSwitch.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        oauthSwitch.tag = snsPlatform.shareToType;
        [cell addSubview:oauthSwitch];
    }
    oauthSwitch.center = CGPointMake(self.tableView.bounds.size.width - 40, oauthSwitch.center.y);
    [oauthSwitch addTarget:self action:@selector(onSwitchOauth:) forControlEvents:UIControlEventValueChanged];
    
    NSString *showUserName = nil;
    
    //这里判断是否授权
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:snsPlatform.platformName]) {
        [oauthSwitch setOn:YES];
        //这里获取到每个授权账户的昵称
        showUserName = accountEnitity.userName;
    }
    else {
        [oauthSwitch setOn:NO animated:YES];
        showUserName = [NSString stringWithFormat:@"尚未授权"];
    }
    
    if ([showUserName isEqualToString:@""]) {
        cell.textLabel.text = @"已授权";
    }
    else{
        cell.textLabel.text = showUserName;
    }
    
    cell.imageView.image = [UIImage imageNamed:snsPlatform.smallImageName];
    return cell;
}

@end
