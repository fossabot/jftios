//
//  SHAnswerQuesVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAnswerQuesVController.h"
#import "SH_QuestionViewCell.h"
#import "SH_SectionView.h"
#import "SHHomeListModel.h"


#import "SHAnswerHeaderView.h"
#import "SHSeleteAnswerCell.h"
#import "SHAnswerSectionHeaderView.h"
#import "SHAdverDetailModel.h"
#import "SHAnswerItemModel.h"
#import "SHAnswerFooterView.h"
#import "SHAnswerHeaderViewSub.h"

@interface SHAnswerQuesVController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *problemsList;

@property (nonatomic, strong) NSMutableArray *answerArray;
@property (nonatomic, strong) NSMutableArray *correctArray;
@property (nonatomic, strong) NSArray *abcdefgArr;

@end

@implementation SHAnswerQuesVController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.abcdefgArr = @[@"A、",@"B、",@"C、",@"D、",@"E、",@"F、",@"G、",@"H、",@"I、",@"J、",@"K、",@"L、",@"M、",@"N、"];
    
    [self initUI];
    self.navigationItem.title = self.listModel.title;
    [self loadAdvertiseDetailData];
    
    _correctArray = [[NSMutableArray alloc] init];
    _answerArray = [[NSMutableArray alloc] init];
}

- (void)initUI
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    SHAnswerFooterView *footerView = [[SHAnswerFooterView alloc]initWithFrame:CGRectMake(0, 0, SHScreenW, 100)];
    SHWeakSelf
    footerView.commitBlock = ^{
      //点击提交
        [weakSelf commit];
    };
    self.tableView.tableFooterView = footerView;
}

- (void)loadAdvertiseDetailData
{
    SHLog(@"%d", _modelId)
    SHWeakSelf
    NSDictionary *dic = @{
                          @"adId":@(_modelId)
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHAdverDetailUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            NSDictionary *responDict = (NSDictionary *)JSON;
            NSDictionary *ad = responDict[@"ad"];
            SHAdverDetailModel *model = [SHAdverDetailModel mj_objectWithKeyValues:ad];

//            self.problemsList = [SHAnswerItemModel mj_objectArrayWithKeyValuesArray:model.problems];
            self.problemsList = model.problems;
            //计算model的高度，返回model
//            for (int i = 0; i < self.problemsList.count; i++) {
//                SHAnswerItemModel *model = self.problemsList[i];
//                self.problemsList[i] = [model calculateHeight:model];
//            }
            [self setUpHeaderViewWith:model];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 根据接口返回数据去设置头视图

 @param model 大的模型
 */
- (void)setUpHeaderViewWith:(SHAdverDetailModel *)model
{
//    NSString *introduce = model.introduce;
//    CGRect rect = [introduce boundingRectWithSize:CGSizeMake(SHScreenW - 26, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f ]} context:nil];
//    SHAnswerHeaderView *headerView = [[SHAnswerHeaderView alloc]initWithFrame:CGRectMake(0, 0, SHScreenW, 315 + rect.size.height)];
    
    SHAnswerHeaderViewSub *headerView = [[SHAnswerHeaderViewSub alloc] init];
    headerView.model = model;
    self.tableView.tableHeaderView = headerView;
    
}

//提交
- (void)commit
{
    [_answerArray removeAllObjects];
    for (int i = 0; i < self.problemsList.count; i ++) {
        SHAnswerItemModel *model = self.problemsList[i];
        if (model.seleteIndex == -1) {
            [MBProgressHUD showMBPAlertView:@"题目必须全部解答哦！" withSecond:2.0];
            return;
        }
        NSString *str = model.isCorrect ? @"答对了" : @"答错了";
        SHLog(@"第%ld题%@,正确答案%@，你选择了第%ld个",i,str,model.correctResponse,model.seleteIndex);
        [_correctArray addObject:model.correctResponse];
        if (model.seleteIndex == 0) {
            [_answerArray addObject:@"A"];
        } else if (model.seleteIndex == 1) {
            [_answerArray addObject:@"B"];
        } else if (model.seleteIndex == 2) {
            [_answerArray addObject:@"C"];
        }
    }
   
    SHLog(@"答案：%@", _answerArray)
    [self dealWithAnswerWith:_answerArray];
//    if ([_answerArray[0] isEqualToString:_correctArray[0]] && [_answerArray[1] isEqualToString:_correctArray[1]]) {
//        //全部答对
//        [self dealWithAnswerWith:0];
//    } else {
//        //答错了
//        [self dealWithAnswerWith:1];
//    }
    
}

//处理答案
- (void)dealWithAnswerWith:(NSArray *)answer
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"adId":@(_modelId),
                          @"answer1":answer[0],
                          @"answer2":answer[1]
                          };
    SHLog(@"%@",dic)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHAnswerCommitUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"answerCorrect" object:nil];

        } else if (code == 500) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {

    }];
}



#pragma mark --- UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    SHLog(@"%d", self.problemsList.count)
    return self.problemsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHSeleteAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHSeleteAnswerCell class])];
    if (!cell) {
        cell = [[SHSeleteAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SHSeleteAnswerCell class])];
    }
    SHAnswerItemModel *model = self.problemsList[indexPath.section];
    
    cell.questionStr = model.questionsArr[indexPath.row];
    cell.questionAbcd = self.abcdefgArr[indexPath.row];
    
    if (indexPath.row == model.seleteIndex) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHAnswerItemModel *model = self.problemsList[indexPath.section];
    
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([SHSeleteAnswerCell class]) configuration:^(SHSeleteAnswerCell *cell) {
        
        cell.questionStr = model.question;
    }];
    
    switch (indexPath.row) {
        case 0:
            return  model.answerAHeight;
            break;
        case 1:
            return  model.answerBHeight;
            break;
        case 2:
            return  model.answerCHeight;
            break;
        default:
            break;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SHAnswerItemModel *model = self.problemsList[section];
    SHAnswerSectionHeaderView *sectionHeaderView = [[SHAnswerSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, SHScreenW, model.questionHeight) section:section quesionStr:model.question];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SHAnswerItemModel *model = self.problemsList[section];
    return model.questionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHAnswerItemModel *model = self.problemsList[indexPath.section];
    if (model.seleteIndex == indexPath.row) {
        return;
    }
    
#warning 数据格式不对  应该将每道题的选项都包成一个数组  在这个section的下面
    model.seleteIndex = indexPath.row;
    self.problemsList[indexPath.section] = model;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}








#pragma mark - lazy method

- (NSMutableArray *)problemsList
{
    if (!_problemsList) {
        _problemsList = [[NSMutableArray alloc]init];
    }
    return _problemsList;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        if (@available(iOS 11.0, *)) {
        //            _tableView.estimatedRowHeight = 0;
        //            _tableView.estimatedSectionFooterHeight = 0;
        //            _tableView.estimatedSectionHeaderHeight = 0;
        //        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
