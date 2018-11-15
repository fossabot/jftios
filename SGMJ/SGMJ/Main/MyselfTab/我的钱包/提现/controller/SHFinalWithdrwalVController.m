//
//  SHFinalWithdrwalVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/22.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHFinalWithdrwalVController.h"
#import "SHBankInfoModel.h"

@interface SHFinalWithdrwalVController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bankImgV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameL;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *moneyLeftL;
@property (weak, nonatomic) IBOutlet UIButton *widrwalButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;




@end

@implementation SHFinalWithdrwalVController

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
    
    
}

- (void)initBaseInfo
{
    if (self.moneyType == SHMyWalletLeftMoneyType) {
        self.navigationItem.title = @"零钱提现";
    } else if (self.moneyType == SHRedPackageLeftMoneyType) {
        self.navigationItem.title = @"红包提现";
    }
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _infoView.layer.cornerRadius = 10;
    _infoView.clipsToBounds = YES;
    _widrwalButton.layer.cornerRadius = _widrwalButton.height / 2;
    _widrwalButton.clipsToBounds = YES;
    
    _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyTF.delegate = self;
    [_bankImgV sd_setImageWithURL:[NSURL URLWithString:_bankModel.bank_logo] placeholderImage:[UIImage imageNamed:@"bankImage"]];
    _bankNameL.text = _bankModel.bank_name;
    
    if (self.moneyType == SHMyWalletLeftMoneyType) {
        _moneyLeftL.text = [NSString stringWithFormat:@"零钱余额：￥%.2f", SH_AppDelegate.personInfo.balance];
    } else if (self.moneyType == SHRedPackageLeftMoneyType) {
        _moneyLeftL.text = [NSString stringWithFormat:@"红包余额：￥%.2f", SH_AppDelegate.personInfo.redCash];
    }
    
}


- (IBAction)widrwalButtonClick:(UIButton *)sender {
    [_moneyTF resignFirstResponder];
    
    if ([NSString isEmpty:_moneyTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入金额" withSecond:2.0];
        return;
    }
    
    NSDictionary *dict = nil;
    if (self.moneyType == SHMyWalletLeftMoneyType) {
        dict = @{
                 @"type":@"balance",
                 @"money":_moneyTF.text,
                 @"realName":SH_AppDelegate.personInfo.realName ? SH_AppDelegate.personInfo.realName : @"",
                 @"mobile":_phone,
                 @"bankName":_bankModel.bank_name,
                 @"cardNo":_bankModel.bankno,
                 @"area":_area,
                 @"bankDetail":_bankName
                 };
    } else if (self.moneyType == SHRedPackageLeftMoneyType) {
        dict = @{
                 @"type":@"redCash",
                 @"money":_moneyTF.text,
                 @"realName":SH_AppDelegate.personInfo.realName ? SH_AppDelegate.personInfo.realName : @"",
                 @"mobile":_phone,
                 @"bankName":_bankModel.bank_name,
                 @"cardNo":_bankModel.bankno,
                 @"area":_area,
                 @"bankDetail":_bankName
                 };
    }
    SHLog(@"%@", dict)
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHWithdrwalMoneyUrl params:dict success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}




#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextView *)textView
{
    SHLog(@"%@", textView.text)
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _moneyTF) {
        NSString *text             = _moneyTF.text;
        NSString *decimalSeperator = @".";
        NSCharacterSet *charSet    = nil;
        NSString *numberChars      = @"0123456789";
        
        if ([string isEqualToString:decimalSeperator] && [text length] == 0) {
            return NO;
        }
        
        NSRange decimalRange = [text rangeOfString:decimalSeperator];
        BOOL isDecimalNumber = (decimalRange.location != NSNotFound);
        if (isDecimalNumber) {
            charSet = [NSCharacterSet characterSetWithCharactersInString:numberChars];
            if ([string rangeOfString:decimalSeperator].location != NSNotFound) {
                return NO;
            }
        }
        else {
            numberChars = [numberChars stringByAppendingString:decimalSeperator];
            charSet = [NSCharacterSet characterSetWithCharactersInString:numberChars];
        }
        
        NSCharacterSet *invertedCharSet = [charSet invertedSet];
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:invertedCharSet];
        text = [text stringByReplacingCharactersInRange:range withString:trimmedString];
        
        if (isDecimalNumber) {
            NSArray *arr = [text componentsSeparatedByString:decimalSeperator];
            if ([arr count] == 2) {
                if ([arr[1] length] > 2) {
                    return NO;
                }
            }
        }
        
        textField.text = text;
    } else {
        return YES;
    }
    return NO;
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
