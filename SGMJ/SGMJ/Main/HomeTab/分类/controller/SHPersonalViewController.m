//
//  SHPersonalViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPersonalViewController.h"
#import "SHCatagoryListModel.h"
#import "SHRealeaseServiceModel.h"
//#import "SHNeedTingModel.h"
#import "SHPerCommentModel.h"
#import "SHPerNeedModel.h"

#import "SHPerServiceCell.h"
#import "SHPerNeedCell.h"
#import "SHPerCommentCell.h"
#import "SHNoDataTableViewFooter.h"
#import "SHNeedDetailVController.h"
#import "SHGoodDetailVController.h"
#import "SHChatViewController.h"
#import "SHPersonMainModel.h"

static NSString *serviceCell = @"SHPerServiceCell";
static NSString *needCell = @"SHPerNeedCell";
static NSString *commentCell = @"SHPerCommentCell";
@interface SHPersonalViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UILabel *focusL;
@property (weak, nonatomic) IBOutlet UILabel *fansL;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsArr;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *serviceTableView;
@property (nonatomic, strong) UITableView *needTableView;
@property (nonatomic, strong) UITableView *commentView;

@property (nonatomic, strong) NSMutableArray *serviceArray;
@property (nonatomic, strong) NSMutableArray *needArray;
@property (nonatomic, strong) NSMutableArray *commentArray;

@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *needBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


@property (nonatomic, strong) UIButton *tempBtn;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) SHPersonMainModel *personModel;

@end

@implementation SHPersonalViewController


- (NSMutableArray *)serviceArray
{
    if (!_serviceArray) {
        _serviceArray = [NSMutableArray array];
    }
    return _serviceArray;
}

- (NSMutableArray *)needArray{
    if (!_needArray) {
        _needArray = [NSMutableArray array];
    }
    return _needArray;
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    [self loadPersonalInfoData];
    
    
}


- (void)initBaseInfo
{
    self.navigationItem.title = @"个人主页";
    
    UIColor *color = [UIColor whiteColor];
    _focusView.backgroundColor = [color colorWithAlphaComponent:0.2];
    
    //阴影的颜色
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影的透明度
    _bottomView.layer.shadowOpacity = 0.9f;
    //阴影的圆角
    _bottomView.layer.shadowRadius = 4.0f;
    _bottomView.layer.shadowOffset = CGSizeMake(5,5);
    
    _headImgV.layer.cornerRadius = _headImgV.height / 2;
    _headImgV.clipsToBounds = YES;
    
    _scrollView.contentSize = CGSizeMake(3 * SHScreenW, _scrollView.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.alwaysBounceVertical = NO;//防止上下拖动
//    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.bounces = NO;
    
    
    _serviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, _scrollView.height) style:UITableViewStylePlain];
    _serviceTableView.delegate = self;
    _serviceTableView.dataSource = self;
    _serviceTableView.estimatedRowHeight = 70;
    _serviceTableView.rowHeight = 70;
    [_serviceTableView registerNib:[UINib nibWithNibName:serviceCell bundle:nil] forCellReuseIdentifier:serviceCell];
    _serviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_serviceTableView];
    
    _needTableView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW, 0, SHScreenW, _scrollView.height) style:UITableViewStylePlain];
    _needTableView.delegate = self;
    _needTableView.dataSource = self;
    _needTableView.estimatedRowHeight = 70;
    _needTableView.rowHeight =UITableViewAutomaticDimension;
    [_needTableView registerNib:[UINib nibWithNibName:needCell bundle:nil] forCellReuseIdentifier:needCell];
    _needTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_needTableView];
    
    _commentView = [[UITableView alloc] initWithFrame:CGRectMake(2 * SHScreenW, 0, SHScreenW, _scrollView.height) style:UITableViewStylePlain];
    _commentView.delegate = self;
    _commentView.dataSource = self;
    _commentView.estimatedRowHeight = 70;
    _commentView.rowHeight =UITableViewAutomaticDimension;
    [_commentView registerClass:[SHPerCommentCell class] forCellReuseIdentifier:commentCell];
    _commentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_commentView];
    
    [_serviceBtn setTitleColor:navColor forState:UIControlStateNormal];
    _tempBtn = _serviceBtn;
    
}

- (void)loadPersonalInfoData
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"customerId":@(_providerId)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHPersonalInfoUrl params:dic success:^(id JSON, int code, NSString *msg) {
//        SHLog(@"%d", code)
//        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            
            self.personModel = [SHPersonMainModel mj_objectWithKeyValues:JSON];
            
            [_headImgV sd_setImageWithURL:self.personModel.avatar placeholderImage:[UIImage imageNamed:@"defaultHead"]];
            _nameL.text = self.personModel.nickName;
            _descL.text = self.personModel.introduce;
            _phone = self.personModel.mobile;
            _focusL.text = [NSString stringWithFormat:@"关注：%d", self.personModel.followNum];
            _fansL.text = [NSString stringWithFormat:@"粉丝：%d", self.personModel.fansNum];
            
            if (SH_AppDelegate.personInfo.userId == self.personModel.customerId) {
                _bottomView.hidden = YES;
            } else {
                _bottomView.hidden = NO;
            }
            if (self.personModel.isFollow == 0) {
                [_followBtn setTitle:@"+关注" forState:UIControlStateNormal];
            } else if (self.personModel.isFollow == 1) {
                [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
            
            NSMutableArray *serArray = [SHRealeaseServiceModel mj_objectArrayWithKeyValuesArray:JSON[@"serveSupplies"]];
            NSMutableArray *neArray = [SHPerNeedModel mj_objectArrayWithKeyValuesArray:JSON[@"needs"]];
            NSMutableArray *comArray = [SHPerCommentModel mj_objectArrayWithKeyValuesArray:JSON[@"assesses"]];
            if (serArray.count > 0) {
                [weakSelf.serviceArray addObjectsFromArray:serArray];
            } else {
                SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
                self.serviceTableView.tableFooterView = footer;
            }
            if (neArray.count > 0) {
                [weakSelf.needArray addObjectsFromArray:neArray];
            } else {
                SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
                self.needTableView.tableFooterView = footer;
            }
            if (comArray.count > 0) {
                [weakSelf.commentArray addObjectsFromArray:comArray];
            } else {
                SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
                self.commentView.tableFooterView = footer;
            }
            [self.serviceTableView reloadData];
            [self.needTableView reloadData];
            [self.commentView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
}



- (IBAction)releaseButtonClick:(UIButton *)sender {
    _scrollView.contentOffset = CGPointMake(0, 0);
    if (sender == _tempBtn) {
        
    } else {
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [sender setTitleColor:navColor forState:UIControlStateNormal];
        _tempBtn = sender;
    }
}

- (IBAction)commentButtonClick:(UIButton *)sender {
    _scrollView.contentOffset = CGPointMake(SHScreenW, 0);
    if (sender == _tempBtn) {
        
    } else {
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [sender setTitleColor:navColor forState:UIControlStateNormal];
        _tempBtn = sender;
    }
}

- (IBAction)introduceButtonClick:(UIButton *)sender {
    _scrollView.contentOffset = CGPointMake(2 * SHScreenW, 0);
    if (sender == _tempBtn) {
        
    } else {
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [sender setTitleColor:navColor forState:UIControlStateNormal];
        _tempBtn = sender;
    }
}

- (IBAction)focusButtonClick:(UIButton *)sender {
    SHWeakSelf
    //比如参数就加isfollow
    NSDictionary *dic = @{
                          @"careId":@(_providerId)
                          };
    //loading框
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHFollowOtherUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        //移除loading框
        if (code == 0) {
            if (self.personModel.isFollow == 0) {
                self.personModel.isFollow = 1;
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
            } else if (self.personModel.isFollow == 1) {
                self.personModel.isFollow = 0;
                [sender setTitle:@"+关注" forState:UIControlStateNormal];
            }
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadServiceListData" object:nil];
            
        }else{
            //提示msg
        }
    } failure:^(NSError *error) {
        //移除loading框  提示
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

- (IBAction)phoneButtonClick:(UIButton *)sender {
    
    [self callPhoneStr:_phone];
}

- (IBAction)chatButtonClick:(UIButton *)sender {
    if ([SH_AppDelegate isPersonLogin]) {
        SHChatViewController *viewController = [[SHChatViewController alloc] initWithConversationChatter:_phone conversationType:EMConversationTypeChat];
        viewController.title = _nameL.text;
        viewController.phone = _phone;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [SH_AppDelegate userLogin];
    }
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


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _serviceTableView) {
        return _serviceArray.count;
    } else if (tableView == _needTableView) {
        return _needArray.count;
    } else if (tableView == _commentView) {
        return _commentArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (tableView == _serviceTableView) {
        SHPerServiceCell *cellOne = [tableView dequeueReusableCellWithIdentifier:serviceCell];
        if (!cellOne) {
            cellOne = [[SHPerServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceCell];
        }
        SHRealeaseServiceModel *model = _serviceArray[indexPath.row];
        [cellOne setModel:model];
        cell = cellOne;
    } else if (tableView == _needTableView) {
        SHPerNeedCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:needCell];
        if (!cellTwo) {
            cellTwo = [[SHPerNeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:needCell];
        }
        SHPerNeedModel *model = _needArray[indexPath.row];
        [cellTwo setModel:model];
        cell = cellTwo;
    } else if (tableView == _commentView) {
        SHPerCommentCell *cellThree = [[SHPerCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCell];
        if (!cellThree) {
            cellThree = [tableView dequeueReusableCellWithIdentifier:commentCell];
        }
        SHPerCommentModel *model = _commentArray[indexPath.row];
        [cellThree setModel:model];
        cell = cellThree;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _serviceTableView) {
        SHGoodDetailVController *vc = [[SHGoodDetailVController alloc] init];
        SHRealeaseServiceModel *model = _serviceArray[indexPath.row];
        vc.provideId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tableView == _needTableView) {
        SHNeedDetailVController *vc = [[SHNeedDetailVController alloc] init];
        SHPerNeedModel *model = _needArray[indexPath.row];
        vc.needId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tableView == _commentView) {
        
    }
    
}


#pragma mark - scrollview协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float sub = _scrollView.contentOffset.x / SHScreenW;
    int index = (int)sub;
    SHLog(@"%d", index)
    
    for (UIButton *btn in _buttonsArr) {
        if (btn.tag == 10 + index) {
            [btn setTitleColor:navColor forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
