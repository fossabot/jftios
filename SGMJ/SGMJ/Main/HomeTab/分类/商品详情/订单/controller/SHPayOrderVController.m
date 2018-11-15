//
//  SHPayOrderVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/3.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPayOrderVController.h"
#import "SHPaySelectView.h"
#import "SHOrderModel.h"
#import "SH_PayUtil.h"
#import "SHPaySuccessVController.h"
#import "Home_ViewController.h"
#import "SHPayPwdView.h"

@interface SHPayOrderVController ()

@property (nonatomic, assign) SH_PayUtilType curentPayType;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UILabel *paymoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *surePayButton;
@property (weak, nonatomic) IBOutlet UIImageView *payTypeImgV;

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@property (nonatomic, assign) double amount;
@property (nonatomic, strong) SHPayPwdView *payView;
@property (nonatomic, strong) NSString *payStr;             //支付凭证
@property (nonatomic, strong) NSString *psdString;

@property (nonatomic, copy) NSString *yue;

@property (nonatomic, strong) SHOrderModel *orderModel;


@end

@implementation SHPayOrderVController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //return
    //SHColorFromHex(0x00a9f0)
    //字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
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
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:kNotificationAliPayPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPaySuccess:) name:kNotificationWeiXinPayPaySuccess object:nil];
    
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

//支付宝支付成功通知
- (void)paySuccess:(NSNotification *)noti
{
    SHWeakSelf
    NSDictionary *dict = noti.userInfo;
    if ([dict[@"pay"] isEqualToString:@"AKIPAY"]) {
        NSDictionary *dic = @{
                              @"orderNo":_orderModel.orderNo
                              };
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHAlipaySuccessBackUrl params:dic success:^(id JSON, int code, NSString *msg) {
            
            if (code == 0) {
                NSInteger flag = [JSON[@"flag"] integerValue];
                if (flag == 2) {
                    [MBProgressHUD showMBPAlertView:@"支付成功!" withSecond:2.0];
                    
                    SHPaySuccessVController *vc = [[SHPaySuccessVController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    [MBProgressHUD showMBPAlertView:@"支付失败!" withSecond:2.0];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        } failure:^(NSError *error) {
            
        }];
    } else {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
    
}

//微信支付通知
- (void)weixinPaySuccess:(NSNotification *)noti
{
    SHWeakSelf
    NSDictionary *dict = noti.userInfo;
    if ([dict[@"pay"] isEqualToString:@"WEIXIN"]) {
        NSDictionary *dic = @{
                              @"orderNo":_orderModel.orderNo
                              };
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHWeiXinSuccessBackUrl params:dic success:^(id JSON, int code, NSString *msg) {
            
            if (code == 0) {
                NSInteger flag = [JSON[@"flag"] integerValue];
                if (flag == 2) {
                    [MBProgressHUD showMBPAlertView:@"支付成功！" withSecond:2.0];
                    SHPaySuccessVController *vc = [[SHPaySuccessVController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    [MBProgressHUD showMBPAlertView:@"支付失败！" withSecond:2.0];
                    SHLog(@"微信支付失败")
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        } failure:^(NSError *error) {
            
        }];
    } else {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPsdwordRequestWithPsdstring:) name:@"setPsdword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yueGoToPayWithPayStr:) name:@"payNoti" object:nil];
}



- (void)initBaseInfo
{
    self.navigationItem.title = @"付款";
    _firstView.layer.cornerRadius = 10;
    _firstView.clipsToBounds = YES;
    _secondView.layer.cornerRadius = 10;
    _secondView.clipsToBounds = YES;
    _surePayButton.layer.cornerRadius = _surePayButton.height / 2;
    _surePayButton.clipsToBounds = YES;
    [_surePayButton setBackgroundColor:navColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _curentPayType = kSH_PayUtilTypeYue;
    
    SHWeakSelf
    _payView = [[SHPayPwdView alloc] init];
    _payView.payBlock = ^(NSString *pwdString) {
        weakSelf.psdString = pwdString;
        SHLog(@"%@", weakSelf.psdString)
    };
}

- (void)loadData
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_orderNo
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHYueCheckUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            NSDictionary *amount = JSON[@"account"];
            weakSelf.yueLabel.text = [NSString stringWithFormat:@"可用余额%@元", amount[@"balance"]];
            weakSelf.yue = amount[@"balance"];
            weakSelf.amount = [amount[@"balance"] doubleValue];
            
            _orderModel = [SHOrderModel mj_objectWithKeyValues:JSON[@"order"]];
            _paymoneyLabel.text = [NSString stringWithFormat:@"￥%.2f元", [_orderModel.sumPrice doubleValue]];
            
        }
    } failure:^(NSError *error) {
        
    }];
}


- (IBAction)payTypeButtonClick:(UIButton *)sender {
    SHWeakSelf
    SHPaySelectView *payView = [[SHPaySelectView alloc] init];
    payView.payBlock = ^(SH_PayUtilType payType) {
        weakSelf.curentPayType = payType;
        //更换显示付款方式
        if (weakSelf.curentPayType == kSH_PayUtilTypeAlipay) {
            weakSelf.payTypeImgV.image = [UIImage imageNamed:@"zhifubaopay"];
            weakSelf.payTypeLabel.text = @"支付宝支付";
            weakSelf.yueLabel.text = @"可用";
        } else if (weakSelf.curentPayType == kSH_PayUtilTypeWXPay) {
            weakSelf.payTypeImgV.image = [UIImage imageNamed:@"weixinpay"];
            weakSelf.payTypeLabel.text = @"微信支付";
            weakSelf.yueLabel.text = @"可用";
        } else if (weakSelf.curentPayType == kSH_PayUtilTypeYue) {
            weakSelf.payTypeImgV.image = [UIImage imageNamed:@"yuezhifu"];
            weakSelf.payTypeLabel.text = @"余额支付";
            weakSelf.yueLabel.text = [NSString stringWithFormat:@"可用余额%@元", weakSelf.yue];
        }
        
        
    };
    [payView showView];
}

- (IBAction)payButtonClick:(UIButton *)sender {
    if (_curentPayType == kSH_PayUtilTypeAlipay) {
        [[SH_PayUtil sharedInstance] gotoPay:kSH_PayUtilTypeAlipay withPayMoney:0.01 withOrder:_orderModel];
    } else if (_curentPayType == kSH_PayUtilTypeWXPay) {
        SHLog(@"微信支付")
        [[SH_PayUtil sharedInstance] gotoPay:kSH_PayUtilTypeWXPay withPayMoney:0.01 withOrder:_orderModel];
    } else if (_curentPayType == kSH_PayUtilTypeYue) {
        SHLog(@"余额支付")
        
        if (_amount >= [_orderModel.sumPrice doubleValue]) {
            
            [self yuePayRequest];
        } else {
            [MBProgressHUD showMBPAlertView:@"余额不足，请选择其他支付方式" withSecond:2.0];
        }
        
    }
    
}

//获取凭条
- (void)yuePayRequest
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_orderModel.orderNo
                          };
    SHLog(@"%@", _orderModel.orderNo)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHYuePayRequestUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 100) {
            //设置支付密码
            [weakSelf.payView showPayPwdView];
        } else if (code == 0) {
            [weakSelf.payView showPayPwdView];
            weakSelf.payView.titleLabel.text = @"请输入支付密码";
            //支付结果
            weakSelf.payStr = JSON[@"payStr"];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//设置密码接口
- (void)setPsdwordRequestWithPsdstring:(NSNotification *)noti
{
    SHLog(@"%@", self.psdString)
    SHWeakSelf
    NSDictionary *dic = @{
                          @"pass":self.psdString,
                          @"confirmPass":self.psdString
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHYuePayPasswordUrl params:dic success:^(id JSON, int code, NSString *msg) {
        
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"支付密码设置成功" withSecond:2.0];
            weakSelf.payView.titleLabel.text = @"请输入支付密码";
            weakSelf.payView.tf1.text = @"";
            weakSelf.payView.tf2.text = @"";
            weakSelf.payView.tf3.text = @"";
            weakSelf.payView.tf4.text = @"";
            weakSelf.payView.tf5.text = @"";
            weakSelf.payView.tf6.text = @"";
            weakSelf.psdString = @"";
            
            [weakSelf yuePayRequest];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//余额支付
- (void)yueGoToPayWithPayStr:(NSNotification *)noti
{
    SHLog(@"%@", self.payStr)
    SHLog(@"%@", self.psdString)
    SHWeakSelf
    NSDictionary *dic = @{
                          @"payStr":self.payStr,
                          @"pass":self.psdString
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHYuePayUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"支付成功" withSecond:2.0];
            SHPaySuccessVController *vc = [[SHPaySuccessVController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (code == 500) {
            //weakSelf.payStr = @"";
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
