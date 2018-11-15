//
//  SHMessageVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMessageVController.h"
#import "SHSystemMsgTViewCell.h"
#import "SHMessageModel.h"

#import "SHMyOrderDetailVController.h"
#import "SHWelfareCenterVController.h"
#import "SHNeedDetailVController.h"

static NSString *identityCell = @"SHSystemMsgTViewCell";
@interface SHMessageVController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *nodataLabel;


@end

@implementation SHMessageVController

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
    [self loadMessageData];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"消息通知";
    _dataArray = [NSMutableArray array];
    
    
    
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    
}

/**
 *  加载消息数据
 */
- (void)loadMessageData
{
    SHWeakSelf
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHSystemMessageUrl params:nil success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%d", code)
        //SHLog(@"%@", msg)
        //SHLog(@"%@", JSON)
        if (code == 0) {
            NSMutableArray *array = [SHMessageModel mj_objectArrayWithKeyValuesArray:JSON[@"list"]];
            
            for (SHMessageModel *model in array) {
                SHLog(@"%@", model.model)
            }
            
            
            if (array.count == 0) {
                _tableView.hidden = YES;
            } else {
                weakSelf.nodataLabel.hidden = YES;
                [_dataArray addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }
            
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
    return 122;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHSystemMsgTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHSystemMsgTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    
    SHMessageModel *msgModel = _dataArray[indexPath.row];
    cell.contentLabel.text = msgModel.content;
    cell.timeLabel.text = msgModel.createTime;
    SHLog(@"%@", msgModel.model)
    if ([msgModel.model isEqualToString:@"BROADCAST"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailL.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHMessageModel *model = _dataArray[indexPath.row];
    if ([model.model isEqualToString:@"ORDER"]) {
        SHMyOrderDetailVController *vc = [[SHMyOrderDetailVController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.inType = SHNotificationType;
        vc.orderNo = model.value;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.model isEqualToString:@"GIFT"]) {
        SHWelfareCenterVController *vc = [[SHWelfareCenterVController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.model isEqualToString:@"NEED"]) {
        if ([model.key isEqualToString:@"NEED_REMIND"]) {
            SHNeedDetailVController *vc = [[SHNeedDetailVController alloc] init];
            vc.needId = [model.value integerValue];
            SHLog(@"%@", model.value)
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.key isEqualToString:@"ORDER_CREATE"]) {
            SHMyOrderDetailVController *vc = [[SHMyOrderDetailVController alloc] init];
            vc.inType = SHNotificationType;
            vc.orderNo = model.value;
            SHLog(@"%@", model.value)
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
