//
//  Myself_ViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "Myself_ViewController.h"
#import "SHOrderStatuesCell.h"

#import "SHLoginViewController.h"
#import "SHSettingViewController.h"
#import "SHPersonalInfoVController.h"
#import "SHMyCouponsVController.h"
#import "SHMyWalletVController.h"
#import "SHInfluenceVController.h"
#import "SHMyReleaseVController.h"
#import "SHMyCollectionVController.h"
#import "SHGetRedPackageVController.h"

#import "SHMyWelfareViewController.h"
#import "SHVerifyIDViewController.h"
#import "SHModifyInfoVController.h"
#import "SHSigninViewController.h"
#import "SHMyOrderCenterVController.h"

#import "SHOrderListViewController.h"

#import "SHMySkillViewController.h"

#import "SHMyCenterModel.h"
#import "SHWelfareCenterVController.h"
#import "SHApplySkillVController.h"

#import "SHFollowFansViewController.h"
#import "SHMyEvaluateViewController.h"


static NSInteger sectionHeight = 13;
static NSString *orderID = @"SHOrderStatuesCell";
@interface Myself_ViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIView *focusView;


@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *sectionOneArray;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *sectionTwoArray;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *sectionThrArray;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *sectionForArray;

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;           //昵称nickname
@property (weak, nonatomic) IBOutlet UILabel *signetureL;       //介绍introduce
@property (weak, nonatomic) IBOutlet UILabel *focusL;//关注
@property (weak, nonatomic) IBOutlet UILabel *fansL;//粉丝
@property (weak, nonatomic) IBOutlet UIImageView *authorImgV;//认证成功


@property (weak, nonatomic) IBOutlet UILabel *authorAlertL;
@property (weak, nonatomic) IBOutlet UIButton *authorButton;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightLayoutConstraint;

@property (nonatomic, strong) SHMyCenterModel *myCenterModel;

@property (weak, nonatomic) IBOutlet UILabel *yueLabel;



@end

@implementation Myself_ViewController

- (void)dealloc
{
    //移除观察者，Observer不能为nil
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (!SH_AppDelegate.isPersonLogin) {
        self.phoneL.text = @"您还未登录，点击头像进行登录！";
        self.signetureL.hidden = YES;
        self.authorImgV.hidden = YES;
        _authorAlertL.hidden = YES;
        _authorLabel.hidden = YES;
        _authorButton.hidden = YES;
    } else {
        _weightLayoutConstraint.constant = - (_authorButton.width + 12) / 2;
        self.signetureL.hidden = NO;
        _authorAlertL.hidden = NO;
        _authorLabel.hidden = NO;
        _authorButton.hidden = NO;
    }
    
    if (SH_AppDelegate.personInfo.isVerified == 0) {
        
    } else if (SH_AppDelegate.personInfo.isVerified == 1) {
        [_authorButton setTitle:@"实名审核中" forState:UIControlStateNormal];
    } else if (SH_AppDelegate.personInfo.isVerified == 2) {
        _authorLabel.hidden = YES;
        _authorAlertL.hidden = YES;
        _authorButton.hidden = YES;
        _authorImgV.hidden = NO;
        _authorImgV.image = [UIImage imageNamed:@"certified"];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    //监听登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNoti:) name:@"LoginSuccess" object:nil];
    //退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessNoti:) name:@"SHLogoutSuccess" object:nil];
    
    if (SH_AppDelegate.isPersonLogin) {
        //个人主页相关数据
        [self loadMyCenterData];
    }
    
    //self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    self.edgesForExtendedLayout = UIRectEdgeNone;// 推荐使用
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"RedPackageNoti" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMineInfo) name:kNotificationMineRefresh object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyInfomation) name:@"modifyInfo" object:nil];
    
}

- (void)receiveNoti:(NSNotification *)noti
{
    SHLog(@"%@", noti.userInfo[@"key"])
    if ([noti.userInfo[@"key"] isEqualToString:@"NAME_Certification"]) {
        [self loadMyCenterData];
    }
}

- (void)refreshMineInfo
{
    if (SH_AppDelegate.isPersonLogin) {
        //个人主页相关数据
        [self loadMyCenterData];
    }
}

//修改个人信息
- (void)modifyInfomation
{
    _phoneL.text = SH_AppDelegate.personInfo.nickName;
    _signetureL.text = SH_AppDelegate.personInfo.introduce;
    
}

- (void)initBaseInfo {
    self.navigationItem.title = @"我的";
    
    _headImgV.layer.cornerRadius = _headImgV.height / 2;
    _headImgV.clipsToBounds = YES;
    
    UIColor *color = [UIColor whiteColor];
    _focusView.backgroundColor = [color colorWithAlphaComponent:0.2];
    
    _tableView.tableHeaderView = _headView;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:orderID bundle:nil] forCellReuseIdentifier:orderID];
    
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"关注" style:UIBarButtonItemStyleDone target:self action:@selector(myFocusFunction)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    //添加手势
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalInfoFunction:)];
    tapRecognize.numberOfTapsRequired = 1;
    tapRecognize.delegate = self;
    [tapRecognize delaysTouchesBegan];
    [tapRecognize cancelsTouchesInView];
    [_headView addGestureRecognizer:tapRecognize];
    
    [_authorButton setTitleColor:navColor forState:UIControlStateNormal];
    _authorLabel.backgroundColor = navColor;
    
    
    SHLog(@"%@-%@", SH_AppDelegate.personInfo.avatar, SH_AppDelegate.personInfo.introduce)
    self.phoneL.text = SH_AppDelegate.personInfo.nickName;
    self.signetureL.text = SH_AppDelegate.personInfo.introduce;
    self.focusL.text = [NSString stringWithFormat:@"关注 %ld", (long)SH_AppDelegate.userData.followNum];
    self.fansL.text = [NSString stringWithFormat:@"粉丝 %ld", (long)SH_AppDelegate.userData.fansNum];
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:SH_AppDelegate.personInfo.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    
    //显示认证成功之后的图片
    
    
}

//个人接口
- (void)loadMyCenterData
{
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMyCenterUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            _myCenterModel = [SHMyCenterModel mj_objectWithKeyValues:JSON];
            _signetureL.text = _myCenterModel.user[@"introduce"];
            _focusL.text = [NSString stringWithFormat:@"关注：%d", _myCenterModel.followNum];
            _fansL.text = [NSString stringWithFormat:@"粉丝：%d", _myCenterModel.fansNum];
            
//            _yueLabel.text = [NSString stringWithFormat:@"余额：￥%.2f", [_myCenterModel.balance doubleValue]];
            _yueLabel.text = [NSString stringWithFormat:@"余额：%.2f元", (double)_myCenterModel.balance];
            SHLog(@"%@", _myCenterModel.user[@"isVerified"])
            SHLog(@"%d", [_myCenterModel.user[@"isVerified"] integerValue])
            SH_AppDelegate.personInfo.isVerified = [_myCenterModel.user[@"isVerified"] integerValue];
            SH_AppDelegate.personInfo.realName = _myCenterModel.user[@"realName"];
            
            if (SH_AppDelegate.personInfo.isVerified == 0) {
                _authorImgV.hidden = YES;
            } else if (SH_AppDelegate.personInfo.isVerified == 1) {
                [_authorButton setTitle:@"实名审核中" forState:UIControlStateNormal];
            } else if (SH_AppDelegate.personInfo.isVerified == 2) {
                _authorLabel.hidden = YES;
                _authorAlertL.hidden = YES;
                _authorButton.hidden = YES;
                _authorImgV.hidden = NO;
                _authorImgV.image = [UIImage imageNamed:@"certified"];
            }
            SH_AppDelegate.personInfo.waitPayNum = _myCenterModel.initNum;
            SH_AppDelegate.personInfo.waitSerNum = _myCenterModel.receiveNum;
            SH_AppDelegate.personInfo.waitSureNum = _myCenterModel.confirmNum;
            SH_AppDelegate.personInfo.waitEvaNum = _myCenterModel.evaluationNum;
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}


/**
 *  监测用户的实名认证进展
 */
- (void)checkIsOrNotAuthorised
{
    if (SH_AppDelegate.isPersonLogin) {
        //登录    -- 监测是否实名认证
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHCheckAuthoriseUrl params:nil success:^(id JSON, int code, NSString *msg) {
            SHLog(@"%d", code)
            SHLog(@"%@", JSON)
            if (code == 0) {
                NSInteger status = [JSON[@"status"] integerValue];
                SH_AppDelegate.personInfo.isVerified = status;
            }
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        //未登录
        
    }
    
}


//立即实名
- (IBAction)authorButtonClick:(id)sender {
    SHLog(@"立即实名")
    
    if (SH_AppDelegate.isPersonLogin) {
        if (SH_AppDelegate.personInfo.isVerified == 0) {
            SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (SH_AppDelegate.personInfo.isVerified == 1) {
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您的身份认证正在审核中!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [controller addAction:act1];
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        } else if (SH_AppDelegate.personInfo.isVerified == 2) {
            
        }
    }
    
}
//关注
- (IBAction)followButtonClick:(id)sender {
//    SHLog(@"关注")
    SHFollowFansViewController *vc = [[SHFollowFansViewController alloc] init];
    vc.inType = SHFollowOtherType;
    vc.checkType = @"FOLLOW";
    [self.navigationController pushViewController:vc animated:YES];
    
    SHLog(@"测试银行")
    //确定请求路径
    //1.创建请求对象
//    NSURL *url = [NSURL URLWithString:@"http://app.shiguangmajia.com/index.php/app/Member/bankList"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    //获得回话对象
//    NSURLSession *session = [NSURLSession sharedSession];
//
//    //根据回话对象创建一个task发送请求
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error == nil) {
//            //解析服务器返回的数据
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            SHLog(@"%@", dict)
//        }
//    }];
//    [dataTask resume];
    
    
}
//粉丝
- (IBAction)fansButtonClick:(id)sender {
    SHLog(@"粉丝")
    SHFollowFansViewController *vc = [[SHFollowFansViewController alloc] init];
    vc.inType = SHFansPeopleType;
    vc.checkType = @"FAN";
    [self.navigationController pushViewController:vc animated:YES];
    
}


//通知--登录成功调用方法
- (void)loginSuccessNoti:(NSNotification *)noti
{
    //处理通知消息
    NSDictionary *dic = [noti userInfo];
    SHLog(@"通知传来的=%@", dic)
    
    NSDictionary *user = dic[@"user"];
//    NSDictionary *use
    [self.headImgV sd_setImageWithURL:SH_AppDelegate.personInfo.avatar placeholderImage:[UIImage imageNamed:@"defaultHead"] options:nil];
    self.phoneL.text = user[@"nickName"];
    self.signetureL.text = user[@"introduce"];
//    self.yueLabel.text = [NSString stringWithFormat:<#(nonnull NSString *), ...#>];
    //0：未申请 1：正在审核；2：成功 3：失败
    if (SH_AppDelegate.personInfo.isVerified == 0) {
        
    } else if (SH_AppDelegate.personInfo.isVerified == 1) {
        [_authorButton setTitle:@"实名审核中" forState:UIControlStateNormal];
    } else if (SH_AppDelegate.personInfo.isVerified == 2) {
        _authorLabel.hidden = YES;
        _authorAlertL.hidden = YES;
        _authorButton.hidden = YES;
    }
}

//通知--退出登录调用方法
- (void)logoutSuccessNoti:(NSNotification *)noti
{
    self.phoneL.text = @"您还未登录，点击头像进行登录！";
    self.signetureL.hidden = YES;
    self.authorImgV.hidden = YES;
    [self.headImgV sd_setImageWithURL:SH_AppDelegate.personInfo.avatar placeholderImage:[UIImage imageNamed:@"defaultHead"] options:nil];
    
    _focusL.text = @"关注：0";
    _fansL.text = @"粉丝：0";
    
    [_tableView reloadData];
    
}



#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _sectionOneArray.count + 1;
    } else if (section == 1) {
        return _sectionTwoArray.count;
    } else if (section == 2) {
        return _sectionThrArray.count;
    } else if (section == 3) {
        return _sectionForArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return _sectionOneArray[indexPath.row];
        } else if (indexPath.row == 1) {
            SHOrderStatuesCell *cellOne = [tableView dequeueReusableCellWithIdentifier:orderID];
            if (!cellOne) {
                cellOne = [[SHOrderStatuesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderID];
            }
            [cellOne setMyModel:_myCenterModel];
            
            return cellOne;
        }
    } else if (indexPath.section == 1) {
        return _sectionTwoArray[indexPath.row];
    } else if (indexPath.section == 2) {
        return _sectionThrArray[indexPath.row];
    } else if (indexPath.section == 3) {
        return _sectionForArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 73.5;
        } else {
            return 44;
        }
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self myOrderFunction];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {                       //签到
            SHLog(@"0")
            [self signInFunction];
        } else if (indexPath.row == 1) {                //天天领红包
            SHLog(@"1")
            [self getRedPackageFunction];
        } else if (indexPath.row == 2) {                //我的钱包
            SHLog(@"2")
            [self myWalletFunction];
        } else if (indexPath.row == 3) {                //优惠券
            SHLog(@"3")
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {                       //我的影响力
            [self myInfluenceFunction];
        } else if (indexPath.row == 1) {                //我的发布
            [self myReleaseFunction];
        } else if (indexPath.row == 2) {                //我的技能
            [self mySkillAuthoriseFunction];
        } else if (indexPath.row == 3) {                //我的评价
            [self myEvaluteFunction];
        }
//        else if (indexPath.row == 3) {
//            [self myMicrowelfareFunction];
//        }
//        else if (indexPath.row == 3) {                  //我的收藏
//            [self myCollectionFunction];
//        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {                       //客服热线
            [self customServiceFunction];
        } else if (indexPath.row == 1) {                //问题与建议
            [self questionAndSuggestionFunction];
        } else if (indexPath.row == 2) {                //设置
            [self settingFunction];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return sectionHeight;
}



#pragma mark - Function
//个人资料
- (void)personalInfoFunction:(UITapGestureRecognizer *)tap
{
    if (SH_AppDelegate.isPersonLogin) {
        SHWeakSelf
        SHPersonalInfoVController *vc = [[SHPersonalInfoVController alloc] init];
        vc.modifyBlock = ^(NSString *string) {
            [weakSelf.headImgV sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"default"] options:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SH_AppDelegate userLogin];
    }
    
}

//我的关注
- (void)myFocusFunction
{}

//我的订单
- (void)myOrderFunction
{
//    SHMyOrderCenterVController *vc = [[SHMyOrderCenterVController alloc] init];
    SHOrderListViewController *vc = [[SHOrderListViewController alloc] init];
//    vc.orderType = SHAllOrderType;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//签到
- (void)signInFunction
{
    if (SH_AppDelegate.isPersonLogin) {
        SHSigninViewController *vc = [[SHSigninViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SH_AppDelegate userLogin];
    }
}

//天天领红包
- (void)getRedPackageFunction
{
    if (SH_AppDelegate.isPersonLogin) {
        //SHGetRedPackageVController *vc = [[SHGetRedPackageVController alloc] init];
        SHWelfareCenterVController *vc = [[SHWelfareCenterVController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SH_AppDelegate userLogin];
    }
    
}


//我的钱包
- (void)myWalletFunction
{
    SHMyWalletVController *vc = [[SHMyWalletVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的优惠券
- (void)myConpousFunction
{
    SHMyCouponsVController *vc = [[SHMyCouponsVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的影响力
- (void)myInfluenceFunction
{
    SHInfluenceVController *vc = [[SHInfluenceVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的发布
- (void)myReleaseFunction
{
    SHMyReleaseVController *vc = [[SHMyReleaseVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//技能认证
- (void)mySkillAuthoriseFunction
{
    SHLog(@"技能认证")
    if (SH_AppDelegate.isPersonLogin) {
        SHMySkillViewController *vc = [[SHMySkillViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SH_AppDelegate userLogin];
    }
}

//我的评价
- (void)myEvaluteFunction
{
    SHLog(@"我的评价")
    SHMyEvaluateViewController *vc = [[SHMyEvaluateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的微公益
- (void)myMicrowelfareFunction
{
    SHMyWelfareViewController *vc = [[SHMyWelfareViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的收藏
- (void)myCollectionFunction
{
    SHMyCollectionVController *vc = [[SHMyCollectionVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//客服热线
- (void)customServiceFunction
{
    [self callPhoneStr:@"0551-69124125"];
}


//问题与建议
- (void)questionAndSuggestionFunction
{
    //SHModifyInfoVController *vc = [[SHModifyInfoVController alloc] init];
    //vc.modifyType = SHQuesAndSuggestType;
    SHApplySkillVController *vc = [[SHApplySkillVController alloc] init];
    vc.type = SHSuggestBackType;
    [self.navigationController pushViewController:vc animated:YES];
}

//设置
- (void)settingFunction
{
    SHSettingViewController *vc = [[SHSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)callPhoneStr:(NSString*)phoneStr  {
    NSString *str2 = [[UIDevice currentDevice] systemVersion];
    
    if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
    {
        NSLog(@">=10.2");
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        NSString * str = [NSString stringWithFormat:@"是否拨打客服电话\n%@",str1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    if (@available(iOS 10.0, *)) {
                        [app openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil                                                                                ];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];

    }else {
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"是否拨打客服热线" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    if (@available(iOS 10.0, *)) {
                        [app openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil                                                                                ];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}




#pragma mark - sectionView跟随tableview一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = sectionHeight;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
