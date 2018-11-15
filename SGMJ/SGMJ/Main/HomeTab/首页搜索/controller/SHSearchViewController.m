//
//  SHSearchViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/9/18.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSearchViewController.h"
#import "CCZSegementController.h"
#import "SHSearchListViewController.h"

@interface SHSearchViewController () <UISearchBarDelegate>


@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) CCZSegementController *outSegementController;


@end

@implementation SHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)initBaseInfo
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW -120, 40)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, titleView.width, titleView.height)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    searchBar.backgroundImage = [[UIImage alloc] init];
    [searchBar setImage:[UIImage imageNamed:@"search"]
       forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [titleView addSubview:searchBar];
    
    _searchBar = searchBar;
    
    //更改search圆角
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:SHColorFromHex(0xb7dbf7)];
        searchField.layer.cornerRadius = 20.0;
        searchField.layer.masksToBounds = YES;
        [searchField setValue:[UIFont boldSystemFontOfSize:14.0] forKeyPath:@"_placeholderLabel.font"];
        
    }
    self.navigationItem.titleView = titleView;
    
    CGFloat status_H = [UIApplication sharedApplication].statusBarFrame.size.height +  44;
    CGRect rect = CGRectMake(self.view.x, 0, SHScreenW, SHScreenH - status_H);
    NSArray *titleArray = @[@"服务", @"需求"];
    NSArray *orderStatusArr = @[@"SERVER",@"NEED"];
    NSMutableArray *childVCArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < titleArray.count; i ++) {
        SHSearchListViewController *vc = [[SHSearchListViewController alloc] init];
        vc.status = orderStatusArr[i];
        vc.searchString = _searchBar.text;
        [childVCArr addObject:vc];
    }
    self.outSegementController = [CCZSegementController segementControllerWithFrame:rect titles:titleArray];
    [self.outSegementController setSegementViewControllers:[childVCArr copy]];
    self.outSegementController.normalColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.outSegementController.segementTintColor = [UIColor colorWithRed:0 / 255.0 green:158 / 255.0 blue:231 / 255.0 alpha:1];
    self.outSegementController.style = CCZSegementStyleFlush;
    [self addChildViewController:self.outSegementController];
    [self.view addSubview:self.outSegementController.view];
    
}



#pragma mark - UISearchBar代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SHLog(@"%@", searchBar.text)
    [searchBar resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
