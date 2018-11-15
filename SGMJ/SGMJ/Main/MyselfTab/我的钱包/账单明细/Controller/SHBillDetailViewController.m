//
//  SHBillDetailViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHBillDetailViewController.h"
#import "SHMoneyModel.h"

@interface SHBillDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderNoL;

@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@property (weak, nonatomic) IBOutlet UILabel *typeL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;



@end

@implementation SHBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"明细";
        
    if (_moneyModel.orderNo) {
        _orderNoL.text = _moneyModel.orderNo;
    } else {
        _orderNoL.text = @"无";
    }
    
    _moneyL.text = [NSString stringWithFormat:@"%.2f", _moneyModel.trxAmount];
    if ([_moneyModel.trxType isEqualToString:@"expend"]) {
        _typeL.text = @"支出";
    } else if ([_moneyModel.trxType isEqualToString:@"join"]) {
        _typeL.text = @"收入";
    }
    
    _timeL.text = _moneyModel.createTime;
    
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
