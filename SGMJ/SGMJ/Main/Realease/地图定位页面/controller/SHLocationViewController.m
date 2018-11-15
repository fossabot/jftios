//
//  SHLocationViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHLocationViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h> //引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h> //引入所搜功能所有的头文件

#import "SHBaiduAddressModel.h"
#import "SHAddressSelectedCell.h"
#import "SHSearchVController.h"


static NSString *identityId = @"SHAddressSelectedCell";
@interface SHLocationViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, UITableViewDelegate, UITableViewDataSource> {
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKReverseGeoCodeSearchOption *_reverseGeoCodeOption;//范地理编码检索

    CLLocationCoordinate2D _pt;
    NSString *_cityName;
    BOOL _isAutoMove;
    
}

@property (weak, nonatomic) IBOutlet UIView *mapBGView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray<BMKPoiInfo *> *dataList;//信息
@property (nonatomic, assign) NSIndexPath *selectIndex;//单选，当前选中的行

@property (weak, nonatomic) IBOutlet UIImageView *centerImgV;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end


@implementation SHLocationViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (AppDelegate.isLocationServiceOpen) {

    } else {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
//        if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                [[UIApplication sharedApplication] openURL:url];
//            }
//        } else {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
//        }
    }
    
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
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    // 禁用iOS7返回手势
    
    self.navigationItem.hidesBackButton = YES;
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _locService.delegate = nil;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self initMap];
    [self initLocationService];
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    _reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    
    UISwipeGestureRecognizer *recognizer;
    // 添加右滑手势
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipe
{
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"定位";
    [_tableView registerNib:[UINib nibWithNibName:identityId bundle:nil] forCellReuseIdentifier:identityId];
    _tableView.tableFooterView = [[UIView alloc] init];
    _searchBtn.layer.cornerRadius = _searchBtn.height / 2;
    _searchBtn.clipsToBounds = YES;
    [_searchBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    _searchBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
    
}



/**
 *  百度地图的初始化，不使用的时候delegate置位nil，否则影响内存的释放
 */
- (void)initMap
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, _mapBGView.width, _mapBGView.height)];
    //设置地图的方式，标准地图
    [_mapView setMapType:BMKMapTypeStandard];
    //设置地图比例尺等级
    _mapView.zoomLevel = 16;
    //设定是否显示定位图层
    _mapView.showsUserLocation = YES;
    //BMKMapViewDelegate
    _mapView.delegate = self;
    _mapView.gesturesEnabled = YES;
    [_mapBGView addSubview:_mapView];
    [_mapBGView bringSubviewToFront:_centerImgV];
    
}

/**
 *  定位:第一次使用的时候会自动弹框询问是否允许使用位置
 */
- (void)initLocationService
{
    _locService = [[BMKLocationService alloc] init];
    //设置定位的精确度
    [_locService setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    _locService.delegate = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}

#pragma mark - BMKGeoCodeSearchDelegate
//接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    SHWeakSelf
    [MBProgressHUD hideHUDForView:self.view];
    if (error == BMK_SEARCH_NO_ERROR) {
        //此处处理正常搜索结果
        if (_isAutoMove == NO) {
            _dataList = result.poiList;
            _cityName = result.addressDetail.city;
            [_tableView reloadData];
        } else {
            _isAutoMove = NO;
        }
    } else {
        [MBProgressHUD showMBPAlertView:@"抱歉，未找到结果！" withSecond:2.0];
    }
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{

    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate = [_mapView convertPoint:_mapView.center toCoordinateFromView:_mapView];
    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.location = CLLocationCoordinate2DMake(MapCoordinate.latitude, MapCoordinate.longitude);
    /**
     *根据地理坐标获取地址信息
     *异步函数，返回结果在BMKGeoCodeSearchDelegate的onGetAddrResult通知
     *@param reverseGeoCodeOption 反geo检索信息类
     *@return 成功返回YES，否则返回NO
     */

    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    BOOL flag =[_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    if (flag) {
        SHLog(@"反geo检索发送成功")
    } else {
        SHLog(@"反geo检索发送失败")
        //[MBProgressHUD hideHUDForView:self.view];
    }
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //_mapView.centerCoordinate = userLocation.location.coordinate;
    
    
    
    _reverseGeoCodeOption.location = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    /**
     *根据地理坐标获取地址信息
     *异步函数，返回结果在BMKGeoCodeSearchDelegate的onGetAddrResult通知
     *@param reverseGeoCodeOption 反geo检索信息类
     *@return 成功返回YES，否则返回NO
     */
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    BOOL flag =[_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    if (flag) {
        SHLog(@"反geo检索发送成功")
        SHLog(@"%f-%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)
    } else {
        SHLog(@"定位定位反geo检索发送失败")
        [MBProgressHUD hideHUDForView:self.view];
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    SHLog(@"location error: %@", error)
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHAddressSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:identityId];
    if (!cell) {
        cell = [[SHAddressSelectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityId];
    }
    
    cell.firstLabel.text = _dataList[indexPath.row].name;
    cell.detailL.text = _dataList[indexPath.row].address;
    cell.detailL.textColor = SHColorFromHex(0x9a9a9a);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isAutoMove = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_mapView setCenterCoordinate:_dataList[indexPath.row].pt animated:YES];
    SHLog(@"%@", _cityName)
    !_addressBlock ?: _addressBlock(_dataList[indexPath.row].address, _dataList[indexPath.row].name,_dataList[indexPath.row].pt, _cityName);
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (NSArray *)dataList {
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}



/**
 *  搜索
 */
- (IBAction)searchBtnClick:(UIButton *)sender {

    SHSearchVController *vc = [[SHSearchVController alloc] init];
    vc.cityName = _cityName;
    vc.chooseAddress = ^(CLLocationCoordinate2D pt) {
        _pt = pt;
        _reverseGeoCodeOption.location = CLLocationCoordinate2DMake(_pt.latitude, _pt.longitude);
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(_pt.latitude, _pt.longitude);
        /**
         *根据地理坐标获取地址信息
         *异步函数，返回结果在BMKGeoCodeSearchDelegate的onGetAddrResult通知
         *@param reverseGeoCodeOption 反geo检索信息类
         *@return 成功返回YES，否则返回NO
         */
        [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
        BOOL flag =[_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
        if (flag) {
            SHLog(@"反geo检索发送成功")
        } else {
            SHLog(@"定位定位反geo检索发送失败")
            [MBProgressHUD hideHUDForView:self.view];
        }
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];

}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





@end
