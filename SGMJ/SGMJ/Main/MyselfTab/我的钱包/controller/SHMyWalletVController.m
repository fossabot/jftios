//
//  SHMyWalletVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMyWalletVController.h"
#import "SHBillListVController.h"
#import "SHMyWalletModel.h"
#import "SHWithdralViewController.h"

@interface SHMyWalletVController ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//余额
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalButton;



@property (weak, nonatomic) IBOutlet UIImageView *imageV;//钱图像
@property (weak, nonatomic) IBOutlet UILabel *titleL;//钱类别
@property (weak, nonatomic) IBOutlet UIImageView *attImgV;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *walletBtn;
@property (weak, nonatomic) IBOutlet UIButton *redMoneyBtn;

@property (nonatomic, strong) UIButton *tempBtn;

@property (nonatomic, strong) SHMyWalletModel *walletModel;


@end

@implementation SHMyWalletVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    [self loadMyWalletMoneyData];
    
}

- (void)initBaseInfo
{
    //以下两行代码根据需要设置
    self.edgesForExtendedLayout = YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.title = @"我的钱包";
    _chargeButton.layer.cornerRadius = 10;
    _chargeButton.clipsToBounds = YES;
    _withdrawalButton.layer.cornerRadius = 10;
    _withdrawalButton.clipsToBounds = YES;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"零钱明细" style:UIBarButtonItemStyleDone target:self action:@selector(moneyDetailButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = navColor;
    [_btnBgView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_walletBtn.mas_left);
        make.top.mas_equalTo(_walletBtn.mas_bottom);
        make.width.mas_equalTo(_walletBtn.mas_width);
        make.height.mas_equalTo(2);
    }];
    
    
    _tempBtn = _walletBtn;
    [_walletBtn setTitleColor:navColor forState:UIControlStateNormal];
    
    _contentL.text = @"我的零钱提现需满50元";
    
}

//加载我的钱包数据
- (void)loadMyWalletMoneyData
{
    
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMyWalletUrl params:nil success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%d", code)
        SHLog(@"%@", JSON)
        if (code == 0) {
            NSDictionary *dic = JSON[@"account"];
            _walletModel = [SHMyWalletModel mj_objectWithKeyValues:dic];
            _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _walletModel.balance];
            SH_AppDelegate.personInfo.balance = _walletModel.balance;
            SH_AppDelegate.personInfo.redCash = _walletModel.redCash;
        }
    } failure:^(NSError *error) {
        
    }];
    
}






- (void)moneyDetailButton
{
    SHLog(@"零钱明细")
    SHBillListVController *vc = [[SHBillListVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)moneyBtnClick:(UIButton *)sender {
    SHWeakSelf
    if (sender == _tempBtn) {
        
    } else {
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tempBtn = sender;
        if (sender.tag == 10) {
            SHLog(@"adf")
            [UIView animateWithDuration:0.2 animations:^{
                _bottomView.frame = CGRectMake(_walletBtn.x, _walletBtn.height, _walletBtn.width, 2);
            }];
            _imageV.image = [UIImage imageNamed:@"money"];
            _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _walletModel.balance];
        } else {
            SHLog(@"qwerqwe")
            [UIView animateWithDuration:0.2 animations:^{
                _bottomView.frame = CGRectMake(SHScreenW / 2 + _redMoneyBtn.x, _redMoneyBtn.height, _redMoneyBtn.width, 2);
            }];
            _imageV.image = [UIImage imageNamed:@"redMoney"];
            _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", _walletModel.redCash];
            
        }
        
        [sender setTitleColor:navColor forState:UIControlStateNormal];
    }
    
    [self showWalletOrRedMoney:sender];
    
}

//零钱页面跟红包余额页面
- (void)showWalletOrRedMoney:(UIButton *)sender
{
    if (sender.tag == 10) {
        _contentL.text = @"我的零钱提现需满50元";
        _chargeButton.hidden = NO;
    } else if (sender.tag == 11) {
        _contentL.text = @"红包余额提现需满300元";
        
        _chargeButton.hidden = YES;
        
    }
}

//充值
- (IBAction)chargeBtnClick:(UIButton *)sender {
    SHLog(@"%d", _tempBtn.tag)
    if (_tempBtn.tag == 10) {
        
    } else if (_tempBtn.tag == 11) {
        
    }
}

//提现
- (IBAction)withdrawBtnClick:(UIButton *)sender {
    SHLog(@"%d", _tempBtn.tag)
    
    
    
    SHWithdralViewController *vc = [[SHWithdralViewController alloc] init];
    
    if (_tempBtn.tag == 10) {
        SHLog(@"我的零钱提现")
        
        if (_walletModel.balance < 50) {
            [MBProgressHUD showError:@"零钱余额大于50才能提现"];
            return;
        }
        vc.moneyType = SHMyWalletLeftMoneyType;
    } else if (_tempBtn.tag == 11) {
        SHLog(@"红包余额提现")
        
        if (_walletModel.redCash < 300) {
            [MBProgressHUD showError:@"红包余额大于300元时才能提现"];
            return;
        }
        
        vc.moneyType = SHRedPackageLeftMoneyType;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
//    if (SH_AppDelegate.personInfo.isVerified == 0) {
//        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您需要认证审核，才能发布技能!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        UIAlertAction *act2=[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
//            
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }];
//        [controller addAction:act1];
//        [controller addAction:act2];
//        [self presentViewController:controller animated:YES completion:^{
//            
//        }];
//    } else if (SH_AppDelegate.personInfo.isVerified == 1) {
//        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您的身份认证正在审核中，审核通过之后才能发布技能!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        [controller addAction:act1];
//        [self presentViewController:controller animated:YES completion:^{
//            
//        }];
//    } else if (SH_AppDelegate.personInfo.isVerified == 2) {//成功
//        SHWithdralViewController *vc = [[SHWithdralViewController alloc] init];
//        
//        if (_tempBtn.tag == 10) {
//            SHLog(@"我的零钱提现")
//            vc.moneyType = SHMyWalletLeftMoneyType;
//        } else if (_tempBtn.tag == 11) {
//            SHLog(@"红包余额提现")
//            vc.moneyType = SHRedPackageLeftMoneyType;
//        }
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if (SH_AppDelegate.personInfo.isVerified == 3) {//失败
//        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您的实名认证失败，请重新认证!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        UIAlertAction *act2=[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
//            
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }];
//        [controller addAction:act1];
//        [controller addAction:act2];
//        [self presentViewController:controller animated:YES completion:^{
//            
//        }];
//    }
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
