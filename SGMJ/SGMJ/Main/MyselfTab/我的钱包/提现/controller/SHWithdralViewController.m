//
//  SHWithdralViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/21.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHWithdralViewController.h"
#import "SHBankInfoModel.h"
#import "SHWidrawlMoneyVController.h"
#import "SH_CitySelected.h"
#import "SHBankNameModel.h"
#import "SHCatagoryView.h"


@interface SHWithdralViewController ()

@property (weak, nonatomic) IBOutlet UIView *infoBgView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UITextField *bankNoTF;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (nonatomic, strong) SHBankInfoModel *bankModel;

@property (nonatomic, strong) SH_CitySelected *cityChoose;

@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, strong) NSMutableArray *bankNameArray;
@property (nonatomic, strong) SHCatagoryView *catagoryView;
@property (weak, nonatomic) IBOutlet UIButton *bankButton;



@end

@implementation SHWithdralViewController


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
    self.navigationItem.title = @"验证银行卡";
//    [_titleTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
   
    [_bankNoTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_nameTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    
    
    if (SH_AppDelegate.personInfo.isVerified == 2) {
        _nameTF.text = SH_AppDelegate.personInfo.realName;
        _nameTF.userInteractionEnabled = NO;
    } else {
        _nameTF.userInteractionEnabled = YES;
    }
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _infoBgView.layer.cornerRadius = 10;
    _infoBgView.clipsToBounds = YES;
    _nextButton.layer.cornerRadius = _nextButton.height / 2;
    _nextButton.clipsToBounds = YES;
    
    _bankButton.userInteractionEnabled = NO;
    
}

#pragma mark - 所有银行信息
- (void)initBankInfo
{
    NSString *allString = @"http://app.shiguangmajia.com/index.php/app/Member/bankList";
    NSURL *url = [NSURL URLWithString:allString];
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
            NSDictionary *dataDic = dict[@"data"];
            NSDictionary *listDict = dataDic[@"list"];
            NSMutableArray *array = [SHBankNameModel mj_objectArrayWithKeyValuesArray:listDict];
            //SHLog(@"%@", array)
            for (SHBankNameModel *model in array) {
                [weakSelf.bankNameArray addObject:model.value];
            }
            _bankButton.userInteractionEnabled = YES;
        }
    }];
    [MBProgressHUD hideHUDForView:self.view];
    [dataTask resume];
}


- (IBAction)cityButtonClick:(UIButton *)sender {
    [_nameTF resignFirstResponder];
    [_bankNoTF resignFirstResponder];
    
    SHWeakSelf
    self.cityChoose = [[SH_CitySelected alloc] init];
    self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town) {
        [weakSelf.cityButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", province, city, town] forState:UIControlStateNormal];
        [weakSelf.cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        weakSelf.city = city;
    };
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:self.cityChoose];
    
}

- (IBAction)bankButtonClick:(UIButton *)sender {
    
    SHWeakSelf
    if (self.bankNameArray) {
        
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
        [self initBankInfo];
    }
   
    
}


#pragma mark - 提现按钮
- (IBAction)nextButtonClick:(UIButton *)sender {
    if ([NSString isEmpty:_nameTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入提现姓名" withSecond:2.0];
        return;
    }
    
    if ([_bankButton.currentTitle isEqualToString:@"请选择所属银行"]) {
        [MBProgressHUD showMBPAlertView:@"请选择所属银行" withSecond:2.0];
        return;
    }
    
    if ([NSString isEmpty:_bankNoTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入银行卡号" withSecond:2.0];
        return;
    }
    if ([_cityButton.currentTitle isEqualToString:@"请选择开户城市"]) {
        [MBProgressHUD showMBPAlertView:@"请选择开户城市" withSecond:2.0];
        return;
    }
    
    
    SHWeakSelf
    NSString *appcode = @"2e66c825b30d4cdb94691dace1334b37";
    NSString *host = @"http://cardinfo.market.alicloudapi.com";
    NSString *path = @"/lianzhuo/querybankcard";
    NSString *method = @"GET";
    NSString *querys = [NSString stringWithFormat:@"?bankno=%@", _bankNoTF.text];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    NSString *bodys = @"";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       //SHLog(@"Response object: %@" , response);
                                                       NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                                                       
                                                       //打印应答中的body
                                                       SHLog(@"Response body: %@" , bodyString);
                                                       
                                                       if (bodyString) {
                                                           NSDictionary *content = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                                           SHLog(@"%@", content)
                                                           NSDictionary *dataDic = content[@"data"];
                                                           if (dataDic[@"bank_logo"]) {
                                                               SHLog(@"%@", dataDic[@"bank_logo"])
                                                               _bankModel = [SHBankInfoModel mj_objectWithKeyValues:dataDic];
                                                               SHLog(@"%@", _bankModel.bankno)
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [weakSelf dealWithBankModel:_bankModel];
                                                               });
                                                               
                                                           } else {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [MBProgressHUD showError:@"您输入的银行卡号不正确"];
                                                               });
                                                           }
                                                       } else {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [MBProgressHUD showError:@"请重新确认"];
                                                           });
                                                       }
                                                       
                                                       
                                                   }];
    
    [task resume];
    
}

#pragma mark - 处理银行信息
//6217 8563 0002 7478 471
- (void)dealWithBankModel:(SHBankInfoModel *)model
{
    SHWidrawlMoneyVController *vc = [[SHWidrawlMoneyVController alloc] init];
    vc.withdrawlType = self.moneyType;
    vc.bankModel = model;
    vc.area = self.city;
    vc.bankName = self.bankButton.currentTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMessage
{
    [MBProgressHUD showError:@"您输入的银行卡号不正确"];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
