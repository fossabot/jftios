//
//  CitySelectedViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "CitySelectedViewController.h"
#import "SHCityPickerTableView.h"
#import "SHCityModel.h"
#import "SHCityIntial.h"


@interface CitySelectedViewController () <SHBaseTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) SHCityPickerTableView *cityTableView;

@end

@implementation CitySelectedViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self setupTableView];
    [self addNotification];
    
}

- (void)initBaseInfo
{
    
}


- (IBAction)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  tableview
 */
- (void)setupTableView
{
    self.cityTableView = [[SHCityPickerTableView alloc] initWithFrame:CGRectMake(0, 64, SHScreenW, SHScreenH - 64) style:UITableViewStylePlain];
    self.cityTableView.sd_delegate = self;
    [self.view addSubview:self.cityTableView];
    self.cityTableView.dataArray = self.dataArr;
    [self.cityTableView reloadData];
    
}

/**
 *  NSNotification
 */
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidSelected:) name:SDCityDidSelectedNotification object:nil];
}

-(void)cityDidSelected:(NSNotification *)notif
{
    NSDictionary *userInfo = notif.userInfo;
    SHCityModel *city = userInfo[SDCityDidSelectKey];
    SHLog(@"cityName:%@", city.name)
    
    if (self.cityPickerBlock) {
        self.cityPickerBlock(city);
    }
    [self dismissViewControllerAnimated:nil completion:nil];
}

#pragma mark - SHBaseTableViewDelegate
- (void)tableView:(id)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHCityIntial *cityInModel = self.dataArr[indexPath.section];
    SHCityModel *cityModel = cityInModel.cityArrs[indexPath.row];
    SHLog(@"cityName:%@", cityModel.name)
    if (self.cityPickerBlock) {
        self.cityPickerBlock(cityModel);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  3.销毁通知
 */
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
