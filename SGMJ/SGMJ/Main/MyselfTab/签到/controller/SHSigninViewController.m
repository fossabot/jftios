//
//  SHSigninViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSigninViewController.h"
#import "SHRegularView.h"
#import "SHSignInViewCell.h"
#import "SHSignInModel.h"

static NSString *identityID = @"SHSignInViewCell";
@interface SHSigninViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *regularButton;

@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardMonLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SHRegularView *regularView;


@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SHSigninViewController

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
    
    [self loadSignData];
    
}


- (void)initBaseInfo
{
    self.navigationItem.title = @"签到领现金";
    
    //这里设置的是左上和左下角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_regularButton.bounds   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft    cornerRadii:CGSizeMake(_regularButton.height / 2, _regularButton.height / 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _regularButton.bounds;
    maskLayer.path = maskPath.CGPath;
    _regularButton.layer.mask = maskLayer;
    
    _signinButton.layer.cornerRadius = _signinButton.height / 2;
    _signinButton.clipsToBounds = YES;
    
    
    [_tableView registerNib:[UINib nibWithNibName:identityID bundle:nil] forCellReuseIdentifier:identityID];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _dataArray = [NSMutableArray array];
    
    
}

//签到数据
- (void)loadSignData
{
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHSignInListUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            
            NSMutableArray *array = [SHSignInModel mj_objectArrayWithKeyValuesArray:JSON[@"logs"]];
            _signLabel.text = [NSString stringWithFormat:@"连续签到:%@天", JSON[@"totalDays"]];
            _awardMonLabel.text = [NSString stringWithFormat:@"获得奖励:%@元", JSON[@"totalMoney"]];
            if (array.count == 0) {
                
            } else {
                
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:array];
                SHLog(@"%@", _dataArray)
                [_tableView reloadData];
                
            }
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}



/**
 *  签到
 */
- (IBAction)signInButtonClick:(UIButton *)sender {
    SHWeakSelf
    NSDictionary *dic = @{
                          @"type":@"SIGN_IN"
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHSignInGetMoneyUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"签到成功" withSecond:2.0];
            [weakSelf loadSignData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"signInNoti" object:nil];
        } else if (code == 500) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 *  签到规则
 */
- (IBAction)regularButtonClick:(UIButton *)sender {
    _regularView = [[SHRegularView alloc] init];
    _regularView.titleLabel.text = @"—————— 签到规则 ——————";
    _regularView.textView.text = @"1、每天签到，每天可领取红包奖励，签到漏签不可补签，会让您少领取一天的红包奖励哦。\n2、签到累计金额和任 务奖励金一起满 300 可直接提 现。\n3、若用户连续30天未登陆家服通App，则账户中的余额将于第30日24点过期，需重新签到领取。\n4、新版签到仍然保留旧版签到的余额。\n5、如果用户存在违规行为（包括但不限于洗钱、虚假交易、赌博、恶意套现、作弊、刷信誉），主办方将取消用户的活动资格、并有权撤销相关违规交易、收回奖励（包括已消费金额）等利益，同时依照相关规则进行处罚。\n6、如出现不可抗力或情势变更的情况（包括但不限于重大灾害事件、活动受政府机关指令需要停止举办或调整的、活动遭受严重网络攻击或因系统故障需要暂停举办的），则主办方可依相关法律法规的规定主张免责。\n本活动最终解释权归家服通所有";
    [_regularView showRegularView];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHSignInViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityID];
    if (!cell) {
        cell = [[SHSignInViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityID];
    }
    SHSignInModel *model = _dataArray[indexPath.row];
    [cell setSignInModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
