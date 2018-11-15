//
//  SHAllSkillListViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAllSkillListViewController.h"
#import "SHSkillModel.h"
#import "SHSkillTViewCell.h"


static NSString *identityCell = @"SHSkillTViewCell";
@interface SHAllSkillListViewController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
//用来记录选中的状态
@property (nonatomic, strong)NSMutableSet *selectdeSet;

@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation SHAllSkillListViewController

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
    
    [self loadAllSkillListData];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"编辑职业技能";
    
    self.view.backgroundColor = SHColorFromHex(0xf2f2f2);
    _dataArray = [NSMutableArray array];
    _selectdeSet = [NSMutableSet set];
    _selectArray = [NSMutableArray array];
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    
    
}

/**
 *  加载所有技能列表
 */
- (void)loadAllSkillListData
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHAllSkillListUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            NSMutableArray *array = [SHSkillModel mj_objectArrayWithKeyValuesArray:JSON[@"categories"]];
            
            [_dataArray addObjectsFromArray:array];
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
    
}

/**
 *  确认按钮
 */
- (IBAction)sureButtonClick:(UIButton *)sender {
    SHWeakSelf
    [_selectArray removeAllObjects];
    for (SHSkillModel *model in _dataArray) {
        if (model.isSelected == 0) {
            [_selectArray addObject:[NSString stringWithFormat:@"%ld", model.ID]];
            SHLog(@"%@---%d", model.name, model.ID)
        }
    }
    
    if (_selectArray.count == 0) {
        [MBProgressHUD showMBPAlertView:@"请勾选职业技能" withSecond:2.0];
        return;
    }
    
    NSString *string = [_selectArray componentsJoinedByString:@","];
    NSDictionary *dic = @{
                          @"ids":string
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:shCreateSkillUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@",msg)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"创建成功" withSecond:2.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHEDITSKILL" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else if (code == 500) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHSkillTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHSkillTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    SHSkillModel *model = _dataArray[indexPath.row];
    cell.applyButton.hidden = YES;
    [cell setSkillModel:model];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHSkillModel *model = _dataArray[indexPath.row];
    
    if (model.isSelected == 0) {
        model.isSelected = 1;
    } else {
        model.isSelected = 0;
    }
    
    [_tableView reloadData];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
