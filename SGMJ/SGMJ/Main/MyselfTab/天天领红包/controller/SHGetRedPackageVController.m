//
//  SHGetRedPackageVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHGetRedPackageVController.h"
#import "SHRegularView.h"
#import "SHShareView.h"
#import "SHShareModel.h"
#import "SHShareBeforeModel.h"
#import "SHRedPackageModel.h"



@interface SHGetRedPackageVController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *regularButton;



@property (nonatomic, strong) SHRegularView *regularView;

@property (weak, nonatomic) IBOutlet UILabel *redMoneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *withdralButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *leftNumL;

@property (weak, nonatomic) IBOutlet UILabel *hourL;
@property (weak, nonatomic) IBOutlet UILabel *minuteL;
@property (weak, nonatomic) IBOutlet UILabel *secondL;

@property (nonatomic, assign) int leftHour;
@property (nonatomic, assign) int leftMinute;
@property (nonatomic, assign) int leftSecond;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) SHShareBeforeModel *beforeModel;
@property (nonatomic, strong) SHShareModel *shareModel;
@property (nonatomic, strong) SHShareView *shareView;

@property (nonatomic, strong) SHRedPackageModel *redModel;

@end

@implementation SHGetRedPackageVController

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
    
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self loadShareBeforeData];
    [self loadDayGetRedPacksgeData];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"天天拆红包，领千元现金";
    
    //这里设置的是左上和左下角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_regularButton.bounds   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft    cornerRadii:CGSizeMake(_regularButton.height / 2, _regularButton.height / 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _regularButton.bounds;
    maskLayer.path = maskPath.CGPath;
    _regularButton.layer.mask = maskLayer;
    
    
    NSString *leftString = @"已拆得";
    NSString *middleString = @"0.00";
    NSString *rightString = @"元";
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@", leftString,middleString,rightString];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:middleString]];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0] range:[string rangeOfString:middleString]];
    _redMoneyLabel.attributedText = text;
    
    
    _withdralButton.layer.cornerRadius = _withdralButton.height / 2;
    _withdralButton.clipsToBounds = YES;
    _withdralButton.layer.borderWidth = 1.0;
    _withdralButton.layer.borderColor = SHColorFromHex(0xb41616).CGColor;
    _shareButton.layer.cornerRadius = _shareButton.height / 2;
    _shareButton.clipsToBounds = YES;
    _shareButton.layer.borderWidth = 1.0;
    _shareButton.layer.borderColor = CFBridgingRetain(SHColorFromHex(0xb41616));
    
    //获取当前时间
    NSDate *now = [NSDate date];
    SHLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |                 NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    int second = [dateComponent second];
    
    
    self.leftHour = 24 - hour - 1;
    self.leftMinute = 60 - minute - 1;
    self.leftSecond = 60 - second - 1;
    if (hour > 14) {
        self.hourL.text = [NSString stringWithFormat:@"0%d", self.leftHour];
    } else {
        self.hourL.text = [NSString stringWithFormat:@"%d", self.leftHour];
    }
    if (minute > 50) {
        self.minuteL.text = [NSString stringWithFormat:@"0%d", self.leftMinute];
    } else {
        self.minuteL.text = [NSString stringWithFormat:@"%d", self.leftMinute];
    }
    if (second > 50) {
        self.secondL.text = [NSString stringWithFormat:@"0%d", self.leftSecond];
    } else {
        self.secondL.text = [NSString stringWithFormat:@"%d", self.leftSecond];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    
    
}

- (void)timeHeadle
{
    self.leftSecond--;
    if (self.leftSecond == -1) {
        self.leftSecond = 59;
        self.leftMinute--;
        if (self.leftMinute == -1) {
            self.leftMinute = 59;
            self.leftHour--;
        }
    }
    
    if (self.leftHour >= 0 && self.leftHour < 10) {
        self.hourL.text = [NSString stringWithFormat:@"0%d", self.leftHour];
    } else {
        self.hourL.text = [NSString stringWithFormat:@"%d", self.leftHour];
    }
    if (self.leftMinute >= 0 && self.leftMinute < 10) {
        self.minuteL.text = [NSString stringWithFormat:@"0%d", self.leftMinute];
    } else {
        self.minuteL.text = [NSString stringWithFormat:@"%d", self.leftMinute];
    }
    if (self.leftSecond >= 0 && self.leftSecond < 10) {
        self.secondL.text = [NSString stringWithFormat:@"0%d", self.leftSecond];
    } else {
        self.secondL.text = [NSString stringWithFormat:@"%d", self.leftSecond];
    }
    
    
}



- (IBAction)regularButtonClick:(UIButton *)sender {
    
    _regularView = [[SHRegularView alloc] init];
    _regularView.titleLabel.text = @"—————— 红包规则 ——————";
    _regularView.textView.text = @"定义  家服通红包是家服通平台提供给家服通新老会员的额外现金回馈\n1、如何领取红包？\n领取红包只要完成相关红包任务即可，所有的红包任务全都完成才在平台使用交易或提现，其中任何一步没有完成均不可使用交易或体现，且每次登录都会自动跳转到红包任务界面。\n2、红包任务有哪些？\n2.1、分享二维码邀请好友下载任务；\n2.2、每天签到任务；\n2.3、下载注册任务；\n2.4、实名认证任务；\n2.5、发布服务技能/需求任务；\n2.6、在平台做服务任务；\n3、领取红包的操作流程是什么？\n3.1分享二维码邀请好友下载的操作流程是：\n打开家服通APP进入首页→点击【我的】→点击【设置】→【分享给朋友】，生成自己独有的二维码分享给朋友即可；\n3.2每天签到流程是：\n打开家服通APP进入首页→点击【签到】领取签到红包即可；\n3.3下载注册流程是：\n通过好友分享的二维码下载注册，扫描好友的二维码，输入手机号获取验证码，前往应用市场下载即可或者在手机应用市场搜索“家服通”APP下载完成后，登录注册即可；\n3.4实名认证操作流程：\n打开家服通APP进入首页→点击【我的】→点击【实名认证】上传实名认证信息，等待审核即可；\n3.5发布服务技能/需求流程：\n打开家服通APP进入首页→点击中间的【+】号，找到自己需要发布服务技能/需求，发布成功即可；\n3.6在平台做服务流程：\n打开家服通APP首页，看到自己能做的服务，下单并完成订单即可。\n4、什么是连签奖励？\n对于签到新用户，连续签到数天后可获得更大的红包奖励。需要注意的是，必须要每天连续签到，达到一定的日期才可以获得奖励哦。中途断签的话，连续签到周期将重新计数。\n若使用非正常手段获取活动奖励（包括恶意重复刷取奖励，使用非法技术行为骗取系统奖励），家服通有权不发放红包奖励，并将视情况对其追究法律责任。\n本活动最终解释权归家服通所有";
    [_regularView showRegularView];
    
}

//加载天天领红包页面数据
- (void)loadDayGetRedPacksgeData
{
    SHWeakSelf
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHDayGetRedPackageUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            _redModel = [SHRedPackageModel mj_objectWithKeyValues:JSON[@"wrapper"]];
            [weakSelf dealWithRedPackageModelWith:_redModel];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

//加载分享之前的数据
- (void)loadShareBeforeData
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"type":@"redCash"
                          };
    
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHShareBeforeUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            _beforeModel = [SHShareBeforeModel mj_objectWithKeyValues:JSON[@"shareLog"]];
            [weakSelf dealWithBeforeModel:_beforeModel];
            
        }
    } failure:^(NSError *error) {
        
    }];
    // http://m.jiafutong.net/red_packet_index/
    
}

//处理天天领红包的model
- (void)dealWithRedPackageModelWith:(SHRedPackageModel *)model
{
    if (model.leftAmount == 0) {
        _leftNumL.text = @"今天的分享红包已完成";
    }
    _leftNumL.text = [NSString stringWithFormat:@"您还剩%d个分享红包", model.leftAmount];
    
    NSString *leftString = @"已拆得";
    NSString *middleString = [NSString stringWithFormat:@"%.2f", model.alreadyGet];
    NSString *rightString = @"元";
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@", leftString,middleString,rightString];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:middleString]];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0] range:[string rangeOfString:middleString]];
    _redMoneyLabel.attributedText = text;
    
    if (model.totalAmount - model.leftAmount == 0) {
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    }
    
    
    NSString *btnTitle = [NSString stringWithFormat:@"分享后拆第%d份现金", model.totalAmount - model.leftAmount + 1];
    [_shareButton setTitle:btnTitle forState:UIControlStateNormal];
    
    
    
}

//处理分享之前的model
- (void)dealWithBeforeModel:(SHShareBeforeModel *)model
{
    _shareModel = [[SHShareModel alloc] init];
    _shareModel.url = [NSString stringWithFormat:@"%@%@", SHShareLinkUrl, model.key];
    _shareModel.title = model.content;
    _shareModel.descr = model.Description;
    _shareModel.thumbImage = model.imageUrl;
    
}

//提现功能
- (IBAction)withdrwalButtonClick:(UIButton *)sender {
    
}

//分享按钮
- (IBAction)shareButtonClick:(UIButton *)sender {
    _shareView = [[SHShareView alloc] init];
    SHLog(@"%@", _shareModel.thumbImage)
    [_shareView showShareViewWithSHShareModel:_shareModel shareContentType:SHShareContentTypeLink];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
