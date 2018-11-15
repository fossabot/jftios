//
//  SHRFindServiceVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/11.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHRFindServiceVController.h"
#import "SHRelCataModel.h"
#import "SHCatagoryView.h"
#import "SHLocationViewController.h"

@interface SHRFindServiceVController () <UITextViewDelegate, UITextFieldDelegate>
{
    CLLocationCoordinate2D _startPt;

}

@property (weak, nonatomic) IBOutlet UIButton *catagoryButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UITextField *serviceDayTF;
@property (weak, nonatomic) IBOutlet UITextField *aboutPriceTF;
@property (weak, nonatomic) IBOutlet UITextField *valueTimeTF;

@property (weak, nonatomic) IBOutlet UIButton *radiusButton;
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;
@property (weak, nonatomic) IBOutlet UITextView *addressDetailTF;
@property (weak, nonatomic) IBOutlet UILabel *addPlaceHolL;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (weak, nonatomic) IBOutlet UILabel *contentPlaceL;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic, strong) NSMutableArray *cataArray;    //分类数组
@property (nonatomic, strong) NSMutableDictionary *cataDict;//分类字典
@property (nonatomic, strong) SHCatagoryView *catagoryView;
@property (nonatomic, copy) NSString *catagoryString;
@property (nonatomic, copy) NSString *catagoaryLeftString;  //主分类选择的字符串
@property (nonatomic, copy) NSString *catagoaryRightString; //次分类字符串





@property (weak, nonatomic) IBOutlet UIButton *releaseButton;


@end

@implementation SHRFindServiceVController

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
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self loadCatagoaryData];
    
    
}


- (void)initBaseInfo
{
    self.navigationItem.title = @"发布需求";
    
    [_catagoryButton setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_catagoryButton setTitle:@"请选择分类" forState:UIControlStateNormal];
    [_radiusButton setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_radiusButton setTitle:@"请选择辐射范围" forState:UIControlStateNormal];
    [_serviceButton setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_serviceButton setTitle:@"请选择服务地址" forState:UIControlStateNormal];
    [_titleTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_serviceDayTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_aboutPriceTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_nameTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_valueTimeTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_releaseButton setBackgroundColor:navColor];
    _releaseButton.layer.cornerRadius = _releaseButton.height / 2;
    _releaseButton.clipsToBounds = YES;
    _phoneL.text = SH_AppDelegate.personInfo.mobile;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scrollView.contentSize = CGSizeMake(SHScreenW, _scrollView.height + 100);
    });
    
    
    _aboutPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    _aboutPriceTF.delegate = self;
    
    _cataArray = [NSMutableArray array];
    _cataDict = [NSMutableDictionary dictionary];
    
}

/**
 *  加载分类数据
 */
- (void)loadCatagoaryData
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaServCatUrl params:nil success:^(id JSON, int code, NSString *msg) {
        //        SHLog(@"%d", code)
        //SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (code == 0) {
            NSArray *array = [SHRelCataModel mj_objectArrayWithKeyValuesArray:JSON[@"categories"]];
            [_cataArray addObjectsFromArray:array];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (SHRelCataModel *model in array) {
                NSMutableArray *secondArr = [NSMutableArray array];
                for (NSDictionary *dictionary in model.childList) {
                    [secondArr addObject:dictionary[@"name"]];
                }
                [dic setValue:secondArr ? secondArr : nil forKey:model.name];
            }
            _cataDict = dic;
        }
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark - action

- (IBAction)catagoryButtonClick:(UIButton *)sender {
    [self removeAllKeyboard];
    SHWeakSelf
    if (_cataDict) {
        _catagoryView = [[SHCatagoryView alloc] initWithDict:_cataDict];
        _catagoryView.catagoarySelectBlock = ^(NSString *leftString, NSString *rightString,NSString *string) {
            SHLog(@"%@,%@,%@", leftString,rightString,string)
            weakSelf.catagoaryLeftString = leftString;
            weakSelf.catagoaryRightString = rightString;
            [weakSelf.catagoryButton setTitle:string forState:UIControlStateNormal];
            [weakSelf.catagoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        };
        [self.view addSubview:_catagoryView];
    } else {
        [self loadCatagoaryData];
    }
}

- (IBAction)radiusButtonClick:(UIButton *)sender {
    [self removeAllKeyboard];
    _catagoryView = [[SHCatagoryView alloc] initWithArray:@[@"10",@"100",@"1000",@"5000"]];
    _catagoryView.type = SHAdvertisementType;
    _catagoryView.catagoarySelectBlock = ^(NSString *leftString, NSString *rightString, NSString *string) {
        //SHLog(@"%@_%@_%@", leftString, rightString, string)
        [_radiusButton setTitle:string forState:UIControlStateNormal];
        [_radiusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:_catagoryView];
}

- (IBAction)serviceButtonClick:(UIButton *)sender {
    SHWeakSelf
    
    if (!AppDelegate.isLocationServiceOpen) {
        [self openLocationFunction];
    } else {
        SHLocationViewController *vc = [[SHLocationViewController alloc] init];
        vc.addressBlock = ^(NSString *address, NSString *name, CLLocationCoordinate2D pt, NSString *city) {
            SHLog(@"%@-%@_%3.5f_%3.5f", address,name,pt.latitude,pt.longitude)
            [weakSelf.serviceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [weakSelf.serviceButton setTitle:[NSString stringWithFormat:@"%@%@", address,name] forState:UIControlStateNormal];
            _startPt = pt;
            [weakSelf uploadUserLocationWithLat:_startPt.latitude andLng:_startPt.longitude];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//设置--开启定位服务
- (void)openLocationFunction
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
    {
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"打开定位开关提供更优质的服务" message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:sureAction];
    [alertView addAction:cancelAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
}

- (void)uploadUserLocationWithLat:(double)lat andLng:(double)lng
{
    NSDictionary *dic = @{
                          @"lng":@(lng),
                          @"lat":@(lat)
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHLocationUrl params:dic success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%d", code)
        if (code == 0) {
            SHLog(@"找服务上传经纬度成功")
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)releaseButtonClick:(UIButton *)sender {
    [self removeAllKeyboard];
    if ([self judgeAllParagrams]) {
        SHWeakSelf
        for (SHRelCataModel *model in _cataArray) {
            if ([model.name isEqualToString:_catagoaryLeftString]) {
                NSDictionary *dic = @{
                                      @"name":_nameTF.text,
                                      @"phone":_phoneL.text,
                                      @"title":_titleTF.text,
                                      @"content":_contentTF.text,
                                      @"endDays":_valueTimeTF.text,
                                      @"mainCat":model.ID,
                                      @"mainCatName":model.name,
                                      @"money":_aboutPriceTF.text,
                                      @"radius":_radiusButton.currentTitle,
                                      @"lat":@(_startPt.latitude),
                                      @"lng":@(_startPt.longitude),
                                      @"address":[NSString stringWithFormat:@"%@%@", _serviceButton.currentTitle, _addressDetailTF.text],
                                      @"timePeriod":_serviceDayTF.text
                                      };
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaseNeedUrl params:dic success:^(id JSON, int code, NSString *msg) {
                    SHLog(@"%d", code)
                    SHLog(@"%@", msg)
                    SHLog(@"%@", JSON)
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    if (code == 0) {
                        [MBProgressHUD showMBPAlertView:@"发布成功" withSecond:2.0];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }
                } failure:^(NSError *error) {
                    
                }];
                
            }
        }
        
        
    }
}



- (BOOL)judgeAllParagrams
{
    if ([_catagoryButton.currentTitle isEqualToString:@"请选择分类"]) {
        [MBProgressHUD showMBPAlertView:@"请选择分类" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_titleTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入名称" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_aboutPriceTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入预估价格" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_serviceDayTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入服务天数" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_valueTimeTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入有效期" withSecond:2.0];
        return NO;
    }
    if ([_radiusButton.currentTitle isEqualToString:@"请选择辐射范围"]) {
        [MBProgressHUD showMBPAlertView:@"请选择服务范围" withSecond:2.0];
        return NO;
    }
    if ([_serviceButton.currentTitle isEqualToString:@"请选择服务地址"]) {
        [MBProgressHUD showMBPAlertView:@"请选择服务地址" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_addressDetailTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入详细地址" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_nameTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入姓名" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_contentTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入详情描述" withSecond:2.0];
        return NO;
    }
    
    
    return YES;
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    _addPlaceHolL.alpha = 0;//开始编辑
    if (textView == _addressDetailTF) {
        _addPlaceHolL.alpha = 0;
    } else if (textView == _contentTF) {
        _contentPlaceL.alpha = 0;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    //将要停止编辑（不是第一响应者时）
    if (textView.text.length == 0) {
        if (textView == _addressDetailTF) {
            _addPlaceHolL.alpha = 1;
        } else if (textView == _contentTF) {
            _contentPlaceL.alpha = 1;
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _aboutPriceTF) {
        NSString *text             = _aboutPriceTF.text;
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

/**
 *  移除所有键盘响应
 */
- (void)removeAllKeyboard
{
    [_titleTF resignFirstResponder];
    [_serviceDayTF resignFirstResponder];
    [_addressDetailTF resignFirstResponder];
    [_nameTF resignFirstResponder];
    [_contentTF resignFirstResponder];
    [_valueTimeTF resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
