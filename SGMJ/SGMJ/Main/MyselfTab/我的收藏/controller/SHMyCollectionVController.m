//
//  SHMyCollectionVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMyCollectionVController.h"

#import "SHMyCollectionCell.h"
#import "SHCollectionCell.h"

static NSString *identityCell = @"SHCollectionCell";
@interface SHMyCollectionVController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SHMyCollectionVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"我的收藏";
    
    [_tableView registerClass:[SHCollectionCell class] forCellReuseIdentifier:identityCell];
    
//    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 13+60+15+80+15+20+15+0.5+42;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 13)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    
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
