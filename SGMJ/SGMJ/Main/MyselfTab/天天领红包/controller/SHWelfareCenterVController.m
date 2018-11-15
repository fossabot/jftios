//
//  SHWelfareCenterVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/12.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHWelfareCenterVController.h"
#import "SHWelfareModel.h"
#import "SHFindPsdVController.h"
#import "SHVerifyIDViewController.h"
#import "SHRReleaseViewController.h"
#import "SHSigninViewController.h"
#import "SHGetRedPackageVController.h"
#import "SHRFindServiceVController.h"
#import "SHRedPackageV.h"
#import "SH_SHSoundPlayer.h"

@interface SHWelfareCenterVController ()


@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *registerL;
@property (weak, nonatomic) IBOutlet UILabel *authoriseL;
@property (weak, nonatomic) IBOutlet UILabel *skillL;
@property (weak, nonatomic) IBOutlet UILabel *shopL;
@property (weak, nonatomic) IBOutlet UILabel *shareL;
@property (weak, nonatomic) IBOutlet UILabel *signinL;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *authoriseBtn;
@property (weak, nonatomic) IBOutlet UIButton *skillBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;



//分享(好友帮忙拆红包奖220元)

@property (nonatomic, strong) SHRedPackageV *redView;



@property (nonatomic, strong) SHWelfareModel *welfareModel;


@end

@implementation SHWelfareCenterVController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //return
    //SHColorFromHex(0x00a9f0)
    //字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor = SHColorFromHex(0xD41A00);
    self.navigationController.navigationBar.translucent = NO;
    
    //修改返回按钮
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 30, 44);
    UIImage * bImage = [[UIImage imageNamed: @"returnBack"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn addTarget:self action:@selector(back) forControlEvents: UIControlEventTouchUpInside];
    [btn setImage:bImage forState: UIControlStateNormal];
    UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = - 20;
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, lb];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    self.navigationController.navigationBar.barTintColor = SHColorFromHex(0x00a9f0);
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    [self loadWelfareCenterData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"RedPackageNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInNoti:) name:@"signInNoti" object:nil];
}

- (void)receiveNoti:(NSNotification *)noti
{
    SHLog(@"%@", noti.userInfo[@"key"])
    [self loadWelfareCenterData];
    SHWeakSelf
    if ([noti.userInfo[@"key"] isEqualToString:@"REGISTER"]) {
        SHRedPackageV *redV = [[SHRedPackageV alloc] init];
        redV.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _welfareModel.registeredMoney];
        [redV.button setTitle:@"领取注册红包" forState:UIControlStateNormal];
        redV.redPacBlock = ^(NSString *buttonTitle) {
            [weakSelf getRedMoneyWithString:buttonTitle];
        };
        [redV showRedPackageView];
    } else if ([noti.userInfo[@"key"] isEqualToString:@"NAME_Certification"]) {
        //领红包
        SHRedPackageV *redV = [[SHRedPackageV alloc] init];
        redV.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _welfareModel.authMoney];
        [redV.button setTitle:@"领取实名红包" forState:UIControlStateNormal];
        redV.redPacBlock = ^(NSString *buttonTitle) {
            [weakSelf getRedMoneyWithString:buttonTitle];
        };
        [redV showRedPackageView];
    } else if ([noti.userInfo[@"key"] isEqualToString:@"CREATE_SERVER"]) {
        //领红包
        SHRedPackageV *redV = [[SHRedPackageV alloc] init];
        redV.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _welfareModel.skillMoney];
        [redV.button setTitle:@"领取发布技能红包" forState:UIControlStateNormal];
        redV.redPacBlock = ^(NSString *buttonTitle) {
            [weakSelf getRedMoneyWithString:buttonTitle];
        };
        [redV showRedPackageView];
    } else if ([noti.userInfo[@"key"] isEqualToString:@"CREATE_ORDER"]) {
        //领红包
        SHRedPackageV *redV = [[SHRedPackageV alloc] init];
        redV.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _welfareModel.shoppingMoney];
        [redV.button setTitle:@"领取交易红包" forState:UIControlStateNormal];
        redV.redPacBlock = ^(NSString *buttonTitle) {
            [weakSelf getRedMoneyWithString:buttonTitle];
        };
        [redV showRedPackageView];
    } else if ([noti.userInfo[@"key"] isEqualToString:@"SHARE"]) {
        
    }
    
}

- (void)signInNoti:(NSNotification *)noti
{
    [self loadWelfareCenterData];
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"福利中心";
    
    // 已完成53a949   去完成c63c23
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = YES;
    
    _registBtn.layer.cornerRadius = 5;
    _registBtn.clipsToBounds = YES;
    _authoriseBtn.layer.cornerRadius = 5;
    _authoriseBtn.clipsToBounds = YES;
    _skillBtn.layer.cornerRadius = 5;
    _skillBtn.clipsToBounds = YES;
    _shopBtn.layer.cornerRadius = 5;
    _shopBtn.clipsToBounds = YES;
    _shareBtn.layer.cornerRadius = 5;
    _shareBtn.clipsToBounds = YES;
    _signBtn.layer.cornerRadius = 5;
    _signBtn.clipsToBounds = YES;
    
    _headImgV.layer.cornerRadius = _headImgV.height / 2;
    _headImgV.clipsToBounds = YES;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:SH_AppDelegate.personInfo.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameL.text = SH_AppDelegate.personInfo.nickName;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
    _bgImgV.userInteractionEnabled = YES;
    [_bgImgV addGestureRecognizer:tap];
    
}

- (void)tapBgView
{
    SHLog(@"发布")
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadWelfareCenterData
{
    
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHWelfareCenterUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            _welfareModel = [SHWelfareModel mj_objectWithKeyValues:JSON];
            [weakSelf initWithAllMoneyWith:_welfareModel];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
    }];
    
}

- (void)initWithAllMoneyWith:(SHWelfareModel *)model
{
    /**
     "isAuth": 0,//是否实名认证 0否 1需要领 2 已领
     "isSkill": 0,//是否发技能 0否 1是  2 已领
     "isRegistered": 1,//是否注册 0否 1是  2 已领
     "isShopping": 0,//是否消费 0否 1是  2 已领
     "isSignIn": 0//今天是否签到 0无  2 已完成
     redpocketUnReleaseState  未完成
     redpocketReleasedState   已完成
     redpocketPickState       去领取
     **/
    if (model.isRegistered == 0) {
        [_registBtn setTitle:@"去注册" forState:UIControlStateNormal];
//        [_registBtn setBackgroundColor:SHColorFromHex(0xc63c23)];
        [_registBtn setBackgroundImage:SHImageNamed(@"redpocketUnReleaseState") forState:UIControlStateNormal];
    } else if (model.isRegistered == 1) {
        [_registBtn setTitle:@"领红包" forState:UIControlStateNormal];
//        [_registBtn setBackgroundColor:SHColorFromHex(0x53a949)];
        [_registBtn setBackgroundImage:SHImageNamed(@"redpocketPickState") forState:UIControlStateNormal];
    } else if (model.isRegistered == 2) {
        _registBtn.userInteractionEnabled = NO;
        [_registBtn setTitle:@"已完成" forState:UIControlStateNormal];
//        [_registBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        [_registBtn setBackgroundImage:SHImageNamed(@"redpocketReleasedState") forState:UIControlStateNormal];
    }
    
    if (model.isAuth == 0) {
        [_authoriseBtn setTitle:@"去实名" forState:UIControlStateNormal];
//        [_authoriseBtn setBackgroundColor:SHColorFromHex(0xc63c23)];
        [_authoriseBtn setBackgroundImage:SHImageNamed(@"redpocketUnReleaseState") forState:UIControlStateNormal];
    } else if (model.isAuth == 1) {
        [_authoriseBtn setTitle:@"领红包" forState:UIControlStateNormal];
//        [_authoriseBtn setBackgroundColor:SHColorFromHex(0x53a949)];
        [_authoriseBtn setBackgroundImage:SHImageNamed(@"redpocketPickState") forState:UIControlStateNormal];
    } else if (model.isAuth == 2) {
        _authoriseBtn.userInteractionEnabled = NO;
        [_authoriseBtn setTitle:@"已完成" forState:UIControlStateNormal];
//        [_authoriseBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        [_authoriseBtn setBackgroundImage:SHImageNamed(@"redpocketReleasedState") forState:UIControlStateNormal];
    }
    
    if (model.isSkill == 0) {
        [_skillBtn setTitle:@"去发布" forState:UIControlStateNormal];
        [_skillBtn setBackgroundImage:SHImageNamed(@"redpocketUnReleaseState") forState:UIControlStateNormal];
//        [_skillBtn setBackgroundColor:SHColorFromHex(0xc63c23)];
    } else if (model.isSkill == 1) {
        [_skillBtn setTitle:@"领红包" forState:UIControlStateNormal];
//        [_skillBtn setBackgroundColor:SHColorFromHex(0x53a949)];
        [_skillBtn setBackgroundImage:SHImageNamed(@"redpocketPickState") forState:UIControlStateNormal];
    } else if (model.isSkill == 2) {
        _skillBtn.userInteractionEnabled = NO;
        [_skillBtn setTitle:@"已完成" forState:UIControlStateNormal];
//        [_skillBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        [_skillBtn setBackgroundImage:SHImageNamed(@"redpocketReleasedState") forState:UIControlStateNormal];
    }
    
    if (model.isShopping == 0) {
        [_shopBtn setTitle:@"去交易" forState:UIControlStateNormal];
        [_shopBtn setBackgroundImage:SHImageNamed(@"redpocketUnReleaseState") forState:UIControlStateNormal];
//        [_shopBtn setBackgroundColor:SHColorFromHex(0xc63c23)];
    } else if (model.isShopping == 1) {
        [_shopBtn setTitle:@"领红包" forState:UIControlStateNormal];
//        [_shopBtn setBackgroundColor:SHColorFromHex(0x53a949)];
        [_shopBtn setBackgroundImage:SHImageNamed(@"redpocketPickState") forState:UIControlStateNormal];
    } else if (model.isShopping == 2) {
        _shopBtn.userInteractionEnabled = NO;
        [_shopBtn setTitle:@"已领取" forState:UIControlStateNormal];
//        [_shopBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        [_shopBtn setBackgroundImage:SHImageNamed(@"redpocketReleasedState") forState:UIControlStateNormal];
    }
    
    if (model.isShare == model.leftShareNum) {
        _shareBtn.userInteractionEnabled = NO;
        [_shareBtn setTitle:@"已完成" forState:UIControlStateNormal];
//        [_shareBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        [_shareBtn setBackgroundImage:SHImageNamed(@"redpocketReleasedState") forState:UIControlStateNormal];
    } else {
        [_shareBtn setTitle:@"去分享" forState:UIControlStateNormal];
//        [_shareBtn setBackgroundColor:SHColorFromHex(0xc63c23)];
        [_shareBtn setBackgroundImage:SHImageNamed(@"redpocketUnReleaseState") forState:UIControlStateNormal];
    }
    
    if (model.isSignIn == 0) {
        [_signBtn setTitle:@"去签到" forState:UIControlStateNormal];
//        [_signBtn setBackgroundColor:SHColorFromHex(0xc63c23)];
        [_signBtn setBackgroundImage:SHImageNamed(@"redpocketUnReleaseState") forState:UIControlStateNormal];
    } else if (model.isSignIn == 2) {
        _signBtn.userInteractionEnabled = NO;
        [_signBtn setTitle:@"已领取" forState:UIControlStateNormal];
//        [_signBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        [_signBtn setBackgroundImage:SHImageNamed(@"redpocketReleasedState") forState:UIControlStateNormal];
    }
    
    _registerL.text = [NSString stringWithFormat:@"\(完成可领取%.2f元\)", model.registeredMoney];
    _authoriseL.text = [NSString stringWithFormat:@"\(完成可领取%.2f元\)", model.authMoney];
    _skillL.text = [NSString stringWithFormat:@"\(完成可领取%.2f元\)", model.skillMoney];
    _shopL.text = [NSString stringWithFormat:@"\(消费额高于50元的订单即可领取%.2f元\)", model.shoppingMoney];
    //_shareL.text = [NSString stringWithFormat:@"\(每日分享完成%d\/%d\)", model.isShare, model.leftShareNum];
    _signinL.text = [NSString stringWithFormat:@"\(每次%.2f元\)", model.signInMoney];
}


#pragma mark - function
//注册
- (IBAction)registerBtnClick:(UIButton *)sender {
    SHWeakSelf
    if (_welfareModel.isRegistered == 0) {
        //领红包
        
        
    } else if (_welfareModel.isRegistered == 1) {
        //领红包
        SHRedPackageV *redV = [[SHRedPackageV alloc] init];
        redV.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _welfareModel.registeredMoney];
        [redV.button setTitle:@"领取注册红包" forState:UIControlStateNormal];
        redV.redPacBlock = ^(NSString *buttonTitle) {
            [weakSelf getRedMoneyWithString:buttonTitle];
        };
        [redV showRedPackageView];
    } else if (_welfareModel.isRegistered == 2) {
        _registBtn.userInteractionEnabled = NO;
        [_registBtn setTitle:@"已领取" forState:UIControlStateNormal];
//        [_registBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        [_registBtn setBackgroundImage:SHImageNamed(@"redpocketReleasedState") forState:UIControlStateNormal];
        
    }
    
    
    
}

//实名认证
- (IBAction)authoriseBtnClick:(UIButton *)sender {
    SHWeakSelf
    if (_welfareModel.isAuth == 0) {
        SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_welfareModel.isAuth == 1) {
        //领红包
        SHRedPackageV *redV = [[SHRedPackageV alloc] init];
        redV.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _welfareModel.authMoney];
        [redV.button setTitle:@"领取实名红包" forState:UIControlStateNormal];
        redV.redPacBlock = ^(NSString *buttonTitle) {
            [weakSelf getRedMoneyWithString:buttonTitle];
        };
        [redV showRedPackageView];
    } else if (_welfareModel.isAuth == 2) {
        _authoriseBtn.userInteractionEnabled = NO;
        [_authoriseBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [_authoriseBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
    }
}

//发布技能
- (IBAction)skillBtnClick:(UIButton *)sender {
    SHWeakSelf
    SHLog(@"点击发布技能")
    if (_welfareModel.isSkill == 0) {
        //先实名认证
        [self checkAuthoriseSkill];

    } else if (_welfareModel.isSkill == 1) {
        //领红包
        SHRedPackageV *redV = [[SHRedPackageV alloc] init];
        redV.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _welfareModel.skillMoney];
        [redV.button setTitle:@"领取发布技能红包" forState:UIControlStateNormal];
        redV.redPacBlock = ^(NSString *buttonTitle) {
            [weakSelf getRedMoneyWithString:buttonTitle];
        };
        [redV showRedPackageView];
    } else if (_welfareModel.isSkill == 2) {
        _skillBtn.userInteractionEnabled = NO;
        [_skillBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [_skillBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
    }

    
}

//交易
- (IBAction)shopBtnClick:(UIButton *)sender {
    SHWeakSelf
    //弹框显示去首页分类中完成一次交易大于50元的服务即可
    if (_welfareModel.isShopping == 0) {
        SHRFindServiceVController *vc = [[SHRFindServiceVController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_welfareModel.isShopping == 1) {
        //领红包
        SHRedPackageV *redV = [[SHRedPackageV alloc] init];
        redV.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _welfareModel.shoppingMoney];
        [redV.button setTitle:@"领取交易红包" forState:UIControlStateNormal];
        redV.redPacBlock = ^(NSString *buttonTitle) {
            [weakSelf getRedMoneyWithString:buttonTitle];
        };
        [redV showRedPackageView];
    } else if (_welfareModel.isShopping == 2) {
        _shopBtn.userInteractionEnabled = NO;
        [_shopBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [_shopBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
    }
    
}

//分享
- (IBAction)shareBtnClick:(UIButton *)sender {
    if (_welfareModel.isShare != _welfareModel.leftShareNum) {
        SHGetRedPackageVController *vc = [[SHGetRedPackageVController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//签到
- (IBAction)signInBtnClick:(UIButton *)sender {
    if (_welfareModel.isSignIn == 0) {
        SHSigninViewController *vc = [[SHSigninViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 领取红包
- (void)getRedMoneyWithString:(NSString *)string
{
    /**
        SIGN_IN//签到 REGISTER//注册 NAME_Certification,//实名认证 SKILL_Certification,//技能认证
     **/
    if ([string isEqualToString:@"领取注册红包"]) {
        SHLog(@"领取注册红包")
        [self getRedMoneyDataWithType:SHRegisterRedPackageType];
    } else if ([string isEqualToString:@"领取实名红包"]) {
        SHLog(@"领取实名红包")
        [self getRedMoneyDataWithType:SHAuthoriseRedPackageType];
    } else if ([string isEqualToString:@"领取发布技能红包"]) {
        SHLog(@"领取发布技能红包")
        [self getRedMoneyDataWithType:SHSkillRedPackageType];
    } else if ([string isEqualToString:@"领取交易红包"]) {
        SHLog(@"领取交易红包")
        [self getRedMoneyDataWithType:SHShoppRedPackageType];
    }
}

- (void)getRedMoneyDataWithType:(SHRedPackageAllType)type
{
    /**
     SIGN_IN,//签到
     REGISTER,//注册
     LOGIN,//登陆
     SHARE,//分享
     NAME_Certification,//实名认证
     //SKILL_Certification,//技能认证
     CREATE_SERVER,//创建服务
     CREATE_ORDER,//创建订单
     ADDRESS_BOOK,//通讯录
     **/
    SHWeakSelf
    NSDictionary *dic = nil;
    if (type == SHRegisterRedPackageType) {
        dic = @{
                @"type":@"REGISTER"
                };
    } else if (type == SHAuthoriseRedPackageType) {
        dic = @{
                @"type":@"NAME_Certification"
                };
    } else if (type == SHSkillRedPackageType) {
        dic = @{
                @"type":@"CREATE_SERVER"
                };
    } else if (type == SHShoppRedPackageType) {
        dic = @{
                @"type":@"CREATE_ORDER"
                };
    } else if (type == SHShareRedPackageType) {
        dic = @{
                @"type":@"SHARE"
                };
    }
    SHLog(@"%@", dic)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHSignInGetMoneyUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [weakSelf voiceShowMoneyWithType:type];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 *  语音提示领取红包
 */
- (void)voiceShowMoneyWithType:(SHRedPackageAllType)type
{
    NSString *string = nil;
    if (type == SHRegisterRedPackageType) {
        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
        [player setDefaultWithVolume:SH_AppDelegate.personInfo.volume rate:0.4 pitchMultipier:-1.0];
        string = [NSString stringWithFormat:@"您已领取注册红包%.2f元", _welfareModel.registeredMoney];
        [player play:string];
        [_registBtn setTitle:@"已领取" forState:UIControlStateNormal];
        _registBtn.userInteractionEnabled = NO;
        [_registBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
    } else if (type == SHAuthoriseRedPackageType) {
        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
        [player setDefaultWithVolume:SH_AppDelegate.personInfo.volume rate:0.4 pitchMultipier:-1.0];
        string = [NSString stringWithFormat:@"您已领取实名红包%.2f元", _welfareModel.authMoney];
        [player play:string];
        [_authoriseBtn setTitle:@"已领取" forState:UIControlStateNormal];
        _authoriseBtn.userInteractionEnabled = NO;
        [_authoriseBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
    } else if (type == SHSkillRedPackageType) {
        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
        [player setDefaultWithVolume:SH_AppDelegate.personInfo.volume rate:0.4 pitchMultipier:-1.0];
        string = [NSString stringWithFormat:@"您已领取发布技能红包%.2f元", _welfareModel.skillMoney];
        [player play:string];
        [_skillBtn setTitle:@"已领取" forState:UIControlStateNormal];
        _skillBtn.userInteractionEnabled = NO;
        [_skillBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
    } else if (type == SHShoppRedPackageType) {
        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
        [player setDefaultWithVolume:SH_AppDelegate.personInfo.volume rate:0.4 pitchMultipier:-1.0];
        string = [NSString stringWithFormat:@"您已领取交易红包%.2f元", _welfareModel.shoppingMoney];
        [player play:string];
        _shopBtn.userInteractionEnabled = NO;
        [_shopBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [_shopBtn setBackgroundColor:SHColorFromHex(0x9a9a9a)];
    } else if (type == SHShareRedPackageType) {
        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
        [player setDefaultWithVolume:SH_AppDelegate.personInfo.volume rate:0.4 pitchMultipier:-1.0];
//        string = [NSString stringWithFormat:@"您已领取分享红包%.2f", _welfareModel.];
        [player play:@"分享红包领取成功"];
    }
    
    
}

#pragma mark - 技能认证
- (void)checkAuthoriseSkill
{
    SHWeakSelf
    SHLog(@"%d", SH_AppDelegate.personInfo.isVerified)
    if (SH_AppDelegate.personInfo.isVerified == 0) {
        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您需要认证审核，才能发布技能!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *act2=[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [controller addAction:act1];
        [controller addAction:act2];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    } else if (SH_AppDelegate.personInfo.isVerified == 1) {
        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您的身份认证正在审核中，审核通过之后才能发布技能!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [controller addAction:act1];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    } else if (SH_AppDelegate.personInfo.isVerified == 2) {//成功
        SHRReleaseViewController *vc = [[SHRReleaseViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (SH_AppDelegate.personInfo.isVerified == 3) {//失败
        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您的实名认证失败，请重新认证!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *act2=[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [controller addAction:act1];
        [controller addAction:act2];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
