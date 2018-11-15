//
//  Home_ViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "Home_ViewController.h"
#import "SH_QuestionViewCell.h"
#import "SH_SectionView.h"
#import "SDCycleScrollView.h"
#import "SH_HomeHeaderView.h"
#import "SHHomeListModel.h"
#import "SHHomeBannerModel.h"
#import "SHHomeCatagoryModel.h"

#import "SHInfomationBaseModel.h"

#import "SH_CatagoryVController.h"
#import "SHAnswerQuesVController.h"

#import "CitySelectedViewController.h"
#import "SHCityModel.h"
#import "SHCityIntial.h"
#import "CitySelectedViewController.h"
//地名-->经纬度
#import <CoreLocation/CoreLocation.h>

#import "SHLoginViewController.h"

#import "SH_TestViewController.h"
#import "ViewController.h"
#import "SH_SHSoundPlayer.h"
#import "SH_PictureScanView.h"
#import "SH_TwoViewController.h"
#import "SHPaySelectView.h"
#import "SHPayPwdView.h"
#import "SHRedPackageV.h"
#import "SHRelCataModel.h"
#import "SHSearchViewController.h"
#import "SHHomeSearchVController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "InfomationSingleImageCell.h"
#import "InfomationThreeImagesCell.h"
#import "SH_HomeModuleTableViewCell.h"

#import "SH_HomeBannerTableViewCell.h"
#import "SH_HomeCategoryTableViewCell.h"


static NSString *sectionView = @"SH_SectionView";

//static CGFloat borderMargin = 27;
//static CGFloat spaceMargin = (SHScreenW - 4 * 40) / 5;
static CGFloat topMargin = 17;//
#define ANGLE_TO_RADIAN(angle) ((angle)/180 * M_PI)
#define historyCityFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"historyCity.data"]

@interface Home_ViewController () <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SH_HomeHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *listArray;//答题数据源
@property (nonatomic, strong) NSMutableArray *bannerArray;//轮播图数据源
@property (nonatomic, strong) NSMutableArray *categoryArray;//技能服务的数据源
@property (nonatomic, strong) NSMutableArray *imgArray;//轮播图图片数组（要这个干啥用啊）
@property (nonatomic, strong) NSMutableArray *infomationArr;//信息流数据源


//导航栏上的搜索框
@property (nonatomic, strong) UIView *navBackView;
@property (nonatomic, strong) UIImageView *navBackImageView;
@property (strong, nonatomic) UIButton *cityButton;
@property (nonatomic, strong) UIImageView *cityDropImage;
@property (nonatomic, strong) UIButton *searchButton;


@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *dataArr;      //城市数据
/**
 热门
 */
@property (nonatomic,strong)NSMutableArray *hotArr;
/**
 历史
 */
@property (nonatomic,strong)NSMutableArray *historyArr;
/**
 历史选择
 */
@property (nonatomic,strong)NSMutableArray *historySelectArr;
/**
 当前选择
 */
@property (nonatomic,strong)NSMutableArray *selectArr;


@property (nonatomic, copy) NSString *timeStamp;



@end

@implementation Home_ViewController
{
    BOOL _isNavColor;//现在是否为导航栏的主体色，默认不是，为阴影
    UIStatusBarStyle _preferStyle;//状态栏的颜色
}


#pragma mark - lifeCycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self refreshStatusBar];
}

- (void)refreshStatusBar {
    if (self.preferredStatusBarStyle != _preferStyle) {
        
        [kApplication setStatusBarStyle:_preferStyle animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self refreshStatusBar];
    SHLog(@"%@", SH_AppDelegate.personInfo.city)
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航控制器的代理为self
    self.navigationController.delegate = self;
    _preferStyle = UIStatusBarStyleLightContent;
    [self initBaseInfo];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerCorrectFunction) name:@"answerCorrect" object:nil];
    
    NSString *city = SH_AppDelegate.personInfo.city ? SH_AppDelegate.personInfo.city : @"北京";
    [_cityButton setTitle:city forState:UIControlStateNormal];
    
}



#pragma mark - private method

//初始化
- (void)initBaseInfo
{
    _isNavColor = NO;
    _preferStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_shadowImage"] forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:self.tableView];

    _currentPage = 0;
    
    //解决tableview的headerview看似下一statusBar高度的方法
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
    _listArray = [NSMutableArray array];
    _bannerArray = [NSMutableArray array];
    _categoryArray = [NSMutableArray array];
    _infomationArr = [NSMutableArray array];
    
    //隐藏tableview滑动条隐藏
    _tableView.showsVerticalScrollIndicator = NO;
    
    //解决tableview滑动时底部被tabbar遮挡问题
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    SHWeakSelf
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.imgArray removeAllObjects];
        [weakSelf.listArray removeAllObjects];
        [weakSelf.categoryArray removeAllObjects];
        [weakSelf.infomationArr removeAllObjects];
        [weakSelf loadData];
    }];
    
    
    //设置俯视图圆角透明度
    
//    UIImageView *navBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 44)];
//    navBackImageView.userInteractionEnabled = YES;
    
    [self initNavView];
}


//初始化导航栏的视图
- (void)initNavView {
    
    UIView *navBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, Nav_height)];
    self.navBackView = navBackView;
    [self.view addSubview:navBackView];
    [self.view bringSubviewToFront:navBackView];
    
    [navBackView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(Nav_height);
    }];
    
    UIImageView *navBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_shadowImage"]];
    navBackImageView.frame = navBackView.bounds;
    navBackImageView.userInteractionEnabled = YES;
    [navBackView addSubview:navBackImageView];
    self.navBackImageView = navBackImageView;
    
    [navBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.edges.mas_equalTo(navBackView);
    }];
    

    [navBackView addSubview:self.cityButton];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cityDrop"]];
    self.cityDropImage = image;
    [self.navBackView addSubview:image];
    [image setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [navBackView addSubview:self.searchButton];
    
    [self.cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftArightMargin);
        make.bottom.mas_equalTo(-contentMargin);
        make.height.mas_equalTo(26);
    }];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.cityButton.mas_right).offset(3);
        make.centerY.mas_equalTo(self.cityButton);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(image.mas_right).offset(leftArightMargin);
        make.centerY.mas_equalTo(image);
        make.height.mas_equalTo(26);
        make.right.mas_equalTo(-2*leftArightMargin);
    }];
    
    
}


//回答完问题  重新进行数据加载
- (void)answerCorrectFunction
{
    [self.imgArray removeAllObjects];
    [self.listArray removeAllObjects];
    [self.categoryArray removeAllObjects];
    [self.infomationArr removeAllObjects];
    [self loadData];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //判断要显示的控制器是否是自己的
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}



- (void)loadData {
    
    SHWeakSelf
    //后面需要根据地区获取数据
    NSDictionary *dic = @{
                          @"lng": @(SH_AppDelegate.personInfo.longitude),
                          @"lat": @(SH_AppDelegate.personInfo.latitude)
                          };
    SHLog(@"%@", dic)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHHomeDataUrl params:dic success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%d", code)
        //SHLog(@"%@", JSON)
        if (code == 0) {
            [_tableView.mj_header endRefreshing];
            weakSelf.tableView.hidden = NO;
            [MBProgressHUD hideHUDForView:weakSelf.view];
            NSArray *array = [SHHomeBannerModel mj_objectArrayWithKeyValuesArray:JSON[@"banners"]];
            SHLog(@"%@", array)
            
            for (SHHomeBannerModel *model in array) {
                if (weakSelf.imgArray.count == array.count) {
                    
                } else {
                    [weakSelf.imgArray addObject:model.image];
                }
            }
            SHLog(@"%@", weakSelf.imgArray)
            
            //轮播图的数据源赋值
            //            _webCycleScrollView.imageURLStringsGroup = weakSelf.imgArray;
            
            //技能服务分类的数据源
            NSArray *catagArr = [SHHomeCatagoryModel mj_objectArrayWithKeyValuesArray:JSON[@"categories"]];
            
            [weakSelf.categoryArray addObjectsFromArray:catagArr];
            
            //            [weakSelf catagoryScrollViewWithArray:_categoryArray];
//            [weakSelf renderHeader];
            
            
            //答题的数据源
            NSArray *listArr = [SHHomeListModel mj_objectArrayWithKeyValuesArray:JSON[@"ads"]];
            [_listArray addObjectsFromArray:listArr];
            
            NSArray *infomationArr = [SHInfomationBaseModel mj_objectArrayWithKeyValuesArray:JSON[@"lifeskills"]];
//            [self.infomationArr removeAllObjects];
            [self.infomationArr addObjectsFromArray:infomationArr];
            [_tableView reloadData];
            
        } else {
            SHLog(@"首页请求")
        }
        
    } failure:^(NSError *error) {
        
        SHLog(@"%@", error)
        if (error) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            weakSelf.tableView.hidden = YES;
        }
    }];
}

/**
 *  城市选择
 */
- (void)cityButtonClick:(UIButton *)sender {
    SHWeakSelf
    if (AppDelegate.isLocationServiceOpen) {
        CitySelectedViewController *vc = [[CitySelectedViewController alloc] init];
        vc.cityPickerBlock = ^(SHCityModel *city) {
            [weakSelf.cityButton setTitle:city.name forState:UIControlStateNormal];
            [weakSelf setSelectCityModel:city];
            //将城市转换成经纬度
            //地址-->经纬度
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:city.name completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                SHLog(@"反编码个数：%ld", [placemarks count])
                if ([placemarks count] > 0) {
                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                    CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                    NSString *strCoordinate = [NSString stringWithFormat:@"经度:%3.5f 纬度:%3.5f:", coordinate.latitude, coordinate.longitude];
                    SHLog(@"%@", strCoordinate)
                } else {
                    SHLog(@"转经纬度失败")
                }
            }];
        };
        vc.dataArr = [NSMutableArray arrayWithArray:self.dataArr];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        
        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"地址选择需要您开启定位服务，设置-家服通-位置，以便更好地为您提供准确的信息！！！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *act2=[UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }];
        [controller addAction:act1];
        [controller addAction:act2];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
        
    }
    
}

//搜索
- (void)searchButtonClick:(UIButton *)sender {
    
    SHHomeSearchVController *vc = [[SHHomeSearchVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//渲染表视图的头部两个子视图（轮播和技能服务分类）
- (void)renderHeader {
    
    [self.headerView setBannerArr:self.imgArray];
    [self.headerView setCategoryArr:self.categoryArray];
    self.tableView.tableHeaderView = self.headerView;
}


// 点击事件
-(void)singleTap:(NSInteger)num
{
    
    //处理单击操作
    SHHomeCatagoryModel *model = _categoryArray[num];
    SHLog(@"被点击的名字：%@--%ld", model.name, (long)model.ID)
    
    SH_CatagoryVController *vc = [[SH_CatagoryVController alloc] init];
    vc.model = model;
    if (AppDelegate.isLocationServiceOpen)
    {
        vc.city = self.cityButton.currentTitle;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    SHLog(@"contentOffsetY  ==  %lf",contentOffsetY);
    CGFloat headerH = 0;
    
    CGFloat alpha = contentOffsetY / (float)Nav_height;//上滑至导航栏高度时，改变导航栏图片为导航图片
    
    UIColor *backColor;
    
    if (alpha >= 1.f) {
        alpha = 1.f;
        backColor = SH_WhiteColor;
    }else if (alpha <= 0.f) {
        alpha = 0.f;
    }else {
        backColor = [SH_WhiteColor colorWithAlphaComponent:alpha];
    }
    CGFloat rgb = (1-alpha)*255.f;
    
    if (contentOffsetY > 0 && alpha <= 1) {//上滑就改变背景色为主题色渐变alpha值至1
        _isNavColor = YES;
        
        [self.cityButton setTitleColor:SH_RGBA(rgb, rgb, rgb, 1) forState:UIControlStateNormal];
        [self.searchButton setTitleColor:SH_RGBA(rgb, rgb, rgb, 1) forState:UIControlStateNormal];
        _preferStyle = UIStatusBarStyleDefault;
        [self refreshStatusBar];
//        [kApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        self.navBackView.backgroundColor = backColor;
        self.navBackImageView.image = [UIImage new];

    }else if(contentOffsetY > Nav_height) {
        self.navBackView.backgroundColor = SH_WhiteColor;
        self.cityDropImage.image = SHImageNamed(@"cityDropBlack");
    }
    else if(contentOffsetY <= 0 && _isNavColor == YES) {//下滑至头部或者往下拖为负值，这时将导航栏设为阴影背景图,只需要等于0的时候改一次就行，避免重复调用
        
        [self.cityButton setTitleColor:SH_RGBA(rgb, rgb, rgb, 1) forState:UIControlStateNormal];
        [self.searchButton setTitleColor:SH_RGBA(rgb, rgb, rgb, 1) forState:UIControlStateNormal];
        self.cityDropImage.image = SHImageNamed(@"cityDrop");
        
        _isNavColor = NO;
        _preferStyle = UIStatusBarStyleLightContent;
        [self refreshStatusBar];
//        [kApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        self.navBackImageView.image = [UIImage imageNamed:@"nav_shadowImage"];
        self.navBackView.backgroundColor = SH_ClearColor;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    //停止拖动，即将减速
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    CGFloat offsetX = targetContentOffset -> x;
//    _currentPage = offsetX / SHScreenW;
//
//    //UIView *cirView = (UIView *)[_pageView viewWithTag:_currentPage + 1];
//    //cirView.backgroundColor = navColor;
//    for (UIView *cirView in _pageView.subviews) {
//        if (cirView.tag == _currentPage + 1) {
//            cirView.backgroundColor = navColor;
//        } else {
//            cirView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        }
//    }
//}




#pragma mark - UITableViewDelegate, UITableViewDataSource,
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section <= 2 ) {
        return 1;
    }else if(section == 3) {
        
        return _listArray.count;
    }else {
        return _infomationArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHWeakSelf
    if (indexPath.section == 0) {
        
        SH_HomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SH_HomeBannerTableViewCellId forIndexPath:indexPath];
        
        cell.dataSource = self.imgArray;
        cell.selectBlock = ^(NSInteger num) {
            
            SHLog(@"点击了banner视图的第%ld个",num)
        };
        
        return cell;
        
    }else if (indexPath.section == 1) {
    
        SH_HomeCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SH_HomeCategoryTableViewCellId forIndexPath:indexPath];
        
        cell.categoryArr = self.categoryArray;
        cell.clickBlock = ^(NSInteger num) {
          
            SH_CatagoryVController *vc = [[SH_CatagoryVController alloc] init];
            vc.model = _categoryArray[num];
            vc.city = SH_AppDelegate.personInfo.city;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
        
    }else if (indexPath.section == 2) {
        
        SH_HomeModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SH_HomeModuleTableViewCellId];
        if (!cell) {
            cell = [[SH_HomeModuleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SH_HomeModuleTableViewCellId];
        }
        
        cell.clickBlock = ^(NSIndexPath *indexPath) {
          
            SHLog(@"点击了四大板块的第%ld个",indexPath.row)
        };
        return cell;
    }else if (indexPath.section == 3) {
        
        SH_QuestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SH_QuestionViewCellId forIndexPath:indexPath];
        
        if (_listArray.count > 0) {
            SHHomeListModel *model = _listArray[indexPath.row];
            [cell setListModel:model];
        }
        
        return cell;
    }else {
        
        if (_infomationArr.count > 0) {
            
            SHInfomationBaseModel *model = _infomationArr[indexPath.row];
        
            if (model.cellType == InfomationCellTypeSingleImage) {
                
                InfomationSingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:InfomationSingleImageCellId forIndexPath:indexPath];
                
                cell.title.text = model.title;
                cell.time.text = model.createtime;
                [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageurl[0]]];
                return cell;
                
            }else if (model.cellType == InfomationCellTypeThreeImages) {
                InfomationThreeImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:InfomationThreeImagesCellId forIndexPath:indexPath];
                
                cell.title.text = model.title;
                cell.time.text = model.createtime;
                [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageurl[0]]];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:model.imageurl[1]]];
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:model.imageurl[2]]];
                
                return cell;
            }
        }
    }
    return [UITableViewCell new];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return moduleRatio * SHScreenW;
    }else if (indexPath.section == 1) {
        
        return moduleRatio * SHScreenW;
        
    }else if (indexPath.section == 2) {
        
        return moduleRatio * SHScreenW;
    }else if (indexPath.section == 3) {
        
        return 130;
    }else {
        
        SHInfomationBaseModel *model = _infomationArr[indexPath.row];
        if (model.cellType == InfomationCellTypeSingleImage) {
            
            CGFloat height = [tableView fd_heightForCellWithIdentifier:InfomationSingleImageCellId cacheByIndexPath:indexPath configuration:^(InfomationSingleImageCell *cell) {
                [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageurl[0]]];
                cell.title.text = model.title;
                cell.time.text = model.createtime;
            }];
            NSLog(@"cache singlecell高度  %f",height);
            return height;
            
        }else if (model.cellType == InfomationCellTypeThreeImages) {
            
            CGFloat height = [tableView fd_heightForCellWithIdentifier:InfomationThreeImagesCellId cacheByIndexPath:indexPath configuration:^(InfomationThreeImagesCell *cell) {
                cell.title.text = model.title;
                cell.time.text = model.createtime;
                [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageurl[0]]];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:model.imageurl[1]]];
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:model.imageurl[2]]];
                
            }];
            
            NSLog(@"cache threecell高度  %f",height);
            return height;
        }
        return 0.f;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 1)];
    if (section == 0) {
        
        view.backgroundColor = SH_WhiteColor;
    }else {
        view.backgroundColor = SH_GroupBackgroundColor;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    SH_SectionView *view = [[SH_SectionView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 50)];
    
    if (section == 3) {
        view.title.text = @"答题奖励";
        view.imageView.image = [UIImage imageNamed:@"home_answerSection"];
    }else if (section == 4) {
        view.title.text = @"生活技巧";
        view.imageView.image = [UIImage imageNamed:@"home_liveSection"];
    }else {
        //        return [UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 8);
        return [UIView new];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section <= 2) {
        return 0.01;
    }
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 8.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        SHLog(@"点击了banner");
    }else if (indexPath.section == 1) {
        
        
    }else if (indexPath.section == 2) {
        
        
    }else if (indexPath.section == 3) {
        
        SHAnswerQuesVController *vc = [[SHAnswerQuesVController alloc] init];
        SHHomeListModel *model = _listArray[indexPath.row];
        vc.modelId = model.ID;
        SHLog(@"%d", vc.listModel.ID)
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        SHLog(@"点击了生活技巧  row= %ld",indexPath.row)
        
    }
    
}





#pragma mark - 城市数据
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *cityModels = [NSMutableArray array];
        
        //获取全部城市cityModel
        for (NSDictionary *dic in arr) {
            for (NSDictionary *dict in dic[@"children"]) {
                SHCityModel *cityModel = [SHCityModel cityWithDict:dict];
                [cityModels addObject:cityModel];
            }
        }
        
        //获取首字母
        NSMutableArray *indexArr = [[cityModels valueForKeyPath:@"firstLetter"] valueForKeyPath:@"@distinctUnionOfObjects.self"];
        
        //遍历数组
        for (NSString *indexStr in indexArr) {
            SHCityIntial *cityInitial = [[SHCityIntial alloc] init];
            cityInitial.initial = indexStr;
            NSMutableArray *cityArrs = [NSMutableArray array];
            for (SHCityModel *cityModel in cityModels) {
                if ([indexStr isEqualToString:cityModel.firstLetter]) {
                    [cityArrs addObject:cityModel];
                }
            }
            cityInitial.cityArrs = cityArrs;
            [_dataArr addObject:cityInitial];
            
        }
        [_dataArr insertObjects:self.hotArr atIndexes:[NSIndexSet indexSetWithIndex:0]];
        [_dataArr insertObjects:self.historyArr atIndexes:[NSIndexSet indexSetWithIndex:0]];
        [_dataArr insertObjects:self.selectArr atIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
    
    return _dataArr;
}

/**
 *  热门hotArr
 */
- (NSMutableArray *)hotArr
{
    if(!_hotArr){
        _hotArr = [NSMutableArray array];
        SHCityIntial *cityInitial =[[SHCityIntial alloc]init];
        cityInitial.initial = @"热门";
        
        NSArray *hotCityArr =@[@{@"id":@"1",@"name":@"北京",@"pid":@"11"},
                               @{@"id":@"2",@"name":@"上海",@"pid":@"11"},
                               @{@"id":@"3",@"name":@"广州",@"pid":@"11"},
                               @{@"id":@"4",@"name":@"深圳",@"pid":@"11"},
                               @{@"id":@"4",@"name":@"成都",@"pid":@"11"},
                               @{@"id":@"4",@"name":@"杭州",@"pid":@"11"},
                               ];
        NSMutableArray *hotarrs =[NSMutableArray array];
        
        for (NSDictionary *dic in hotCityArr){
            SHCityModel *city = [SHCityModel cityWithDict:dic];
            [hotarrs addObject:city];
        }
        cityInitial.cityArrs = hotarrs;
        [_hotArr addObject:cityInitial];
    }
    return _hotArr;
}



#pragma mark - lazy method


/**
 *  历史
 */
- (NSMutableArray *)historyArr
{
    if (!_historyArr){
        _historyArr = [NSMutableArray array];
        SHCityIntial *cityInitial =[[SHCityIntial alloc]init];
        cityInitial.initial = @"历史";
        cityInitial.cityArrs = self.historySelectArr;
        
        
        [_historyArr addObject:cityInitial];
    }
    return _historyArr;
}

/**
 *  历史选择
 */
- (NSMutableArray *)historySelectArr
{
    if (!_historySelectArr){
        _historySelectArr = [NSKeyedUnarchiver unarchiveObjectWithFile:historyCityFilepath];
        if (!_historySelectArr){
            _historySelectArr =[NSMutableArray array];
        }
    }
    return _historySelectArr;
}

/**
 *  当前选择
 */
- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
        SHCityIntial *cityInModel = [[SHCityIntial alloc] init];
        cityInModel.initial = @"定位";
        
        SHCityModel *cityModel = [[SHCityModel alloc] init];
        cityModel.name = SH_AppDelegate.personInfo.city ? SH_AppDelegate.personInfo.city : @"北京";
        SHLog(@"%@", SH_AppDelegate.personInfo.city)
        NSMutableArray *selectArrs = [NSMutableArray array];
        [selectArrs addObject:cityModel];
        cityInModel.cityArrs = selectArrs;
        [_selectArr addObject:cityInModel];
    }
    return _selectArr;
}


- (void)setSelectCityModel:(SHCityModel *)cityModel
{
    [self.historyArr removeAllObjects];
    
    SHCityIntial *cityInModel = [[SHCityIntial alloc] init];
    cityInModel.initial = @"历史";
    [self historySelectArr];
    
    NSMutableArray *emptyArr = [NSMutableArray arrayWithArray:_historySelectArr];
    [emptyArr enumerateObjectsUsingBlock:^(SHCityModel  *_Nonnull hiscity, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([hiscity.name isEqualToString:cityModel.name]) {
            [_historySelectArr removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    
    [_historySelectArr insertObject:cityModel atIndex:0];
    
    if (_historySelectArr.count > 6) {
        [_historySelectArr removeLastObject];
    }
    
    [NSKeyedArchiver archiveRootObject:_historySelectArr toFile:historyCityFilepath];
    cityInModel.cityArrs = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:historyCityFilepath]];
    [self.historyArr addObject:cityInModel];
    [self.dataArr replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndex:1] withObjects:self.historyArr];
}


- (NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (SH_HomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SH_HomeHeaderView alloc] init];
        
        SHWeakSelf
        _headerView.categoryClickBlock = ^(HeaderViewClicked clicked, NSInteger num) {
            
            if (clicked == HeaderViewClickedCategory) {
                
                [weakSelf singleTap:num];
            }
        };
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[SH_HomeBannerTableViewCell class] forCellReuseIdentifier:SH_HomeBannerTableViewCellId];
        [_tableView registerClass:[SH_HomeCategoryTableViewCell class] forCellReuseIdentifier:SH_HomeCategoryTableViewCellId];
        
        //注册信息流的cell
        [_tableView registerClass:[InfomationSingleImageCell class] forCellReuseIdentifier:InfomationSingleImageCellId];
        [_tableView registerClass:[InfomationThreeImagesCell class] forCellReuseIdentifier:InfomationThreeImagesCellId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SH_QuestionViewCell class]) bundle:nil] forCellReuseIdentifier:SH_QuestionViewCellId];
        
    }
    return _tableView;
}



- (UIButton *)cityButton {
    if (!_cityButton) {
        _cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityButton.frame = CGRectMake(0, 9, 85, 26);
//        _cityButton.ba_buttonLayoutType = BAKit_ButtonLayoutTypeCenterImageRight;
//        _cityButton.ba_padding = 7;
//        [_cityButton setImage:[UIImage imageNamed:@"cityDrop"] forState:UIControlStateNormal];
        [_cityButton setTitle:@"城市" forState:UIControlStateNormal];
        _cityButton.titleLabel.font = SH_FontSize(13);
        [_cityButton setTitleColor:SH_WhiteColor forState:UIControlStateNormal];
        [_cityButton addTarget:self action:@selector(cityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cityButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _cityButton;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(85, 9, SHScreenW-85-20, 26);
        _searchButton.contentMode = UIControlContentHorizontalAlignmentLeft;
        _searchButton.layer.cornerRadius = 13.f;
//        _searchButton.layer.borderColor = SH_WhiteColor.CGColor;
//        _searchButton.layer.borderWidth = 0.5f;
        _searchButton.backgroundColor = [SH_BlackColor colorWithAlphaComponent:0.2];
//        _searchButton.ba_buttonLayoutType = BAKit_ButtonLayoutTypeLeftImageLeft;
//        _searchButton.ba_viewCornerRadius = 13;
//        _searchButton.ba_padding_inset = 20;
        [_searchButton setImage:[UIImage imageNamed:@"searchImage"] forState:UIControlStateNormal];
        [_searchButton setTitle:@"搜索技能服务或需求" forState:UIControlStateNormal];
        _searchButton.titleLabel.font = SH_FontSize(12);
        [_searchButton setTitleColor:SH_WhiteColor forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [_searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -13, 0, 13)];
        
    }
    return _searchButton;
}






#pragma mark - 测试
- (IBAction)buttonClick:(UIButton *)sender {
    
    
    
    //语音播放
    //    SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
    //    [player setDefaultWithVolume:-1.0 rate:0.4 pitchMultipier:-1.0];
    //    [player play:@"您已支付成功"];
    //    [player play:@"第二条语音文字"];
    
    //    ViewController *VC = [[ViewController alloc] init];
    //    [self.navigationController pushViewController:VC animated:YES];
    SH_TestViewController *VC = [[SH_TestViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}


- (IBAction)testLoginBtnClick:(id)sender {
    
    //    SH_TwoViewController *vc = [[SH_TwoViewController alloc] init];
    //    [self.navigationController presentViewController:vc animated:YES completion:nil];
    SHLoginViewController *vc = [[SHLoginViewController alloc] init];
    //    SHHadLoginViewController *vc = [[SHHadLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}











@end
