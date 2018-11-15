//
//  SHGoodDetailVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHGoodDetailVController.h"
#import "SHCommentCell.h"
#import "SDCycleScrollView.h"
#import "SHCatagoryListModel.h"
#import "SHOrderViewController.h"
#import "SHShareView.h"
#import "SHShareModel.h"
#import "SHShareBeforeModel.h"
#import "SHPersonalViewController.h"
#import "SHCatagoryListModel.h"

#import "SHServiceCommentModel.h"
#import "SHServiceDetailHeadView.h"
#import "SHServiceCommentCell.h"

static NSString *identityCell = @"SHServiceCommentCell";
@interface SHGoodDetailVController () <UITableViewDelegate, UITableViewDataSource, SHCancelFollowDelegate>


@property (nonatomic, strong) UILabel *lineL;
@property (weak, nonatomic) IBOutlet UIView *bottomView;



@property (weak, nonatomic) IBOutlet UIButton *makeOrderBtn;


@property (nonatomic, strong) UIBarButtonItem *item1;
@property (nonatomic, strong) UIBarButtonItem *item2;


@property (nonatomic, strong) SHShareBeforeModel *beforeModel;
@property (nonatomic, strong) SHShareModel *shareModel;
@property (nonatomic, strong) SHShareView *shareView;

@property (nonatomic, strong) SHCatagoryListModel *listModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation SHGoodDetailVController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    
    [self loadShareBeforeData];
    
    [self loadDetail];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"服务详情";
    
    [_tableView registerClass:[SHServiceCommentCell class] forCellReuseIdentifier:identityCell];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    //shareWhite
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(shareToOtherButtonClick)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"shareWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    
    
}

- (void)loadDetail
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"serverId":@(_provideId)
                          };
    SHLog(@"%@", dic)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHServiceDetailUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            _listModel = [SHCatagoryListModel mj_objectWithKeyValues:JSON[@"wrapper"]];
            [weakSelf dealWithCataModel:_listModel];
            NSDictionary *dic = JSON[@"wrapper"];
            
            SHLog(@"%@", dic[@"orderAssesses"])
            NSMutableArray *array = [SHServiceCommentModel mj_objectArrayWithKeyValuesArray:dic[@"orderAssesses"]];
            SHLog(@"%@", array)
            [weakSelf.dataArray addObjectsFromArray:array];
            [_tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
}

- (void)dealWithCataModel:(SHCatagoryListModel *)listmodel
{
    NSString *introduce = listmodel.serveSupply[@"description"];
    CGRect rect = [introduce boundingRectWithSize:CGSizeMake(SHScreenW - 26, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f ]} context:nil];
    SHServiceDetailHeadView *headView = [[SHServiceDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 365 + rect.size.height)];
    headView.commentModel = listmodel;
    headView.delegate = self;
    [self.tableView setTableHeaderView:headView];
    if (SH_AppDelegate.personInfo.userId == listmodel.providerId) {
        self.bottomView.hidden = YES;
    }
    
}

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

- (void)dealWithBeforeModel:(SHShareBeforeModel *)model
{
    _shareModel = [[SHShareModel alloc] init];
    _shareModel.url = [NSString stringWithFormat:@"%@%@", SHShareLinkUrl, model.key];
    _shareModel.title = model.content;
    _shareModel.descr = model.Description;
    _shareModel.thumbImage = model.imageUrl;
    
}

//头像
- (void)clickHeadImageView
{
    SHLog(@"点击头像")
    SHPersonalViewController *Vc = [[SHPersonalViewController alloc] init];
    Vc.providerId = _listModel.providerId;
    [self.navigationController pushViewController:Vc animated:YES];
}

//关注
- (IBAction)followBtnClick:(UIButton *)sender {
//    NSDictionary *dic = @{
//                          @"careId":@(_listModel.providerId)
//                          };
//    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHFollowOtherUrl params:dic success:^(id JSON, int code, NSString *msg) {
//        SHLog(@"%d", code)
//        SHLog(@"%@", msg)
//        SHLog(@"%@", JSON)
//        if (code == 0) {
//            if ([_followBtn.currentTitle isEqualToString:@"+关注"]) {
//                [MBProgressHUD showMBPAlertView:@"关注成功" withSecond:2.0];
//                [_followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
//            } else if ([_followBtn.currentTitle isEqualToString:@"取消关注"]) {
//                [MBProgressHUD showMBPAlertView:@"取消成功" withSecond:2.0];
//                [_followBtn setTitle:@"+关注" forState:UIControlStateNormal];
//            }
//            
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    
}

- (IBAction)phoneButtonClick:(UIButton *)sender {
    
    [self callPhoneStr:_listModel.providerPhone];
    
}


/**
 *  follow
 */
- (void)followButtonClick
{
    
}

/**
 *  分享
 */
- (void)shareToOtherButtonClick
{
    _shareView = [[SHShareView alloc] init];
    SHLog(@"%@", _shareModel.title)
    [_shareView showShareViewWithSHShareModel:_shareModel shareContentType:SHShareContentTypeLink];
}

/**
 *  评论
 */
- (IBAction)commentBtnClick:(UIButton *)sender {
    if (sender.tag == 10) {
        
    } else if (sender.tag == 11) {
        
    }
    
}

/**
 *  立即下单
 */
- (IBAction)makeOrderButtonClick:(UIButton *)sender {
    SHOrderViewController *vc = [[SHOrderViewController alloc] init];
    vc.listModel = _listModel;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHServiceCommentModel *model = self.dataArray[indexPath.row];
//    if ([model.content isEqualToString:@""]) {
//        model.content = @"用户暂无评论!";
//    } else {
//        SHLog(@"%@", model.content)
//    }
    NSString *string = model.content;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SHScreenW - 78, CGFLOAT_MAX)options:options context:nil];
    titleHeight = ceilf(rect.size.height);
    SHLog(@"%f", titleHeight)
    //10 + 头像高度 + 10+ 高度 + 10 + 60 + 20
    if (model.images.count > 0) {
        return 50 + 10 + titleHeight + 70;
    }
    
    
    return 60 + titleHeight + 20;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHServiceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHServiceCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SHServiceCommentModel *model = self.dataArray[indexPath.row];
    [cell setModel:model];
    return cell;
}

#pragma mark - SHCancelFollowDelegate
- (void)clickFollowButton
{
    SHPersonalViewController *Vc = [[SHPersonalViewController alloc] init];
    Vc.providerId = _listModel.providerId;
    [self.navigationController pushViewController:Vc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    SHLog(@"点击了第%ld张图片", index)
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    //SHLog(@"%ld", index)
}

-(void)callPhoneStr:(NSString*)phoneStr  {
    NSString *str2 = [[UIDevice currentDevice] systemVersion];
    
    if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
    {
        NSLog(@">=10.2");
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    if (@available(iOS 10.0, *)) {
                        [app openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil                                                                                ];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"是否拨打电话" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    if (@available(iOS 10.0, *)) {
                        [app openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil                                                                                ];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
