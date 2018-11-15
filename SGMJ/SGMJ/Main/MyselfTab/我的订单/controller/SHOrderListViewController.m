//
//  SHOrderListViewController.m
//  SGMJ
//
//  Created by 曾建国 on 2018/8/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHOrderListViewController.h"
#import "SHOrderLisrChildViewController.h"
#import "CCZSegementController.h"
@interface SHOrderListViewController ()
@property (nonatomic, strong) CCZSegementController *inSegementController;
@property (nonatomic, strong) CCZSegementController *outSegementController;
@end

@implementation SHOrderListViewController


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
    [self createSegMentController];
    [self initOutSegementController];
    [self initInSegementController];
}

//创建导航栏分栏控件
-(void)createSegMentController{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"消费",@"收入",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, 122, 30);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = navColor;
    //NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    //[segmentedControl setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    //我定义了一个 NSInteger tag，是为了记录我当前选择的是分段控件的左边还是右边。
    NSInteger selecIndex = sender.selectedSegmentIndex;
    switch(selecIndex){
        case 0:
            self.inSegementController.view.hidden = NO;
            self.outSegementController.view.hidden = YES;
            sender.selectedSegmentIndex = 0;
            break;
            
        case 1:
            self.inSegementController.view.hidden = YES;
            self.outSegementController.view.hidden = NO;
            sender.selectedSegmentIndex = 1;
          
            break;
            
        default:
            break;
    }
}


- (void)initInSegementController
{
    CGFloat status_H = [UIApplication sharedApplication].statusBarFrame.size.height +  44;
    CGRect rect = CGRectMake(0, 0, SHScreenW, SHScreenH - status_H);
    NSArray *titleArray = @[@"全部", @"待付款", @"待服务", @"待确认", @"待评价"];
    NSArray *orderStatusArr = @[@"",@"INIT",@"RECEIVE",@"UN_CONFIRMED",@"UN_EVALUATION"];
    NSMutableArray *childVCArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < titleArray.count; i ++) {
        SHOrderLisrChildViewController *vc = [[SHOrderLisrChildViewController alloc]init];
        vc.orderStatus = orderStatusArr[i];
        vc.isCustomer = 0;
        vc.listType = SHOrderType;
        [childVCArr addObject:vc];
    }
    self.inSegementController = [CCZSegementController segementControllerWithFrame:rect
                                                                            titles:titleArray];
    [self.inSegementController setSegementViewControllers:[childVCArr copy]];
    self.inSegementController.normalColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.inSegementController.segementTintColor = [UIColor colorWithRed:0 / 255.0 green:158 / 255.0 blue:231 / 255.0 alpha:1];
    self.inSegementController.style = CCZSegementStyleFlush;
    [self addChildViewController:self.inSegementController];
    [self.view addSubview:self.inSegementController.view];
    [self.inSegementController setSelectedItemAtIndex:self.index];
    
    
}

- (void)initOutSegementController
{
    CGFloat status_H = [UIApplication sharedApplication].statusBarFrame.size.height +  44;
    CGRect rect = CGRectMake(0, 0, SHScreenW, SHScreenH - status_H);
    NSArray *titleArray = @[@"全部", @"待服务", @"待确认", @"待评价"];
    NSArray *orderStatusArr = @[@"",@"RECEIVE",@"UN_CONFIRMED",@"UN_EVALUATION",];
    NSMutableArray *childVCArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i ++) {
        SHOrderLisrChildViewController *vc = [[SHOrderLisrChildViewController alloc]init];
        vc.orderStatus = orderStatusArr[i];
        vc.isCustomer = 1;
        vc.listType = SHOrderType;
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

@end
