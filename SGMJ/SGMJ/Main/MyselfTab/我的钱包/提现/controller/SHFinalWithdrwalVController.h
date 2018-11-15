//
//  SHFinalWithdrwalVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/22.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"

@class SHBankInfoModel;
@interface SHFinalWithdrwalVController : ViewController


@property (nonatomic, assign) SHWithdrawlType moneyType;
@property (nonatomic, strong) SHBankInfoModel *bankModel;

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *area;

@end
