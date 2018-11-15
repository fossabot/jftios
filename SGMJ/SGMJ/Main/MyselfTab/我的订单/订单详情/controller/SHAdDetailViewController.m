//
//  SHAdDetailViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/1.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAdDetailViewController.h"
#import "SHOrderListModel.h"
#import "SHMyOrderDetailModel.h"
#import "SHApplySkillVController.h"
#import "SHPayOrderVController.h"

@interface SHAdDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftButtonClick;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


@property (nonatomic, strong) SHMyOrderDetailModel *detailModel;

@end

@implementation SHAdDetailViewController


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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    
    [self loadDetailData];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"订单详情";
    
    self.view.backgroundColor = SHColorFromHex(0xf2f2f2);
    
    //定制右按钮
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc] initWithTitle:@"投诉" style:UIBarButtonItemStyleDone target:self action:@selector(feedBackAboutOrder)];
    [barBut setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:13.0],NSFontAttributeName,SHColorFromHex(0xe9aa5b),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = barBut;
    
    
    
}

//投诉
- (void)feedBackAboutOrder
{
    SHApplySkillVController *vc = [[SHApplySkillVController alloc] init];
    vc.type = SHFeedBackType;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loadDetailData
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_adModel.orderNo
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHOrderDetailUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            _detailModel = [SHMyOrderDetailModel mj_objectWithKeyValues:JSON[@"details"]];
            
            [weakSelf dealWithModel:_detailModel];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)dealWithModel:(SHMyOrderDetailModel *)model
{
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:model.userData[@"avatar"]] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameLabel.text = model.userData[@"nickName"];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.goodsData[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _adTitleLabel.text = model.goodsData[@"category"];
    _profitLabel.text = [NSString stringWithFormat:@"%@元", model.goodsData[@"profit"]];
    _totalNumLabel.text = [NSString stringWithFormat:@"投放%@份", model.goodsData[@"amount"]];
    
    _orderNoLabel.text = model.orderNo;
    _orderTimeLabel.text = model.orderCreateTime;
    _goodNameLabel.text = model.productName;
    
    if ([model.orderStatus isEqualToString:@"INIT"]) {
        _leftButtonClick.hidden = NO;
        _rightButton.hidden = NO;
    } else {
        _leftButtonClick.hidden = YES;
        _rightButton.hidden = YES;
    }
    
}


- (IBAction)contactButtonClick:(UIButton *)sender {
    
    [self callPhoneStr:_detailModel.userData[@"mobile"]];
    
}

- (IBAction)cancelButtonClick:(UIButton *)sender {
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_detailModel.orderNo
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHCancelOrderUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"取消成功" withSecond:2.0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadOrderList" object:nil];
        } else {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

- (IBAction)payButtonClick:(UIButton *)sender {
    SHPayOrderVController *vc = [[SHPayOrderVController alloc] init];
    vc.orderNo = _detailModel.orderNo;
    [self.navigationController pushViewController:vc animated:YES];
    
}




#pragma amrk - 拨打电话
-(void)callPhoneStr:(NSString*)phoneStr  {
    NSString *str2 = [[UIDevice currentDevice] systemVersion];
    
    if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
    {
        NSLog(@">=10.2");
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"是否拨打电话" preferredStyle:UIAlertControllerStyleAlert];
        
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












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
