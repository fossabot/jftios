//
//  SHInfluenceVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHInfluenceVController.h"
#import "SHInfluenceHectionView.h"
#import "SHInfluenceCell.h"
#import "SHTeamModel.h"

static NSString *identityCell = @"SHInfluenceCell";
@interface SHInfluenceVController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, assign) double totalMoney;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SHInfluenceHectionView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *totalNumL;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyL;


@end

@implementation SHInfluenceVController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SHLog(@"viewDidLoad")
    [self initBaseInfo];
    
    [self loadTeamInfluenceData];
    
}

- (void)loadView
{
    [super loadView];
    SHLog(@"loadView")
}


- (void)initBaseInfo
{
    self.navigationItem.title = @"我的影响力";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStyleDone target:self action:@selector(regularFunction)];
    
    
    
    
}

- (void)regularFunction
{
    
}

- (void)loadTeamInfluenceData
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHTeamInfluenceUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            NSMutableArray *array = [SHTeamModel mj_objectArrayWithKeyValuesArray:JSON[@"teams"]];
            _tableView.hidden = NO;

            [weakSelf.dataArray addObjectsFromArray:array];
            NSDictionary *dic = JSON[@"mine"];
            _totalMoney = [dic[@"totalMoney"] doubleValue];
            _totalNum = [dic[@"totalNum"] integerValue];
            SHLog(@"%d", _totalNum)
            [_tableView reloadData];
            
            
            
            NSString *foreString = @"总人数：";
            NSString *foreRightStr = [NSString stringWithFormat:@"%d人", _totalNum];
            _totalNumL.text = [NSString stringWithFormat:@"%@%@", foreString, foreRightStr];
            
            
            NSString *foreTwoString = @"总收益：";
            NSString *foreTwoRightStr = [NSString stringWithFormat:@"%.2f元", _totalMoney];
            _totalMoneyL.text = [NSString stringWithFormat:@"%@%@", foreTwoString, foreTwoRightStr];
            
            
            
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
    
}

- (IBAction)noDataButtonClick:(UIButton *)sender {
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    SHInfluenceHectionView *view = [[SHInfluenceHectionView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 50)];
//
//    NSString *foreString = @"总人数：";
//    NSString *foreRightStr = [NSString stringWithFormat:@"%d人", _totalNum];
//    SHLog(@"%d", _totalNum)
//    view.totalNumL.text = [NSString stringWithFormat:@"%@%@", foreString, foreRightStr];
//    NSMutableAttributedString *forecastString = [[NSMutableAttributedString alloc] initWithString:view.totalNumL.text];
//    NSRange range2 = [[forecastString string] rangeOfString:foreRightStr];
//    [forecastString addAttribute:NSForegroundColorAttributeName value:navColor range:range2];
//    view.totalNumL.attributedText = forecastString;
//
//    NSString *foreTwoString = @"总收益：";
//    NSString *foreTwoRightStr = [NSString stringWithFormat:@"%.2f元", _totalMoney];
//    view.totalMoneyL.text = [NSString stringWithFormat:@"%@%@", foreTwoString, foreTwoRightStr];
//    NSMutableAttributedString *forecastTString = [[NSMutableAttributedString alloc] initWithString:view.totalMoneyL.text];
//    NSRange range3 = [[forecastTString string] rangeOfString:foreTwoRightStr];
//    [forecastTString addAttribute:NSForegroundColorAttributeName value:navColor range:range3];
//    view.totalMoneyL.attributedText = forecastTString;
//
//
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHInfluenceCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHInfluenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    SHTeamModel *model = self.dataArray[indexPath.row];
    [cell setModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
