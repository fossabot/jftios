//
//  SHOrderViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHOrderViewController.h"
#import "SHCatagoryListModel.h"
#import <CoreLocation/CoreLocation.h>
#import "SHLocationViewController.h"
#import "SHPayOrderVController.h"
#import "SHOrderModel.h"
#import "SH_DateTimePickerView.h"

@interface SHOrderViewController () <UITextFieldDelegate, SHDateTimePickerViewDelegate> {
    CLLocationCoordinate2D _pt;
}
@property (nonatomic, strong) SH_DateTimePickerView *datePickView;


@property (weak, nonatomic) IBOutlet UIImageView *bigImgV;//头像
@property (weak, nonatomic) IBOutlet UILabel *titleL;//标题
@property (weak, nonatomic) IBOutlet UILabel *descL;//描述
@property (weak, nonatomic) IBOutlet UILabel *priceL;//价格
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间

@property (weak, nonatomic) IBOutlet UILabel *numberL;//需求量
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;//服务时间
@property (weak, nonatomic) IBOutlet UIButton *serviceAddBtn;//服务地址
@property (weak, nonatomic) IBOutlet UITextView *detailAddTV;//服务详细地址
@property (weak, nonatomic) IBOutlet UILabel *detailPlaceL;//详细地址占位符
@property (weak, nonatomic) IBOutlet UILabel *phoneL;//电话
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//姓名
@property (weak, nonatomic) IBOutlet UITextView *messageTV;//留言tv
@property (weak, nonatomic) IBOutlet UILabel *messagePlaceL;//留言占位符

@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;//总价
@property (weak, nonatomic) IBOutlet UIButton *payButton;//付款按钮
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewContraint;


@end

@implementation SHOrderViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
    
}

- (void)initBaseInfo
{
    
    self.navigationItem.title = @"订单填写";
    
    [_nameTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    
    [_bigImgV sd_setImageWithURL:[NSURL URLWithString:_listModel.providerAvatar] placeholderImage:[UIImage imageNamed:@"head4"]];
    _titleL.text = [NSString stringWithFormat:@"标题:%@", _listModel.serveSupply[@"title"]];
    _descL.text = [NSString stringWithFormat:@"描述:%@", _listModel.serveSupply[@"description"]];
    _priceL.text = [NSString stringWithFormat:@"%@元/%@", _listModel.serveSupply[@"price"], _listModel.serveSupply[@"unit"]];
    
    _phoneL.text = SH_AppDelegate.personInfo.mobile;
    SHLog(@"%@", _listModel.serveSupply)
    
//    _timeLabel.hidden = NO;
//    NSArray *startArray = [_listModel.serveSupply[@"startTime"] componentsSeparatedByString:@" "];
//    NSArray *endArray = [_listModel.serveSupply[@"endTime"] componentsSeparatedByString:@" "];
//    NSString *str1 = [startArray[1] substringToIndex:5];//截取掉下标5之前的字符串
//    NSString *str2 = [endArray[1] substringToIndex:5];
//    
//    _timeLabel.text = [NSString stringWithFormat:@"开始:%@--结束:%@", str1, str2];
    
    //免打扰
    if ([_listModel.serveSupply[@"isAuto"] integerValue] == 0) {
        _timeLabel.hidden = NO;
        NSArray *startArray = [_listModel.serveSupply[@"startTime"] componentsSeparatedByString:@" "];
        NSArray *endArray = [_listModel.serveSupply[@"endTime"] componentsSeparatedByString:@" "];
        NSString *str1 = [startArray[1] substringToIndex:5];//截取掉下标5之前的字符串
        NSString *str2 = [endArray[1] substringToIndex:5];

        _timeLabel.text = [NSString stringWithFormat:@"开始:%@--结束:%@", str1, str2];
    } else if ([_listModel.serveSupply[@"isAuto"] integerValue] == 1) {
        _timeLabel.text = @"开始:00:00--结束:24:00";
    }
    
    //阴影的颜色
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影的透明度
    _bottomView.layer.shadowOpacity = 0.9f;
    //阴影的圆角
    _bottomView.layer.shadowRadius = 4.0f;
    _bottomView.layer.shadowOffset = CGSizeMake(5,5);
    
    _payButton.layer.cornerRadius = 10;
    _payButton.clipsToBounds = YES;
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:12]};
    CGSize maxSize = CGSizeMake(_descL.width, MAXFLOAT);
    
    //计算文字占据的高度
    CGSize size = [_descL.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    _headViewContraint.constant = 105 + size.height - 17;
    
    
}

//加
- (IBAction)addButtonClick:(UIButton *)sender {
    NSInteger num = [_numberL.text integerValue];
    num += 1;
    NSInteger price = [_listModel.serveSupply[@"price"] integerValue];
    _totalPriceL.text = [NSString stringWithFormat:@"￥%ld元", num * price];
    _numberL.text = [NSString stringWithFormat:@"%ld", (long)num];
}

//减
- (IBAction)reduceButtonClick:(UIButton *)sender {
    NSInteger num = [_numberL.text integerValue];
    if (num == 0) {
        _totalPriceL.text =@"￥0元";
        [MBProgressHUD showMBPAlertView:@"不能再少了！" withSecond:2.0];
    } else {
        num -= 1;
        NSInteger price = [_listModel.serveSupply[@"price"] integerValue];
        _totalPriceL.text = [NSString stringWithFormat:@"￥%ld元", num * price];
        _numberL.text = [NSString stringWithFormat:@"%ld", (long)num];
    }
    
}

//服务时间
- (IBAction)serviceTimeBtnClick:(UIButton *)sender {

    SH_DateTimePickerView *pickerView = [[SH_DateTimePickerView alloc] init];
    self.datePickView = pickerView;
    pickerView.titleLabel.text = @"时间";
    pickerView.dateDelegate = self;
    pickerView.pickerViewMode = SHDatePickerViewHM;
    [self.view addSubview:pickerView];
    [pickerView showDateTimePickerView];
}


//服务地址
- (IBAction)serviceButtonClick:(UIButton *)sender {
    SHWeakSelf
    
    if (!AppDelegate.isLocationServiceOpen) {
        [self openLocationFunction];
    } else {
        
        SHLocationViewController *vc = [[SHLocationViewController alloc] init];
        vc.addressBlock = ^(NSString *address, NSString *name, CLLocationCoordinate2D pt, NSString *city) {
            SHLog(@"%@-%@_%3.5f_%3.5f", address,name,pt.latitude,pt.longitude)
            [weakSelf.serviceAddBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [weakSelf.serviceAddBtn setTitle:[NSString stringWithFormat:@"%@%@", address,name] forState:UIControlStateNormal];
            _pt = pt;
            [weakSelf uploadUserLocationWithLat:_pt.latitude andLng:_pt.longitude];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

//开启定位服务
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
            SHLog(@"订单上传经纬度成功")
        }
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)judgeParagrams
{
    if ([_numberL.text isEqualToString:@"0"]) {
        [MBProgressHUD showMBPAlertView:@"需求量不能为0！" withSecond:2.0];
        return NO;
    }
    if ([_serviceButton.currentTitle isEqualToString:@"请选择服务时间"]) {
        [MBProgressHUD showMBPAlertView:@"请选择服务时间" withSecond:2.0];
        return NO;
    }
    if ([_listModel.serveSupply[@"isAuto"] integerValue] ==0) {
        NSArray *startArray = [_listModel.serveSupply[@"startTime"] componentsSeparatedByString:@" "];
        NSArray *endArray = [_listModel.serveSupply[@"endTime"] componentsSeparatedByString:@" "];
        NSString *str1 = [startArray[1] substringToIndex:5];//截取掉下标5之前的字符串
        NSString *str2 = [endArray[1] substringToIndex:5];
        
        if (!([self compareDate:str1 withDate:_serviceButton.currentTitle] == 1 && [self compareDate:str2 withDate:_serviceButton.currentTitle] == -1)) {
            [MBProgressHUD showMBPAlertView:@"服务时间要在开始和结束之间" withSecond:2.0];
            return NO;
        }
    }
    
    
    if ([_serviceButton.currentTitle isEqualToString:@"请选择服务地址"]) {
        [MBProgressHUD showMBPAlertView:@"请选择服务地址!" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_detailAddTV.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入详细地址!" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_nameTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入姓名！" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_messageTV.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入留言！" withSecond:2.0];
        return NO;
    }
    return YES;
}


//立即付款
- (IBAction)payButtonClick:(UIButton *)sender {
    SHWeakSelf
    if ([self judgeParagrams]) {
        NSDictionary *dic = @{
                              @"orderType":@"serve",
                              @"productId":_listModel.serveSupply[@"id"],
                              @"amount":@([_numberL.text integerValue]),
                              @"content":_messageTV.text,
                              @"contact":_nameTF.text,
                              @"phone":_phoneL.text,
                              @"lat":@(_pt.latitude),
                              @"lng":@(_pt.longitude),
                              @"address":[NSString stringWithFormat:@"%@%@", _serviceAddBtn.currentTitle, _detailAddTV.text]
                              };
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHOrderFillInUrl params:dic success:^(id JSON, int code, NSString *msg) {
            SHLog(@"%d", code)
            SHLog(@"%@", msg)
            SHLog(@"%@", JSON)
            [MBProgressHUD hideHUDForView:weakSelf.view];
            if (code == 0) {
                SHOrderModel *orderModel = [SHOrderModel mj_objectWithKeyValues:JSON[@"order"]];
                [weakSelf goToPayViewController:orderModel];
            } else if (code == 100) {
                [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
            } else {
                [MBProgressHUD showMBPAlertView:@"数据请求出错，请稍后再试" withSecond:2.0];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

- (void)goToPayViewController:(SHOrderModel *)orderModel
{
    SHPayOrderVController *vc = [[SHPayOrderVController alloc] init];
    vc.orderNo = orderModel.orderNo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SHDateTimePickerViewDelegate
- (void)didClickFinishDateTimePickerView:(NSString *)date {
    SHLog(@"%@", date);
    [_serviceButton setTitle:date forState:UIControlStateNormal];
    [_serviceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//比较时间
- (int)compareDate:(NSString*)date01 withDate:(NSString*)date02
{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setDateFormat:@"HH:mm"];
    NSDate *dt1 = [[NSDate alloc]init];
    NSDate *dt2 = [[NSDate alloc]init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    SHLog(@"%@", dt1)
    SHLog(@"%@", dt2)
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci=-1;
            break;
            //date02=date01
        case NSOrderedSame:
            ci=0;
            break;
            
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
            
    }
    SHLog(@"%d", ci)
    return ci;
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
    
    if (textView == _detailAddTV) {
        _detailPlaceL.alpha = 0;
    } else if (textView == _messageTV) {
        _messagePlaceL.alpha = 0;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    //将要停止编辑（不是第一响应者时）
    if (textView == _detailAddTV) {
        if (textView.text.length == 0) {
            _detailPlaceL.alpha = 1;
        }
    } else if (textView == _messageTV) {
        if (_messageTV.text.length == 0) {
            _messagePlaceL.alpha = 1;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
