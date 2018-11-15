//
//  SHMyReleaseVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMyReleaseVController.h"

#import "SHMyReleaseCell.h"

#import "SHOrderLisrChildViewController.h"
#import "CCZSegementController.h"
#import "SHOutShelvesVController.h"

@interface SHMyReleaseVController ()


@property (nonatomic, strong) CCZSegementController *inSegementController;

@property (nonatomic, strong) CCZSegementController *outSegementController;


@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation SHMyReleaseVController

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




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"我的发布";
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下架商品" style:UIBarButtonItemStyleDone target:self action:@selector(shevesGoodsFunction)];
    [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.0],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    CGFloat status_H = [UIApplication sharedApplication].statusBarFrame.size.height +  44;
    CGRect rect = CGRectMake(self.view.x, 0, SHScreenW, SHScreenH - status_H);
    NSArray *titleArray = @[@"推广", @"服务", @"需求"];
    NSArray *orderStatusArr = @[@"ad",@"serve",@"need"];
    NSMutableArray *childVCArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < titleArray.count; i ++) {
        SHOrderLisrChildViewController *vc = [[SHOrderLisrChildViewController alloc]init];
        vc.orderStatus = orderStatusArr[i];
        vc.isShelve = 0;
        vc.listType = SHMyReleaseType;
        [childVCArr addObject:vc];
    }
    self.outSegementController = [CCZSegementController segementControllerWithFrame:rect
                                                                            titles:titleArray];
    [self.outSegementController setSegementViewControllers:[childVCArr copy]];
    self.outSegementController.normalColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.outSegementController.segementTintColor = [UIColor colorWithRed:0 / 255.0 green:158 / 255.0 blue:231 / 255.0 alpha:1];
    self.outSegementController.style = CCZSegementStyleFlush;
    [self addChildViewController:self.outSegementController];
    [self.view addSubview:self.outSegementController.view];
    
    
    
}


- (void)shevesGoodsFunction
{
    SHOutShelvesVController *vc = [[SHOutShelvesVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
