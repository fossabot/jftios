//
//  SHEvaluteDetailViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHEvaluteDetailViewController.h"
#import "SHEvaluateHeadView.h"
#import "SHEvaluateDetailModel.h"
#import "SHReplayEvaluateVController.h"
#import "SHReplayModel.h"
#import "SHReplaySectionView.h"
#import "SHReplayTableViewCell.h"
#import "SHEvaluteOrderViewController.h"


static NSString *identityCell = @"SHReplayTableViewCell";
@interface SHEvaluteDetailViewController () <UITableViewDelegate, UITableViewDataSource, SHEditEvaluateDetailDelegate>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SHEvaluateDetailModel *detailModel;

@property (nonatomic, strong) UIButton *replyButton;                    //回复

@end

@implementation SHEvaluteDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SHScreenW,SHScreenH - 120) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SHReplayTableViewCell class] forCellReuseIdentifier:identityCell];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.estimatedRowHeight = 60;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initBaseInfo];
    [self loadEvaluteDetail];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"评价详情";
    
    _replyButton = [[UIButton alloc] init];
    [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
    _replyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _replyButton.backgroundColor = navColor;
    [_replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_replyButton addTarget:self action:@selector(replayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_replyButton];
    [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.view bringSubviewToFront:_replyButton];
}

- (void)loadEvaluteDetail
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"assessId":@(_evaluateId)
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHEvaluateDetailUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [weakSelf.dataArray removeAllObjects];
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            _detailModel = [SHEvaluateDetailModel mj_objectWithKeyValues:JSON[@"wrapper"]];
            [weakSelf dealHeadWithModel:_detailModel];
            
            if (_detailModel.replyList.count > 0) {
                
                NSMutableArray *array = [SHReplayModel mj_objectArrayWithKeyValuesArray:_detailModel.replyList];
                for (SHReplayModel *model in array) {
                    SHLog(@"回复:%@", model.content)
                }
                
                [self.dataArray addObjectsFromArray:array];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
    
}

- (void)dealHeadWithModel:(SHEvaluateDetailModel *)model
{
    NSString *introduce = model.content;
    SHLog(@"%@", model.content)
    CGRect rect = [introduce boundingRectWithSize:CGSizeMake(SHScreenW - 26, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f ]} context:nil];
    if (model.images.count == 0) {
        SHEvaluateHeadView *headerView = [[SHEvaluateHeadView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 153 + rect.size.height)];
        headerView.detailModel = model;
        if ([self.typeString isEqualToString:@"MINE"]) {
            headerView.editButton.hidden = NO;
        } else {
            headerView.editButton.hidden = YES;
        }
        headerView.delegate = self;
        [self.tableView setTableHeaderView:headerView];
    } else if (model.images.count == 1) {
        if ([model.images[0] isEqualToString:@""]) {
            SHEvaluateHeadView *headerView = [[SHEvaluateHeadView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 153 + 2 * rect.size.height)];
            headerView.detailModel = model;
            if ([self.typeString isEqualToString:@"MINE"]) {
                headerView.editButton.hidden = NO;
            } else {
                headerView.editButton.hidden = YES;
            }
            headerView.delegate = self;
            [self.tableView setTableHeaderView:headerView];
        } else {
            SHEvaluateHeadView *headerView = [[SHEvaluateHeadView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 153 + 2 * rect.size.height + 249)];
            headerView.detailModel = model;
            if ([self.typeString isEqualToString:@"MINE"]) {
                headerView.editButton.hidden = NO;
            } else {
                headerView.editButton.hidden = YES;
            }
            headerView.delegate = self;
            [self.tableView setTableHeaderView:headerView];
        }
    } else if (model.images.count == 2) {
        if ([model.images[0] isEqualToString:@""] && [model.images[1] isEqualToString:@""]) {
            SHEvaluateHeadView *headerView = [[SHEvaluateHeadView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 153 + 2 * rect.size.height)];
            headerView.detailModel = model;
            if ([self.typeString isEqualToString:@"MINE"]) {
                headerView.editButton.hidden = NO;
            } else {
                headerView.editButton.hidden = YES;
            }
            headerView.delegate = self;
            [self.tableView setTableHeaderView:headerView];
        } else {
            SHEvaluateHeadView *headerView = [[SHEvaluateHeadView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 153 + 2 * rect.size.height + 249)];
            headerView.detailModel = model;
            if ([self.typeString isEqualToString:@"MINE"]) {
                headerView.editButton.hidden = NO;
            } else {
                headerView.editButton.hidden = YES;
            }
            headerView.delegate = self;
            [self.tableView setTableHeaderView:headerView];
        }
    } else if (model.images.count == 3) {
        if ([model.images[0] isEqualToString:@""] && [model.images[1] isEqualToString:@""] && [model.images[2] isEqualToString:@""]) {
            SHEvaluateHeadView *headerView = [[SHEvaluateHeadView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 153 + 2 * rect.size.height)];
            headerView.detailModel = model;
            if ([self.typeString isEqualToString:@"MINE"]) {
                headerView.editButton.hidden = NO;
            } else {
                headerView.editButton.hidden = YES;
            }
            headerView.delegate = self;
            [self.tableView setTableHeaderView:headerView];
        } else {
            SHEvaluateHeadView *headerView = [[SHEvaluateHeadView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 153 + 2 * rect.size.height + 249)];
            headerView.detailModel = model;
            if ([self.typeString isEqualToString:@"MINE"]) {
                headerView.editButton.hidden = NO;
            } else {
                headerView.editButton.hidden = YES;
            }
            headerView.delegate = self;
            [self.tableView setTableHeaderView:headerView];
        }
    }
    
    
    
}

#pragma mark - replaybutton
- (void)replayButtonClick
{
    SHLog(@"回复")
    SHWeakSelf
    SHReplayEvaluateVController *vc = [[SHReplayEvaluateVController alloc] init];
    vc.asseceId = _detailModel.assessId;
    vc.replayBlock = ^(NSUInteger asseeId) {
        SHLog(@"%d", asseeId)
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadEvaluteDetail];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *sectionHead = @"headSection";
    SHReplaySectionView *replaySectionV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHead];
    if (!replaySectionV) {
        replaySectionV = [[SHReplaySectionView alloc] initWithReuseIdentifier:sectionHead];
    }
    if (self.dataArray.count > 0) {
        replaySectionV.sectionLabel.text = @"全部回复";
    } else {
        replaySectionV.sectionLabel.text = @"暂无回复";
    }
    
    return replaySectionV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHReplayModel *model = self.dataArray[indexPath.row];
    NSString *string = model.content;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SHScreenW - 81, CGFLOAT_MAX)options:options context:nil];
    titleHeight = ceilf(rect.size.height);

    return titleHeight + 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHReplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHReplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SHReplayModel *model = self.dataArray[indexPath.row];
    [cell setReplayModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

#pragma mark - SHEditEvaluateDetailDelegate
- (void)beginEditEvaluate:(SHEvaluateDetailModel *)detailModel
{
    SHLog(@"%d", detailModel.assessId)
    SHWeakSelf
    SHEvaluteOrderViewController *vc = [[SHEvaluteOrderViewController alloc] init];
    vc.accessId = detailModel.assessId;
    vc.evaluateType = SHModifyEvaluateAsseIdType;
    vc.evaluateBlock = ^(NSUInteger accessId) {
        [weakSelf loadEvaluteDetail];
    };
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
