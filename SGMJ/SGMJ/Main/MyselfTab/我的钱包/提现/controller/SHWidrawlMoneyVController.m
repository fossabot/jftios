//
//  SHWidrawlMoneyVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/21.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHWidrawlMoneyVController.h"
#import "SHFinalWithdrwalVController.h"
#import "SHBankInfoModel.h"
#import "SHBankNameModel.h"
#import "SHCatagoryView.h"


@interface SHWidrawlMoneyVController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameL;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeL;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIButton *withdrwalButton;


@property (nonatomic, strong) NSMutableArray *bankNameArray;


@property (weak, nonatomic) IBOutlet UIButton *bankButton;
@property (nonatomic, strong) SHCatagoryView *catagoryView;




@end

@implementation SHWidrawlMoneyVController



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

- (NSMutableArray *)bankNameArray
{
    if (!_bankNameArray) {
        _bankNameArray = [NSMutableArray array];
    }
    return _bankNameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self initBankInfo];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"填写银行卡信息";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _bankNameL.text = _bankModel.bank_name;
    _cardTypeL.text = _bankModel.bankno;
    
    [_phoneTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    
    _infoView.layer.cornerRadius = 10;
    _infoView.clipsToBounds = YES;
    
    _withdrwalButton.layer.cornerRadius = _withdrwalButton.height / 2;
    _withdrwalButton.clipsToBounds = YES;
    
}


#pragma mark - 所在地区所有分行信息
- (void)initBankInfo
{
    //确定请求路径
//    1.创建请求对象
    //
    NSString *baseString = @"http://app.shiguangmajia.com/index.php/app/Member/getBankZhihang";
    NSString *allString = [NSString stringWithFormat:@"%@?qu=%@&bank=%@", baseString, _area, _bankName];
    
    
    NSString *newUrlString = nil;
    if (EL_IOS9) {  //9.0以上
        SHLog(@"ios 9.0以上的版本")
        newUrlString = [allString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else {        //9.0之前
        newUrlString = [allString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    SHLog(@"%@", newUrlString)
    NSURL *url = [NSURL URLWithString:newUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    
    //获得回话对象
    NSURLSession *session = [NSURLSession sharedSession];

    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //根据回话对象创建一个task发送请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (error == nil) {
            
            //解析服务器返回的数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //SHLog(@"%@", dict)
            
            NSDictionary *dataDic = dict[@"Data"];
            NSDictionary *listDic = dataDic[@"lists"];
            NSMutableArray *array = [SHBankNameModel mj_objectArrayWithKeyValuesArray:listDic];
            for (SHBankNameModel *model in array) {
                [weakSelf.bankNameArray addObject:model.value];
            }
            
        } else {
            SHLog(@"没有数据")
        }
    }];
    [MBProgressHUD hideHUDForView:self.view];
    [dataTask resume];
    
    
}

- (IBAction)bankButtonClick:(UIButton *)sender {
    [_phoneTF resignFirstResponder];
    
    if (self.bankNameArray) {
        SHWeakSelf
        _catagoryView = [[SHCatagoryView alloc] initWithArray:self.bankNameArray];
        _catagoryView.type = SHAdvertisementType;
        _catagoryView.catagoarySelectBlock = ^(NSString *leftString, NSString *rightString, NSString *string) {
            SHLog(@"%@_%@_%@", leftString, rightString, string)
            [weakSelf.bankButton setTitle:string forState:UIControlStateNormal];
            [weakSelf.bankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        };
        UIApplication *app = [UIApplication sharedApplication];
        [app.keyWindow addSubview:_catagoryView];
    } else {
        [MBProgressHUD showMBPAlertView:@"请返回上一页重新填写信息" withSecond:2.0];
    }
    
    
    
}


- (IBAction)withdrawalButtonClick:(UIButton *)sender {
    
    if ([self judgeAllParagramsUsed]) {
        
        SHFinalWithdrwalVController *vc = [[SHFinalWithdrwalVController alloc] init];
        vc.moneyType = self.withdrawlType;
        vc.bankModel = self.bankModel;
        vc.bankName = _bankButton.currentTitle;
        vc.area = _area;
        vc.phone = _phoneTF.text;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}


- (BOOL)judgeAllParagramsUsed
{
    if ([_bankButton.currentTitle isEqualToString:@"请选择开户支行"]) {
        [MBProgressHUD showMBPAlertView:@"请选择开户支行" withSecond:2.0];
        return NO;
    }
    
    if (![NSString isOKPhoneNumber:_phoneTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的手机号" withSecond:2.0];
        return NO;
    }
    
    return YES;
}







#pragma mark - UITextFieldDelegate
//位数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if ([textField isEqual:_phoneTF]) {
        return textField.text.length < SHPhoneLength;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self allTFResignFirstResponder];
    return YES;
}

- (void)allTFResignFirstResponder {
    [_phoneTF resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allTFResignFirstResponder];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
