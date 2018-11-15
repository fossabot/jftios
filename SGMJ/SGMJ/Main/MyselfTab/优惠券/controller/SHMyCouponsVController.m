//
//  SHMyCouponsVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMyCouponsVController.h"

#import "SHCouponsCell.h"

static NSString *identityCell = @"SHCouponsCell";
@interface SHMyCouponsVController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@property (nonatomic, strong) UIButton *temptn;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SHMyCouponsVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
}

- (void)initBaseInfo
{
    //以下两行代码根据需要设置
    self.edgesForExtendedLayout = YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.navigationItem.title = @"优惠券";
    for (UIButton *btn in _allButtons) {
        if (btn.tag == 10) {
            _temptn = btn;
            [_temptn setTitleColor:navColor forState:UIControlStateNormal];
            _colorLabel.backgroundColor = navColor;
        }
    }
    
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    
}





- (IBAction)buttonsClick:(UIButton *)sender {
    for (UIButton *btn in _allButtons) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:navColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                _colorLabel.center = CGPointMake(btn.centerX, btn.height + 1);
            }];
        } else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    return cell;
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
