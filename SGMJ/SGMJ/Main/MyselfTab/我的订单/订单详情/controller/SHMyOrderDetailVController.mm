//
//  SHMyOrderDetailVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/1.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMyOrderDetailVController.h"
#import "SHOrderListModel.h"
#import "SHMyOrderDetailModel.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "SHApplySkillVController.h"
#import "SHEvaluteOrderViewController.h"

#import "SHOrderModel.h"
#import "SHPayOrderVController.h"
#import <MapKit/MapKit.h>


@interface RouteAnnotation:BMKPointAnnotation
{
//    int _type;      //0.起点 1.终点 2.公交 3.地铁 4.驾乘 5.途经点
//    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;

@end

@interface SHMyOrderDetailVController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKRouteSearchDelegate> {
    CLLocationCoordinate2D _endpt;
    CLLocationCoordinate2D _serverpt;
}

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;



@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;

@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secViewContraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdViewContraint;

@property (weak, nonatomic) IBOutlet UIImageView *goodImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;

@property (weak, nonatomic) IBOutlet UILabel *orderNoL;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeL;
@property (weak, nonatomic) IBOutlet UILabel *goodNameL;
@property (weak, nonatomic) IBOutlet UILabel *myNameL;
@property (weak, nonatomic) IBOutlet UILabel *myphoneL;
@property (weak, nonatomic) IBOutlet UILabel *myAddressL;

@property (weak, nonatomic) IBOutlet UILabel *goodNaL;
@property (weak, nonatomic) IBOutlet UILabel *godNameL;
@property (weak, nonatomic) IBOutlet UILabel *godAddressL;



//百度地图对象
@property (nonatomic, strong) BMKMapView *mapView;
//locService对象
@property (nonatomic, strong) BMKLocationService *locService;
//路线搜索对象
@property (nonatomic, strong) BMKRouteSearch *routeSearch;
//用户位置
@property (nonatomic, strong) BMKUserLocation *userLocation;


@property (nonatomic, strong) SHMyOrderDetailModel *detailModel;


@property (nonatomic, strong) NSTimer *timer;
//@property (weak, nonatomic) IBOutlet UILabel *arriveTimeL;

@property (nonatomic, assign) NSUInteger num;


@property (weak, nonatomic) IBOutlet UILabel *timeAndDistL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;



@property (nonatomic, assign) CLLocationDistance distance;


@property (nonatomic, strong) NSMutableDictionary *mapDic;      //
@property (nonatomic, strong) NSMutableArray *allMapAppArray;   //所有手机中存在的地图软件



@end

@implementation SHMyOrderDetailVController

- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    
    
    if ([_listModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        [_mapView viewWillAppear];
        _mapView.delegate = self;
        _locService.delegate = self;
        _routeSearch.delegate = self;
    } else {
        [super viewWillAppear:animated];
    }
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
    //[super viewWillDisappear:animated];
    
    if ([_listModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        [_mapView viewWillDisappear];
        _mapView.delegate = nil;
        _locService.delegate = nil;
        _routeSearch.delegate = nil;
    } else {
        [super viewWillDisappear:animated];
    }
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    self.navigationController.navigationBar.barTintColor = SHColorFromHex(0x00a9f0);
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
    if (![_listModel.orderStatus isEqualToString:_detailModel.orderStatus]) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"listRefresh" object:nil];

    }
    
}

- (void)dealloc
{
    if (self.timer) {
        SHLog(@"销毁计时器")
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    [self loadOrderDetailData];
    
    [self loadMapView];
    [self getUserLocation];
    [self searchRoute];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"订单详情";
    
    _allMapAppArray = [NSMutableArray array];
    
    self.view.backgroundColor = SHColorFromHex(0xf2f2f2);
    
    _num = 0;
    
    _headView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
    _timeAndDistL.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
    _timeL.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
    _leftButton.backgroundColor = [UIColor whiteColor];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.backgroundColor = navColor;
    _serviceButton.backgroundColor = navColor;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(loadOrderDetailData) userInfo:nil repeats:YES];
    
    
    //定制右按钮
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc] initWithTitle:@"投诉" style:UIBarButtonItemStyleDone target:self action:@selector(feedBackAboutOrder)];
    [barBut setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:13.0],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = barBut;
    
    
}

//投诉
- (void)feedBackAboutOrder
{
    SHWeakSelf
    SHApplySkillVController *vc = [[SHApplySkillVController alloc] init];
    vc.type = SHFeedBackType;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//处理手机中存在的地图
- (void)dealWithMapApp
{
    SHLog(@"%f", _endpt.latitude)
    SHLog(@"%f", _endpt.longitude)
    SHLog(@"%lf", _endpt.latitude)
    SHLog(@"%lf", _endpt.longitude)
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [_allMapAppArray addObject:iosMapDic];
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%lf,%lf|name=北京&mode=driving&coord_type=gcj02",_endpt.latitude,_endpt.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [_allMapAppArray addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dlat=%lf&dlon=%lf&dev=0&style=2",@"--",_endpt.latitude,_endpt.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = url;
        [_allMapAppArray addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%lf,%lf&directionsmode=driving",@"导航测试",@"nav123456",_endpt.latitude, _endpt.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        googleMapDic[@"url"] = urlString;
        [_allMapAppArray addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%lf,%lf&to=终点&coord_type=1&policy=0",_endpt.latitude, _endpt.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [_allMapAppArray addObject:qqMapDic];
    }
    
    
}

//苹果地图
- (void)navAppleMapnavAppleMap
{
    SHLog(@"%lf", _endpt.latitude)
    SHLog(@"%lf", _endpt.longitude)
    float lat = _endpt.latitude;
    float lon = _endpt.longitude;
    //终点坐标
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
    
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
    
    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    //第二个，都可以用
    //    NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    //                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
}

//处理地图--开始导航
- (void)seleteAnyMapAppYouWant
{
    SHLog(@"%@", _allMapAppArray)
    //选择
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = _allMapAppArray.count;
    
    for (int i = 0; i < index; i++) {
        
        NSString * title = _allMapAppArray[i][@"title"];
        //苹果原生地图方法
        if (i == 0) {
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMapnavAppleMap];
            }];
            [alert addAction:action];
            continue;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = _allMapAppArray[i][@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - 加载地图
- (void)loadMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    
    [self.mapBgView addSubview:_mapView];
    self.mapBgView.hidden = YES;
}


#pragma mark - 定位功能
- (void)getUserLocation
{
    self.mapView.showsUserLocation = NO;//篮圈
    //设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    //允许旋转地图
    self.mapView.rotateEnabled = YES;
    //设置地图缩略图等级
    [self.mapView setZoomLevel:16.1];
    //设置比例尺和比例位置
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(0, self.mapView.height - 40);
    //定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = YES;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    [self.mapView updateLocationViewWithParam:displayParam];
    
    _locService = [[BMKLocationService alloc] init];
    _locService.distanceFilter = 5.0;//设置定位的最小距离
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
}

#pragma mark - 搜索路线
- (void)searchRoute
{
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
}

//订单详情
- (void)loadOrderDetailData
{
    SHWeakSelf
    NSDictionary *dic = nil;
    if (self.inType == SHOrderListPushType) {
        dic = @{
                @"orderNo":_listModel.orderNo
                };
    } else if (self.inType == SHNotificationType) {
        dic = @{
                @"orderNo":_orderNo
                };
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHOrderDetailUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            _detailModel = [SHMyOrderDetailModel mj_objectWithKeyValues:JSON[@"details"]];
            [weakSelf dealWithDetailModelAndShowUI:_detailModel];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
    
}

//联系对方
- (IBAction)contactServicerButtonClick:(UIButton *)sender {
    [self callPhoneStr:_detailModel.userData[@"mobile"]];
}

//取消订单按钮
- (IBAction)leftButtonClick:(UIButton *)sender {
    
    if ([_detailModel.orderStatus isEqualToString:@"INIT"]) {
        //取消订单
        [self cancelOrderRequest];
    } else if ([_detailModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        if (_detailModel.isCustomer == 1) {
            //导航按钮
            SHLog(@"服务者开始导航")
            [self seleteAnyMapAppYouWant];
        }
        
    }
    
}

//立即付款按钮
- (IBAction)rightButtonClick:(UIButton *)sender {
    
    if ([_detailModel.orderStatus isEqualToString:@"INIT"]) {
        //立即付款
        SHPayOrderVController *vc = [[SHPayOrderVController alloc] init];
        vc.orderNo = _detailModel.orderNo;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([_detailModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        if (_detailModel.isCustomer == 1) {
            //确认订单
            SHLog(@"服务者确认订单")
            [self makeSureService];
            
        }
        
    }
    
}


- (IBAction)serviceButtonClick:(UIButton *)sender {
    //按钮：立即支付和取消订单  两个按钮        INIT
    //按钮：用户-催单提醒  服务者-立即出发 一个按钮 RECEIVE
    //用户-确认服务   一个按钮                UN_CONFIRMED    服务中
    //立即评价
    //已完结
    
    if ([_detailModel.orderStatus isEqualToString:@"RECEIVE"]) {
        if (_detailModel.isCustomer == 0) {         //需求者
            //我要催单
            [self loadCuiDanRequest];
        } else if (_detailModel.isCustomer == 1) {  //服务者
            //立即出发
            [self loadGoToServiceRightNow];
        }
    } else if ([_detailModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        
        if (_detailModel.isCustomer == 0) {
            [self makeSureService];
        }
        
    } else if ([_detailModel.orderStatus isEqualToString:@"UN_EVALUATION"]) {
        [self evaluteOrderRightNow];
    } else if ([_detailModel.orderStatus isEqualToString:@"INIT"]) {
        SHLog(@"取消订单。。。")
    }
    
}

//取消订单
- (void)cancelOrderRequest
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_detailModel.orderNo
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHCancelOrderUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"取消成功" withSecond:2.0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadOrderList" object:nil];
        } else {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
}


#pragma mark - 接口请求
//我要催单
- (void)loadCuiDanRequest
{
    SHLog(@"我要催单")
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_detailModel.orderNo
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHCuiDanOrderUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"催单成功" withSecond:2.0];
        } else if (code == 500) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
}

//立即出发
- (void)loadGoToServiceRightNow
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_detailModel.orderNo
                          };
    SHLog(@"%@", _detailModel.orderNo)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHGoToSerRightNowUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            [weakSelf showMapViewAndHideOtherView];
            [weakSelf loadOrderDetailData];
            if (_inType == SHNotificationType) {
                
            } else {
                if (weakSelf.changeBlock) {
                    weakSelf.changeBlock(@"回调");
                }
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadOrderList" object:nil];
            }
            [weakSelf loadOrderDetailData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

//确认服务
- (void)makeSureService
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_detailModel.orderNo
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHSureServiceUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [weakSelf makeSureServiceAndHideMapView];
        } else if (code == 100) {
            //服务者跳转到上传凭证页面
            SHApplySkillVController *vc = [[SHApplySkillVController alloc] init];
            vc.type = SHOrderDoneType;
            vc.orderNo = _detailModel.orderNo;
            vc.intype = _inType;
            vc.orderDoneBlock = ^(NSString *orderNo) {
                [weakSelf loadOrderDetailData];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//立即评价
- (void)evaluteOrderRightNow
{
    SHEvaluteOrderViewController *vc = [[SHEvaluteOrderViewController alloc] init];
    vc.orderNo = _detailModel.orderNo;
    vc.evaluateType = SHEvaluateOrderNoType;
    [self.navigationController pushViewController:vc animated:YES];
}



//用户显示订单详情，mapview消失
- (void)makeSureServiceAndHideMapView
{
    _topContraint.constant = 0;
    _leftContraint.constant = 0;
    _rightContraint.constant = 0;
    _headView.backgroundColor = [UIColor whiteColor];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _routeSearch.delegate = nil;
    //待评价
    _mapBgView.hidden = YES;
    //[_mapBgView removeFromSuperview];
    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
    if (_detailModel.isCustomer == 0) {
        _detailModel.orderStatus = @"UN_EVALUATION";
        [_serviceButton setTitle:@"待评价" forState:UIControlStateNormal];
    } else if (_detailModel.isCustomer == 1) {
        _serviceButton.hidden = YES;
    }
    
    SHLog(@"订单状态%@", _detailModel.orderStatus)
    
    _statusL.text = @"订单已结束";
    _firstView.hidden = NO;
    _secView.hidden = NO;
    _thirdView.hidden = NO;
    _timeL.hidden = YES;
    _timeAndDistL.hidden = YES;
    
}

//是否显示地图
- (void)showMapViewAndHideOtherView
{
    _mapView.delegate = self;
    _locService.delegate = self;
    _routeSearch.delegate = self;
    _mapBgView.hidden = NO;
    //_headView.layer.cornerRadius = _headView.height / 2;
    //_headView.clipsToBounds = YES;
    
    //显示地图
    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
    _firstView.hidden = YES;
    _secView.hidden = YES;
    _thirdView.hidden = YES;
    [_serviceButton setTitle:@"确认服务" forState:UIControlStateNormal];
    
    _statusL.text = @"订单进行中";
    
}


#pragma mark - UI显示地图
- (void)dealWithDetailModelAndShowUI:(SHMyOrderDetailModel *)detailModel
{
    _num += 1;
    SHLog(@"%d", _detailModel.isCustomer)
    SHLog(@"---------------------------------------")
    //如果是消费者，看到的头像是服务者的，反之亦然
    
    [_headImgV sd_setImageWithURL:_detailModel.userData[@"avatar"] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameLabel.text = _detailModel.userData[@"nickName"];
    
    _endpt.latitude = [_detailModel.arrive[@"lat"] doubleValue];
    _endpt.longitude = [_detailModel.arrive[@"lng"] doubleValue];
    
    _serverpt.latitude = [_detailModel.depart[@"lat"] doubleValue];
    _serverpt.longitude = [_detailModel.depart[@"lng"] doubleValue];
    
    SHLog(@"%f", _endpt.latitude)
    SHLog(@"%f", _endpt.longitude)
    
    [_allMapAppArray removeAllObjects];
    [self dealWithMapApp];
    
    /**orderStatus
     INIT待支付 RECEIVE 代发货 UN_CONFIRMED,//待收货（订单需要确认） UN_EVALUATION未评价
     *                       消费者             服务者
     *INIT               2   取消订单+立即付款
     *RECEIVE            1   我要催单            立即出发
     *UN_CONFIRMED       3   确认服务                       显示地图
     *UN_EVALUATION      1   待评价
     *SUCCESS            1   已完结
     */
    if ([_detailModel.orderStatus isEqualToString:@"INIT"]) {
        [self.timer invalidate];
        self.timer = nil;
        
        _mapView.delegate = nil;
        _locService.delegate = nil;
        _routeSearch.delegate = nil;
        
        _mapBgView.hidden = YES;
        
        
        if (_detailModel.isCustomer == 0) {
            _serviceButton.hidden = YES;
            [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightButton setTitle:@"立即付款" forState:UIControlStateNormal];
            
        } else if (_detailModel.isCustomer == 1) {
            _serviceButton.hidden = YES;
            [_serviceButton setTitle:@"取消订单" forState:UIControlStateNormal];
            _leftButton.hidden = YES;
            _rightButton.hidden = YES;
//            [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
//            [_rightButton setTitle:@"立即付款" forState:UIControlStateNormal];
            
        }
        
        _topContraint.constant = 0;
        _leftContraint.constant = 0;
        _rightContraint.constant = 0;
        _headView.backgroundColor = [UIColor whiteColor];
        [_leftButton setBackgroundColor:[UIColor whiteColor]];
        [_rightButton setBackgroundColor:navColor];
        
        _statusL.text = @"订单未付款";
        
    } else if ([_detailModel.orderStatus isEqualToString:@"RECEIVE"]) {
        
        _mapBgView.hidden = YES;
        _topContraint.constant = 0;
        _leftContraint.constant = 0;
        _rightContraint.constant = 0;
        _headView.backgroundColor = [UIColor whiteColor];
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
        if (_detailModel.isCustomer == 0) {
            [_serviceButton setTitle:@"我要催单" forState:UIControlStateNormal];
            
        } else if (_detailModel.isCustomer == 1) {
            [_serviceButton setTitle:@"立即出发" forState:UIControlStateNormal];
            
        }
        _statusL.text = @"订单未执行";
    } else if ([_detailModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        _mapView.delegate = self;
        _locService.delegate = self;
        _routeSearch.delegate = self;
        _mapBgView.hidden = NO;
        _headView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        _serverpt.latitude = [_detailModel.depart[@"lat"] doubleValue];
        _serverpt.longitude = [_detailModel.depart[@"lng"] doubleValue];
        
        _timeAndDistL.hidden = NO;
        _timeL.hidden = NO;
        
        //显示地图
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
        _firstView.hidden = YES;
        _secView.hidden = YES;
        _thirdView.hidden = YES;
        [_serviceButton setTitle:@"确认服务" forState:UIControlStateNormal];
        
        _statusL.text = @"订单进行中";
        
        if (_detailModel.isCustomer == 0) {             //用户只有一个按钮确认服务
            _leftButton.hidden = YES;
            _rightButton.hidden = YES;
            _serviceButton.hidden = NO;
        } else if (_detailModel.isCustomer == 1) {      //消费者两个按钮：导航+确认服务
            _leftButton.hidden = NO;
            _rightButton.hidden = NO;
            _serviceButton.hidden = YES;
            [_leftButton setTitle:@"开始导航" forState:UIControlStateNormal];
            [_rightButton setTitle:@"确认服务" forState:UIControlStateNormal];
        }
        
    } else if ([_detailModel.orderStatus isEqualToString:@"UN_EVALUATION"]) {
        [self.timer invalidate];
        self.timer = nil;
        
        _timeAndDistL.hidden = YES;
        _timeL.hidden = YES;
        
        //_topContraint.constant = 10;
        _leftContraint.constant = 0;
        _rightContraint.constant = 0;
        _headView.backgroundColor = [UIColor whiteColor];
        //_headView.clipsToBounds = NO;
        _mapView.delegate = nil;
        _locService.delegate = nil;
        _routeSearch.delegate = nil;
        //待评价
        _mapBgView.hidden = YES;
        //[_mapBgView removeFromSuperview];
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
        _firstView.hidden = NO;
        _secView.hidden = NO;
        _thirdView.hidden = NO;
        
        if (_detailModel.isCustomer == 0) {
            [_serviceButton setTitle:@"待评价" forState:UIControlStateNormal];
            
        } else if (_detailModel.isCustomer == 1) {
            _serviceButton.hidden = YES;
        }
        
        _statusL.text = @"订单已结束";
        
    } else if ([_detailModel.orderStatus isEqualToString:@"SUCCESS"]) {
        [self.timer invalidate];
        self.timer = nil;
        _mapView.delegate = nil;
        _locService.delegate = nil;
        _routeSearch.delegate = nil;
        
        _timeAndDistL.hidden = YES;
        _timeL.hidden = YES;
        
        //待评价
        _mapBgView.hidden = YES;
        //_topContraint.constant = 10;
        _leftContraint.constant = 0;
        _rightContraint.constant = 0;
        _headView.backgroundColor = [UIColor whiteColor];
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
        _firstView.hidden = NO;
        _secView.hidden = NO;
        _thirdView.hidden = NO;
        
        _serviceButton.hidden = YES;
        _statusL.text = @"订单已完结";
    }
    
    [_goodImgV sd_setImageWithURL:_detailModel.goodsData[@"imgUrl"] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    _titleL.text = _detailModel.productName;
    _goodNaL.text = _detailModel.productName;
    _numL.text = [NSString stringWithFormat:@"数量:%d", [_detailModel.goodsData[@"amount"] integerValue]];
    _priceL.text = [NSString stringWithFormat:@"%@元",_detailModel.goodsData[@"price"]];
    _orderNoL.text = _detailModel.orderNo;
    _orderTimeL.text = _detailModel.orderCreateTime;
    _goodNameL.text = _detailModel.productName;
    _myNameL.text = _detailModel.depart[@"name"];
    _myphoneL.text = _detailModel.depart[@"phone"];
    _myAddressL.text = _detailModel.depart[@"address"];
    
    CGFloat labelWidth = _myAddressL.width;
    NSDictionary *attrs = @{NSFontAttributeName : _myAddressL.font};
    CGSize size = [_myAddressL.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    _myAddressL.size = size;
    
    _godNameL.text = _detailModel.arrive[@"phone"];
    _godAddressL.text = _detailModel.arrive[@"address"];
    CGFloat godAdWidth = _godAddressL.width;
    NSDictionary *addAttrs = @{NSFontAttributeName:_godAddressL.font};
    CGSize godSize = [_godAddressL.text boundingRectWithSize:CGSizeMake(godAdWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:addAttrs context:nil].size;
    _godAddressL.size = godSize;
    
    
    if (_num == 1) {
        _secViewContraint.constant = _secView.height - 20 + _myAddressL.size.height;
        _thirdViewContraint.constant = _thirdView.height - 20 + _godAddressL.size.height;
    }
    
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    //1服务者看到的轨迹是  自己到目的地的路线
    //0用户看到的轨迹是    服务者到目的地的
    if (_detailModel.isCustomer == 0) {//消费者--服务者到目的地的
        //轨迹绘画
        //BMKPlanNode *start = [[BMKPlanNode alloc] init];
        start.pt = CLLocationCoordinate2DMake(_serverpt.latitude, _serverpt.longitude);
        SHLog(@"---起点---")
        SHLog(@"%f", start.pt.latitude)
        SHLog(@"%f", start.pt.longitude)
        
        /**
         *  31.8470281338,117.2063652762 科大讯飞
         */
        
        start.cityName = SH_AppDelegate.personInfo.city;
        //BMKPlanNode *end = [[BMKPlanNode alloc] init];
        end.pt = CLLocationCoordinate2DMake(_endpt.latitude, _endpt.longitude);
        SHLog(@"---终点---")
        SHLog(@"%f", _endpt.latitude)
        SHLog(@"%f", _endpt.longitude)
        SHLog(@"---------")
        end.cityName = SH_AppDelegate.personInfo.city;
    } else {                            //服务者--自己到目的地的路线
        //轨迹绘画
        //BMKPlanNode *start = [[BMKPlanNode alloc] init];
        start.pt = _userLocation.location.coordinate;
        SHLog(@"------定位的位置------")
        SHLog(@"%f", _userLocation.location.coordinate.latitude)
        SHLog(@"%f", _userLocation.location.coordinate.longitude)
        SHLog(@"---起点 服务者的位置---")
        SHLog(@"%f", _serverpt.latitude)
        SHLog(@"%f", _serverpt.longitude)
        
        /**
         *  31.8470281338,117.2063652762 科大讯飞
         */
        
        start.cityName = SH_AppDelegate.personInfo.city;
        //BMKPlanNode *end = [[BMKPlanNode alloc] init];
        end.pt = CLLocationCoordinate2DMake(_endpt.latitude, _endpt.longitude);
        SHLog(@"---终点 目的地的位置---")
        SHLog(@"%f", _endpt.latitude)
        SHLog(@"%f", _endpt.longitude)
        SHLog(@"---------")
        end.cityName = SH_AppDelegate.personInfo.city;
        
        
    }
    
    //驾乘
    BMKDrivingRoutePlanOption *driveOption = [[BMKDrivingRoutePlanOption alloc] init];
    driveOption.from = start;
    driveOption.to = end;
    //不获取路况信息
    driveOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;
    BOOL flag = [_routeSearch drivingSearch:driveOption];
    if (flag) {
        SHLog(@"骑乘检索返送成功")
    } else {
        SHLog(@"骑乘检所发送失败")
    }
    
    
    //公交BMKTransitRoutePlanOption BMKRidingRoutePlanOption
    /**
     *  transitSearch BMKTransitRoutePlanOption transitRouteSearchOption.city= SH_AppDelegate.personInfo.city;
     *  ridingSearch    BMKRidingRoutePlanOption
     */
//    BMKRidingRoutePlanOption *transitRouteSearchOption = [[BMKRidingRoutePlanOption alloc]init];
//    //显示路线需要添加城市
//    //transitRouteSearchOption.city= SH_AppDelegate.personInfo.city;
//    transitRouteSearchOption.from = start;
//    transitRouteSearchOption.to = end;
//    BOOL flag = [_routeSearch ridingSearch:transitRouteSearchOption];
//    if(flag){
//        SHLog(@"骑行检索发送成功");
//    }
//    else{
//        SHLog(@"骑行检索发送失败");
//    }
    
    /**
     *计算指定两点之间的距离
     *@param a 第一个坐标点
     *@param b 第二个坐标点
     *@return 两点之间的距离，单位：米
     */
    BMKMapPoint pointStart = BMKMapPointForCoordinate(start.pt);
    BMKMapPoint pointEnd = BMKMapPointForCoordinate(end.pt);
    _distance = BMKMetersBetweenMapPoints(pointStart, pointEnd);
    SHLog(@"%f", _distance)
    //[MBProgressHUD showMBPAlertView:[NSString stringWithFormat:@"%.3f公里---距离目的地", _distance / 1000] withSecond:2.0];
    
    /**
     *判断点是否在圆内
     *@param point 待判断的平面坐标点
     *@param center 目标圆形的中心点平面坐标
     *@param radius 目标圆形的半径，单位m
     *@return 如果在内，返回YES，否则返回NO
     */
    //UIKIT_EXTERN BOOL BMKCircleContainsPoint(BMKMapPoint point, BMKMapPoint center, double radius);
    
    if (BMKCircleContainsPoint(pointStart, pointEnd, 20)) {
        //[MBProgressHUD showMBPAlertView:@"到达目的地" withSecond:2.0];
        //[_locService stopUserLocationService];
    }
    
    
}




#pragma mark - BMKMapViewDelegate
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //SHLog(@"didUpdateUserHeading")
//    if (_userLocation == userLocation) {
//        
//    } else {
//        _userLocation = userLocation;
//    }
//    SHLog(@"系统定位")
//    SHLog(@"%f", userLocation.location.coordinate.latitude)
//    SHLog(@"%f", userLocation.location.coordinate.longitude)
//    [_mapView updateLocationData:userLocation];
//    //设置定位到的位置为屏幕的中心
//    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    SHLog(@"----系统定位----")
    SHLog(@"%f", userLocation.location.coordinate.latitude)
    SHLog(@"%f", userLocation.location.coordinate.longitude)
    [_mapView updateLocationData:userLocation];
    
    //设置定位到的位置为屏幕的中心
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //[_locService stopUserLocationService] 方法，让定位停止，要不然一直定位，你的地图就一直锁定在一个位置
    [_locService stopUserLocationService];
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    //1服务者看到的轨迹是  自己到目的地的路线
    //0用户看到的轨迹是    服务者到目的地的
    if (_detailModel.isCustomer == 0) {//消费者--服务者到目的地的
        //轨迹绘画
        //BMKPlanNode *start = [[BMKPlanNode alloc] init];
        start.pt = CLLocationCoordinate2DMake(_serverpt.latitude, _serverpt.longitude);
        SHLog(@"---起点---")
        SHLog(@"%f", start.pt.latitude)
        SHLog(@"%f", start.pt.longitude)
        
        /**
         *  31.8470281338,117.2063652762 科大讯飞
         */
        
        start.cityName = SH_AppDelegate.personInfo.city;
        //BMKPlanNode *end = [[BMKPlanNode alloc] init];
        end.pt = CLLocationCoordinate2DMake(_endpt.latitude, _endpt.longitude);
        SHLog(@"---终点---")
        SHLog(@"%f", _endpt.latitude)
        SHLog(@"%f", _endpt.longitude)
        SHLog(@"---------")
        end.cityName = SH_AppDelegate.personInfo.city;
    } else {                            //服务者--自己到目的地的路线
        //轨迹绘画
        //BMKPlanNode *start = [[BMKPlanNode alloc] init];
        start.pt = _userLocation.location.coordinate;
        SHLog(@"---起点 服务者的位置---")
        SHLog(@"%f", start.pt.latitude)
        SHLog(@"%f", start.pt.longitude)
        
        /**
         *  31.8470281338,117.2063652762 科大讯飞
         */
        
        start.cityName = SH_AppDelegate.personInfo.city;
        //BMKPlanNode *end = [[BMKPlanNode alloc] init];
        end.pt = CLLocationCoordinate2DMake(_endpt.latitude, _endpt.longitude);
        SHLog(@"---终点 目的地的位置---")
        SHLog(@"%f", _endpt.latitude)
        SHLog(@"%f", _endpt.longitude)
        SHLog(@"---------")
        end.cityName = SH_AppDelegate.personInfo.city;
        
        
    }
    
    //驾乘
    BMKDrivingRoutePlanOption *driveOption = [[BMKDrivingRoutePlanOption alloc] init];
    driveOption.from = start;
    driveOption.to = end;
    //不获取路况信息
    driveOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;
    BOOL flag = [_routeSearch drivingSearch:driveOption];
    if (flag) {
        SHLog(@"骑乘检索返送成功")
    } else {
        SHLog(@"骑乘检所发送失败")
    }
    
    
    //公交BMKTransitRoutePlanOption BMKRidingRoutePlanOption
    /**
     *  transitSearch BMKTransitRoutePlanOption transitRouteSearchOption.city= SH_AppDelegate.personInfo.city;
     *  ridingSearch    BMKRidingRoutePlanOption
     */
//    BMKRidingRoutePlanOption *transitRouteSearchOption = [[BMKRidingRoutePlanOption alloc]init];
//    //显示路线需要添加城市
//    //transitRouteSearchOption.city= SH_AppDelegate.personInfo.city;
//    transitRouteSearchOption.from = start;
//    transitRouteSearchOption.to = end;
//    BOOL flag = [_routeSearch ridingSearch:transitRouteSearchOption];
//    if(flag){
//        SHLog(@"骑行检索发送成功");
//    }
//    else{
//        SHLog(@"骑行检索发送失败");
//    }
    
    
    
    /**
     *计算指定两点之间的距离
     *@param a 第一个坐标点
     *@param b 第二个坐标点
     *@return 两点之间的距离，单位：米
     */
    BMKMapPoint pointStart = BMKMapPointForCoordinate(start.pt);
    BMKMapPoint pointEnd = BMKMapPointForCoordinate(end.pt);
    _distance = BMKMetersBetweenMapPoints(pointStart, pointEnd);
    SHLog(@"%f", _distance)
    //[MBProgressHUD showMBPAlertView:[NSString stringWithFormat:@"%.3f公里---距离目的地", _distance / 1000] withSecond:2.0];
    
    /**
     *判断点是否在圆内
     *@param point 待判断的平面坐标点
     *@param center 目标圆形的中心点平面坐标
     *@param radius 目标圆形的半径，单位m
     *@return 如果在内，返回YES，否则返回NO
     */
    //UIKIT_EXTERN BOOL BMKCircleContainsPoint(BMKMapPoint point, BMKMapPoint center, double radius);
    
    if (BMKCircleContainsPoint(pointStart, pointEnd, 20)) {
        //[MBProgressHUD showMBPAlertView:@"到达目的地" withSecond:2.0];
        //[_locService stopUserLocationService];
    }
    
}


- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    //这里是点击大头针上面气泡触发方法，可以写点击触发事件，如果需要区分是哪个大头针被点击，加tag值
    SHLog(@"%ld", view.tag)
}

#pragma mark - annotation添加标注 地图上各个节点的大头针标注自定义
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation *)annotation];
    }
    SHLog(@"添加自定义大头针")
    //这里判断不同的点给不同的图
    
    return nil;
    
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    SHLog(@"getRouteAnnotationView")
    //0.起点 1.终点 2.公交 3.地铁 4.驾乘 5.途经点
    BMKPinAnnotationView *view = nil;
    switch (routeAnnotation.type) {
        case 0://起点
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"icon_nav_start"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
                view.tag = 10;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1://终点
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"icon_nav_end"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height) * 0.5);
                view.canShowCallout = TRUE;
                view.tag = 20;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2://公交
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"icon_nav_bus"];
                view.canShowCallout = YES;
                
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3://地铁
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"icon_nav_rail"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
            
        }
            break;
        case 4://驾乘
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage *image = [UIImage imageNamed:@"icon_direction"];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5://途经点
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage *image = [UIImage imageNamed:@"icon_nav_waypoint"];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
            
        default:
            break;
    }
    
    return view;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    SHLog(@"mapViewFitPolyLine----根据polyline设置地图范围")
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = navColor;
        polylineView.strokeColor = navColor;
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - BMKRouteSearchDelegate
/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch*)searcher result:(BMKRidingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    SHLog(@"onGetRidingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKRidingRouteLine* plan = (BMKRidingRouteLine*)[result.routes objectAtIndex:0];
        SHLog(@"-------------------------------------------------------------------------")
        SHLog(@"%d", plan.duration)
        SHLog(@"%d", plan.duration.dates)
        SHLog(@"%d", plan.duration.hours)
        SHLog(@"%d", plan.duration.minutes)
        SHLog(@"%d", plan.duration.seconds)
//        if (plan.duration.dates > 0) {
//            _arriveTimeL.text = [NSString stringWithFormat:@"预计到达时间：%d天%d时%d分", plan.duration.dates, plan.duration.hours, plan.duration.minutes];
//        } else if (plan.duration.dates == 0  && plan.duration.hours > 0) {
//            _arriveTimeL.text = [NSString stringWithFormat:@"预计到达时间：%d时%d分", plan.duration.hours, plan.duration.minutes];
//        } else if (plan.duration.dates == 0 && plan.duration.hours == 0 && plan.duration.minutes > 0) {
//            _arriveTimeL.text = [NSString stringWithFormat:@"预计到达时间：%d分", plan.duration.minutes];
//        }
        if (plan.duration.dates > 0) {
            _timeAndDistL.text = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
            _timeL.text = [NSString stringWithFormat:@"时间：%d天%d时%d分", plan.duration.dates,plan.duration.hours,plan.duration.minutes];
        } else if (plan.duration.dates == 0 && plan.duration.hours > 0) {
            _timeAndDistL.text = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
            _timeL.text = [NSString stringWithFormat:@"时间：%d时%d分", plan.duration.hours,plan.duration.minutes];
        } else if (plan.duration.dates == 0 && plan.duration.hours == 0 && plan.duration.minutes > 0) {
            _timeAndDistL.text = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
            _timeL.text = [NSString stringWithFormat:@"时间：%d分", plan.duration.minutes];
        }
        
        SHLog(@"-------------------------------------------------------------------------")
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:i];
            if (i == 0) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
            } else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.degree = (int)transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}



/**
 *返回公交搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    SHLog(@"onGetTransitRouteResult----公交")
    //0.起点 1.终点 2.公交 3.地铁 4.驾乘 5.途经点
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine *plan = (BMKTransitRouteLine *)[result.routes objectAtIndex:0];
        SHLog(@"-------------------------------------------------------------------------")
        SHLog(@"%d", plan.duration)
        SHLog(@"%d", plan.duration.dates)
        SHLog(@"%d", plan.duration.hours)
        SHLog(@"%d", plan.duration.minutes)
        SHLog(@"%d", plan.duration.seconds)
        SHLog(@"-------------------------------------------------------------------------")
        //计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep *transitStep = [plan.steps objectAtIndex:i];
            
            if (i == 0) {
                RouteAnnotation *item = [[RouteAnnotation alloc] init];
                //路段起点信息
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item];//添加起点标注
                
            } else if (i == size - 1) {
                RouteAnnotation *item = [[RouteAnnotation alloc] init];
                //路段终点信息
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item];//添加终点标注
                
            }
            
            RouteAnnotation *item = [[RouteAnnotation alloc] init];
            //路线中的一节点，节点包括：路线起终点，公交站点等
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
        
    } else {
        SHLog(@"百度地图发生错误")
    }
    
}


/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    SHLog(@"onGetDrivingRouteResult----驾乘")
    //0.起点 1.终点 2.公交 3.地铁 4.驾乘 5.途经点
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        SHLog(@"-------------------------------------------------------------------------")
        SHLog(@"%d", plan.duration)
        SHLog(@"%d", plan.duration.dates)
        SHLog(@"%d", plan.duration.hours)
        SHLog(@"%d", plan.duration.minutes)
        SHLog(@"%d", plan.duration.seconds)
        SHLog(@"-------------------------------------------------------------------------")
        
        if (plan.duration.dates > 0) {
            _timeAndDistL.text = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
            _timeL.text = [NSString stringWithFormat:@"时间：%d天%d时%d分", plan.duration.dates,plan.duration.hours,plan.duration.minutes];
        } else if (plan.duration.dates == 0 && plan.duration.hours > 0) {
            _timeAndDistL.text = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
            _timeL.text = [NSString stringWithFormat:@"时间：%d时%d分", plan.duration.hours,plan.duration.minutes];
        } else if (plan.duration.dates == 0 && plan.duration.hours == 0 && plan.duration.minutes > 0) {
            _timeAndDistL.text = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
            _timeL.text = [NSString stringWithFormat:@"时间：%d分", plan.duration.minutes];
        }
        
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        SHLog(@"adsfasfd---%d", size);
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
    
}


/**
 *返回步行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKWalkingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    SHLog(@"onGetWalkingRouteResult----步行")
    //0.起点 1.终点 2.公交 3.地铁 4.驾乘 5.途经点
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine *plan = (BMKWalkingRouteLine *)[result.routes objectAtIndex:0];
        SHLog(@"-------------------------------------------------------------------------")
        SHLog(@"%d", plan.duration)
        SHLog(@"%d", plan.duration.dates)
        SHLog(@"%d", plan.duration.hours)
        SHLog(@"%d", plan.duration.minutes)
        SHLog(@"%d", plan.duration.seconds)
        SHLog(@"-------------------------------------------------------------------------")
        NSInteger size = [plan.steps count];
        SHLog(@"%d", size)
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep *transitStep = [plan.steps objectAtIndex:i];
            if (i == 0) {
                RouteAnnotation *item = [[RouteAnnotation alloc] init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item];
            } else if (i == size - 1) {
                RouteAnnotation *item = [[RouteAnnotation alloc] init];
                item.coordinate = transitStep.entrace.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item];
                
            }
            
            //添加annotation节点
            RouteAnnotation *item = [[RouteAnnotation alloc] init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
            
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
    
}

#pragma amrk - 拨打电话
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






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}



@end
