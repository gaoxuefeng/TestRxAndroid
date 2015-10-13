//
//  CSActivityWeiBoShareEditeViewController.m
//  CloudSong
//
//  Created by 汪辉 on 15/8/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSActivityWeiBoShareEditeViewController.h"
#import "CSActivityWeiBoFriendsViewController.h"
#import <UMSocial.h>
#import "SVProgressHUD.h"
@interface CSActivityWeiBoShareEditeViewController ()
@property (copy ,nonatomic) NSString *shareContent;
@property (strong ,nonatomic) UIImage *shareImage;
@property (copy ,nonatomic) NSString *htmlUrl;

@property (assign ,nonatomic) NSInteger remainTextNum;
@end

@implementation CSActivityWeiBoShareEditeViewController
- (IBAction)atFriends:(id)sender {
    CSActivityWeiBoFriendsViewController * friendsVC =[[CSActivityWeiBoFriendsViewController alloc]init];
    friendsVC.atBlock=  ^(NSString * friend){
        _shareContentText.text= [NSString stringWithFormat:@"%@\n@%@",_shareContentText.text,friend];
    };
    [self.navigationController pushViewController:friendsVC animated:YES];
}

- (instancetype)initWithShareContentText:(NSString *)shareContentText htmlUrl:(NSString *)htmlUrl shareImage:(UIImage *)shareImage
{
    self = [super init];
    if (self) {
        _shareContent = shareContentText;
        _shareImage = shareImage;
        _htmlUrl = htmlUrl;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *playerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)] ;
    playerTitleLabel.textColor = [UIColor whiteColor] ;
    playerTitleLabel.text = @"分享到微博" ;
    self.navigationItem.titleView = playerTitleLabel ;
    
    [self.shareContentText becomeFirstResponder];
    UIBarButtonItem * leftBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"room_nav_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeShare)];
    UIButton * shareBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBut addTarget:self action:@selector(weiBoShare) forControlEvents:UIControlEventTouchUpInside];
    [shareBut setTitle:@"分享" forState:UIControlStateNormal];
    [shareBut setTitleColor:HEX_COLOR(0Xe20399) forState:UIControlStateNormal];
    shareBut.titleLabel.font=[UIFont systemFontOfSize:16];
    shareBut.frame=CGRectMake(0, 0, 50, 30);
    
    UIBarButtonItem * rightBI = [[UIBarButtonItem alloc]initWithCustomView:shareBut];
    self.navigationItem.leftBarButtonItem =leftBI;
    self.navigationItem.rightBarButtonItem =rightBI;
    self.navigationController.navigationBar.tintColor=HEX_COLOR(0xee29a7);
    self.shareAt.layer.masksToBounds=YES;
    self.shareAt.layer.cornerRadius = 4;
    self.shareContentText.text= _shareContent;
    self.shareUimgeView.image =_shareImage;
    [self textViewDidChange:_shareContentText];
}
-(void)closeShare{
    [self.shareContentText resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)weiBoShare{

    if (_remainTextNum<=140) {
        self.navigationItem.rightBarButtonItem.enabled=NO;
        NSString * shareContent = [NSString stringWithFormat:@"%@\n%@",_shareContentText.text,_htmlUrl];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                CSLog(@"分享sina微博成功！");
                [SVProgressHUD showSuccessWithStatus:@"分享sina微博成功！"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"分享sina微博失败！"];
            }
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [self closeShare];
        }];
    }else{
    
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"超出分享字数限制"]];
    }


}

- (void)textViewDidChange:(UITextView*)textView{

    NSInteger existTextNum=[textView.text length];
    _remainTextNum=existTextNum;
    if (_remainTextNum > 140) {
        self.label.textColor= HEX_COLOR(0xee29a7);
    }else{
        self.label.textColor= HEX_COLOR(0xffffff);
    }
    self.label.text = [NSString stringWithFormat:@"%ld/140",(long)_remainTextNum];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
