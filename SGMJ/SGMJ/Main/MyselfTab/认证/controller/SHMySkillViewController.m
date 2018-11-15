//
//  SHMySkillViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMySkillViewController.h"
#import "SHAllSkillListViewController.h"
#import "SHMySkillModel.h"
#import "SHSkillTViewCell.h"


static NSString *identityCell = @"SHSkillTViewCell";
@interface SHMySkillViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;



@end

@implementation SHMySkillViewController

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
    
    [self initBaseInfo];
    [self loadMySkillData];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self initBaseInfo];
    
    //[self loadMySkillData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMySkillData) name:@"SHEDITSKILL" object:nil];
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"我的技能";
    
    //self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //_tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    //定制右按钮
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClick)];
    [barBut setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.0],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barBut;
    
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _dataArray = [NSMutableArray array];
}

/**
 *  编辑
 */
- (void)editButtonClick
{
    SHLog(@"编辑按钮")
    SHAllSkillListViewController *Vc = [[SHAllSkillListViewController alloc] init];
    [self.navigationController pushViewController:Vc animated:YES];
}

/**
 *  我的技能列表
 */
- (void)loadMySkillData
{
    SHLog(@"通知回调")
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] getWithURL:SHMySkillUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [_dataArray removeAllObjects];
            NSMutableArray *array = [SHMySkillModel mj_objectArrayWithKeyValuesArray:JSON[@"professionVerifies"]];
            SHLog(@"%d", array.count)
            if (array.count == 0) {
                _tableView.hidden = YES;
            } else {
                [_dataArray addObjectsFromArray:array];
                [_tableView reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SHMySkillModel *model = _dataArray[indexPath.row];
    cell.imgButton.hidden = YES;
    [cell setMyModel:model];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
}
















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
