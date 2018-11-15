//
//  SHWidrawlMoneyVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/21.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"


@class SHBankInfoModel;
@interface SHWidrawlMoneyVController : ViewController


@property (nonatomic, assign) SHWithdrawlType withdrawlType;
@property (nonatomic, strong) SHBankInfoModel *bankModel;

@property (nonatomic, copy) NSString *area;         //城市
@property (nonatomic, copy) NSString *bankName;     //银行名称


@end
