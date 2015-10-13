//
//  CSPersonPageViewController.m
//  CloudSong
//
//  Created by sen on 15/6/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSPersonPageViewController.h"
#import "CSEditUserInfoViewController.h"
#import "CSEditUserIconViewController.h"
#import "CSEditUserInfoBGViewController.h"
#import <UIButton+WebCache.h>
#import <Masonry.h>
#import <MobClick.h>
#define HEADER_HEIGHT TRANSFER_SIZE(151.0)

#define LEFT_PADDING TRANSFER_SIZE(20.0)
@interface CSPersonPageViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *_nameAndGenderView;
    UIView *_ageAndConView;
    UIView *_favoriteSingerView;
    UIView *_favoriteSongView;
    UIView *_signatureView;
    
}
@property(nonatomic, weak) UIView *container;
//@property(nonatomic, weak) UIButton *bgView;
@property(nonatomic, weak) UIView *headerView;
@property(nonatomic, weak) UIView *backgroundView;
/** 用户名 */
@property(nonatomic, weak) UILabel *nameLabel;
/** 用户头像 */
@property(nonatomic, weak) UIButton *userIconView;
/** 性别 */
@property(nonatomic, weak) UILabel *genderLabel;
/** 年龄 */
@property(nonatomic, weak) UILabel *ageLabel;
/** 星座 */
@property(nonatomic, weak) UILabel *conLabel;
/** 血型 */
@property(nonatomic, weak) UILabel *bloodTypeLabel;
/** 最爱歌手 */
@property(nonatomic, weak) UILabel *favoriteSingerLabel;
/** 最喜欢歌曲 */
@property(nonatomic, weak) UILabel *favoriteSongLabel;
/** 个性签名 */
@property(nonatomic, weak) UILabel *signatureLabel;

@end

@implementation CSPersonPageViewController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人主页";
    [self setupSubViews];
    [self setupNavRightButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:USER_INFO_UPDATED object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_INFO_UPDATED object:nil];
    
}


#pragma mark - Setup
- (void)setupNavRightButton
{
    UIButton *editUserInfoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editUserInfoButton addTarget:self action:@selector(editUserInfoBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [editUserInfoButton setTitle:@"信息编辑" forState:UIControlStateNormal];
    [editUserInfoButton  setTitleColor:HEX_COLOR(0xff41ab) forState:UIControlStateNormal];
    editUserInfoButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [editUserInfoButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editUserInfoButton];
}
- (void)setupSubViews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.alwaysBounceVertical = YES;
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView.superview);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container.superview);
        make.width.equalTo(container.superview);
    }];
    _container = container;
    
    UIView *headerView = [[UIView alloc] init];
    [container addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(headerView.superview);
                make.height.mas_equalTo(HEADER_HEIGHT);
            }];
    _headerView = headerView;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_page_bg"]];
    [headerView addSubview:backgroundView];
    _backgroundView = backgroundView;
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundView.superview);
    }];
    // 图像
    UIButton *userIconView = [[UIButton alloc] init];
    [userIconView addTarget:self action:@selector(userIconViewOnClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:userIconView];
    CGFloat radius = TRANSFER_SIZE(33.0);
    userIconView.layer.cornerRadius = radius;
    userIconView.layer.masksToBounds = YES;
    [userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIconView.superview).offset(TRANSFER_SIZE(25.0));
        make.centerY.equalTo(headerView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(radius * 2, radius * 2));
    }];
    _userIconView = userIconView;
    

    
    // 姓名性别
    [self setupNameAndGenderView];
    
    // 年龄 星座 血型
    [self setupAgeAndConView];
    
    // 最喜欢歌手
    [self setupFavoriteSingerView];
    
    // 最喜欢的歌曲
    [self setupFavoriteSongView];
    
    // 个性签名
    [self setupSignatureView];
    
    [container bringSubviewToFront:userIconView];
}
// 姓名性别
- (void)setupNameAndGenderView
{
    _nameAndGenderView = [[UIView alloc] init];
    [_container addSubview:_nameAndGenderView];
    [_nameAndGenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom);
        make.left.right.equalTo(_nameAndGenderView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(105.0));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    nameLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_nameAndGenderView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.superview).offset(TRANSFER_SIZE(10.0));
        make.left.equalTo(_userIconView.mas_right).offset(TRANSFER_SIZE(17.0));
    }];
    _nameLabel = nameLabel;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x141317);
    [_nameAndGenderView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomLine.superview);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
    
    UILabel *genderTitleLabel = [[UILabel alloc] init];
    genderTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    genderTitleLabel.textColor = HEX_COLOR(0x414247);
    genderTitleLabel.text = @"性别";
    [_nameAndGenderView addSubview:genderTitleLabel];
    [genderTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(genderTitleLabel.superview).offset(LEFT_PADDING);
        make.bottom.equalTo(genderTitleLabel.superview).offset(-TRANSFER_SIZE(20.0));
    }];
    
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    genderLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_nameAndGenderView addSubview:genderLabel];
    [genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(genderTitleLabel);
        make.left.equalTo(genderTitleLabel.mas_right).offset(TRANSFER_SIZE(10.0));
    }];
    _genderLabel = genderLabel;
    
    
    
    
}
// 年龄 星座 血型
- (void)setupAgeAndConView
{
    _ageAndConView = [[UIView alloc] init];
    [_container addSubview:_ageAndConView];
    [_ageAndConView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameAndGenderView.mas_bottom);
        make.left.right.equalTo(_ageAndConView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(54.0));
    }];
    
    UILabel *ageTitleLabel = [[UILabel alloc] init];
    ageTitleLabel.text = @"年龄";
    ageTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    ageTitleLabel.textColor = HEX_COLOR(0x414247);
    [_ageAndConView addSubview:ageTitleLabel];
    [ageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ageTitleLabel.superview);
        make.left.equalTo(ageTitleLabel.superview).offset(LEFT_PADDING);
    }];
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    ageLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_ageAndConView addSubview:ageLabel];
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ageLabel.superview);
        make.left.equalTo(ageTitleLabel.mas_right).offset(TRANSFER_SIZE(10.0));
    }];
    _ageLabel = ageLabel;
    
    UILabel *conTitleLabel = [[UILabel alloc] init];
    conTitleLabel.text = @"星座";
    conTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    conTitleLabel.textColor = HEX_COLOR(0x414247);
    [_ageAndConView addSubview:conTitleLabel];
    [conTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(conTitleLabel.superview);
        make.left.equalTo(conTitleLabel.superview).offset(AUTOLENGTH(115.0));
    }];
    
    UILabel *conLabel = [[UILabel alloc] init];
    conLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    conLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_ageAndConView addSubview:conLabel];
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(conLabel.superview);
        make.left.equalTo(conTitleLabel.mas_right).offset(TRANSFER_SIZE(10.0));
    }];
    _conLabel = conLabel;
    
    
    
    UILabel *bloodTypeTitleLabel = [[UILabel alloc] init];
    bloodTypeTitleLabel.text = @"血型";
    bloodTypeTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    bloodTypeTitleLabel.textColor = HEX_COLOR(0x414247);
    [_ageAndConView addSubview:bloodTypeTitleLabel];
    [bloodTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bloodTypeTitleLabel.superview);
        make.left.equalTo(bloodTypeTitleLabel.superview).offset(AUTOLENGTH(235.0));
    }];
    
    UILabel *bloodTypeLabel = [[UILabel alloc] init];
    bloodTypeLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    bloodTypeLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_ageAndConView addSubview:bloodTypeLabel];
    [bloodTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bloodTypeLabel.superview);
        make.left.equalTo(bloodTypeTitleLabel.mas_right).offset(TRANSFER_SIZE(10.0));
    }];
    _bloodTypeLabel = bloodTypeLabel;

    
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x141317);
    [_ageAndConView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomLine.superview);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
}

// 最喜欢歌手
- (void)setupFavoriteSingerView
{
    _favoriteSingerView = [[UIView alloc] init];
    [_container addSubview:_favoriteSingerView];
    [_favoriteSingerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_favoriteSingerView.superview);
        make.top.equalTo(_ageAndConView.mas_bottom);
        make.height.mas_greaterThanOrEqualTo(TRANSFER_SIZE(54.0));
    }];
    
    UILabel *favoriteSingerTitleLabel = [[UILabel alloc] init];
    favoriteSingerTitleLabel.text = @"最爱歌手";
    favoriteSingerTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    favoriteSingerTitleLabel.textColor = HEX_COLOR(0x414247);
    CGSize favoriteSingerTitleLabelSize = [self sizeWithString:favoriteSingerTitleLabel.text font:favoriteSingerTitleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [_favoriteSingerView addSubview:favoriteSingerTitleLabel];
    [favoriteSingerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(favoriteSingerTitleLabel.superview).offset(TRANSFER_SIZE(18.0));
        make.left.equalTo(favoriteSingerTitleLabel.superview).offset(LEFT_PADDING);
        make.width.mas_equalTo(favoriteSingerTitleLabelSize.width);
    }];
    
    UILabel *favoriteSingerLabel = [[UILabel alloc] init];
    favoriteSingerLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    favoriteSingerLabel.numberOfLines = 0;
    favoriteSingerLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_favoriteSingerView addSubview:favoriteSingerLabel];
    [favoriteSingerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(favoriteSingerLabel.superview);
        make.top.equalTo(favoriteSingerTitleLabel);
        make.right.equalTo(favoriteSingerLabel.superview).offset(-LEFT_PADDING);
        make.left.equalTo(favoriteSingerTitleLabel.mas_right).offset(LEFT_PADDING);
    }];
    _favoriteSingerLabel = favoriteSingerLabel;

    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x141317);
    [_favoriteSingerView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomLine.superview);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];

}

// 最喜欢的歌曲
- (void)setupFavoriteSongView
{
    _favoriteSongView = [[UIView alloc] init];
    [_container addSubview:_favoriteSongView];
    [_favoriteSongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_favoriteSongView.superview);
        make.top.equalTo(_favoriteSingerView.mas_bottom);
        make.height.mas_greaterThanOrEqualTo(TRANSFER_SIZE(54.0));
    }];
    
    UILabel *favoriteSongTitleLabel = [[UILabel alloc] init];
    favoriteSongTitleLabel.text = @"最喜欢的歌曲";
    favoriteSongTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    favoriteSongTitleLabel.textColor = HEX_COLOR(0x414247);
    CGSize favoriteSongTitleLabelSize = [self sizeWithString:favoriteSongTitleLabel.text font:favoriteSongTitleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [_favoriteSongView addSubview:favoriteSongTitleLabel];
    [favoriteSongTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(favoriteSongTitleLabel.superview).offset(TRANSFER_SIZE(18.0));
        make.left.equalTo(favoriteSongTitleLabel.superview).offset(LEFT_PADDING);
        make.width.mas_equalTo(favoriteSongTitleLabelSize.width);
    }];
    
    UILabel *favoriteSongLabel = [[UILabel alloc] init];
    favoriteSongLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    favoriteSongLabel.numberOfLines = 0;
    favoriteSongLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_favoriteSongView addSubview:favoriteSongLabel];
    [favoriteSongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(favoriteSongLabel.superview);
        make.top.equalTo(favoriteSongTitleLabel);
        make.right.equalTo(favoriteSongLabel.superview).offset(-LEFT_PADDING);
        make.left.equalTo(favoriteSongTitleLabel.mas_right).offset(LEFT_PADDING);
    }];
    _favoriteSongLabel = favoriteSongLabel;
    
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x141317);
    [_favoriteSongView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomLine.superview);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
}
// 个性签名
- (void)setupSignatureView
{
    _signatureView = [[UIView alloc] init];
    [_container addSubview:_signatureView];
    [_signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_signatureView.superview);
        make.top.equalTo(_favoriteSongView.mas_bottom);
        make.height.mas_greaterThanOrEqualTo(TRANSFER_SIZE(54.0));
    }];
    
    UILabel *signatureTitleLabel = [[UILabel alloc] init];
    signatureTitleLabel.text = @"个性签名";
    signatureTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    signatureTitleLabel.textColor = HEX_COLOR(0x414247);
    CGSize signatureTitleLabelSize = [self sizeWithString:signatureTitleLabel.text font:signatureTitleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [_signatureView addSubview:signatureTitleLabel];
    [signatureTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signatureTitleLabel.superview).offset(TRANSFER_SIZE(18.0));
        make.left.equalTo(signatureTitleLabel.superview).offset(LEFT_PADDING);
        make.width.mas_equalTo(signatureTitleLabelSize.width);
    }];
    
    UILabel *signatureLabel = [[UILabel alloc] init];
    signatureLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    signatureLabel.numberOfLines = 0;
    signatureLabel.textColor = HEX_COLOR(0xb5b7bf);
    [_signatureView addSubview:signatureLabel];
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(signatureLabel.superview);
        make.top.equalTo(signatureTitleLabel);
        make.right.equalTo(signatureLabel.superview).offset(-LEFT_PADDING);
        make.left.equalTo(signatureTitleLabel.mas_right).offset(LEFT_PADDING);
    }];
    _signatureLabel = signatureLabel;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // y偏移量
    CGFloat offsetY = -scrollView.contentOffset.y;
    // 头部视图需放大比例
    CGFloat scale = (HEADER_HEIGHT + offsetY) / HEADER_HEIGHT;
    
    // 如果偏移量 > 0 则拉伸,否则不拉伸
    if (offsetY > 0) {
        if(NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
            [_backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
        }
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0,-offsetY * 0.5);
        transform = CGAffineTransformScale(transform, scale, scale);
        _backgroundView.transform = transform;
    }else
    {
        if (!CGAffineTransformIsIdentity(_backgroundView.transform)) {
            _backgroundView.transform = CGAffineTransformIdentity;
        }
        
    }
}


- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = font;
    CGSize stringSize = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    return stringSize;
}

#pragma mark - Action
- (void)editUserInfoBtnOnClick
{
    [MobClick event:@"MineInfo"];
    CSEditUserInfoViewController *editUserInfoVc = [[CSEditUserInfoViewController alloc] init];
    [self.navigationController pushViewController:editUserInfoVc animated:YES];
}

- (void)userIconViewOnClick
{
    CSEditUserIconViewController *editUserIconVc = [[CSEditUserIconViewController alloc] init];
    [editUserIconVc setNavigationBarBGHidden];
    [self.navigationController pushViewController:editUserIconVc animated:YES];
}

#pragma mark - Load Data
- (void)loadData
{
    CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
    _nameLabel.text = userInfo.nickName;
    _genderLabel.text = userInfo.gender;
    _ageLabel.text = [userInfo.age stringValue];
    _conLabel.text = userInfo.constellation;
    _bloodTypeLabel.text = userInfo.bloodType.length>0?[NSString stringWithFormat:@"%@型",userInfo.bloodType]:nil;
    _favoriteSingerLabel.text = userInfo.loveSingers;
    _favoriteSingerLabel.numberOfLines = 2;
    _favoriteSongLabel.numberOfLines = 2;
    _favoriteSongLabel.text = userInfo.loveSongs;
    _signatureLabel.text = userInfo.signature;
    if (userInfo.headUrl.length > 0) {
        [_userIconView sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.headUrl] forState:UIControlStateNormal placeholderImage:GlobalObj.userIcon];
    }else
    {
        [_userIconView setBackgroundImage:[UIImage imageNamed:[userInfo.gender isEqualToString:@"男"]?@"mine_default_avatar":@"mine_default_avatar_female"] forState:UIControlStateNormal];
    }
}



@end
