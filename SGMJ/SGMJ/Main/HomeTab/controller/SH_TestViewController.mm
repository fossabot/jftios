//
//  SH_TestViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/21.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_TestViewController.h"
#import "SH_TwoViewController.h"

#import "SH_DateTimePickerView.h"
#import "SH_CitySelected.h"
#import "SH_AlertView.h"
#import "SH_PictureScanView.h"

#import "TZImagePickerController.h"

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "UIImage+Image.h"

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface SH_TestViewController () <SHDateTimePickerViewDelegate, SHAlertViewDelegate, TZImagePickerControllerDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKRouteSearchDelegate> {
    CLLocationCoordinate2D _endPt;
    CLLocationCoordinate2D _startPt;
}

@property (nonatomic, strong) SH_DateTimePickerView *datePickView;
@property (nonatomic, strong) SH_CitySelected *cityChoose;
//@property (nonatomic, strong) SH_DateTimePickerView *datePickView;          //时间选择器

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) BMKMapView *mapView;//地图
@property (nonatomic, strong) BMKLocationService *locService;//定位
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

@property (nonatomic, strong) NSMutableArray *nodesArray;

@property (nonatomic, strong) BMKUserLocation *userLocation;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CLLocationDistance distance;

@end

@implementation SH_TestViewController


- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    //地图的代理用到的时候设置
    _mapView.delegate = self;
    _locService.delegate = self;
    
    _routeSearch.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    //不需要的时候置为nil
    _mapView.delegate = nil;
    _locService.delegate = nil;
    
    _routeSearch.delegate = nil;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self loadMapView];
    [self getUserLocation];
    [self searchRoute];
    
//    _nodesArray = [[NSMutableArray alloc] initWithCapacity:2];
//    //起点
//    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
//
//    startNode.pt = CLLocationCoordinate2DMake(22.547058, 113.936392);
//    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
//
//    endNode.pt = CLLocationCoordinate2DMake(31.831169, 117.305099);
//    BMKWalkingRoutePlanOption *walkOption = [[BMKWalkingRoutePlanOption alloc] init];
//    walkOption.from = startNode;
//    walkOption.to = endNode;
    
    
    [self initBaseInfo];
    [self getServicerLocation];
    
}

- (void)initBaseInfo
{
    self.title = @"距离";
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(getServicerLocation) userInfo:nil repeats:YES];
    
}

- (void)getServicerLocation
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"serverId":@(_serverId)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHGetServicerLocUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            _endPt.latitude = [JSON[@"lat"] doubleValue];
            _endPt.longitude = [JSON[@"lng"] doubleValue];
            [weakSelf dealWithLocation:_endPt];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)dealWithLocation:(CLLocationCoordinate2D)location
{
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    start.pt = CLLocationCoordinate2DMake(_userLocation.location.coordinate.latitude, _userLocation.location.coordinate.longitude);
    end.pt = CLLocationCoordinate2DMake(location.latitude, location.longitude);
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
    
    
}

#pragma mark - 加载地图
- (void)loadMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    self.view = _mapView;
    
}

#pragma mark - 定位功能
- (void)getUserLocation
{
    [self setMapProperty];
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc] init];
        [_locService setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    _locService.distanceFilter = 5.0;//设置定位的最小距离
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}

#pragma mark - 添加搜索功能
- (void)searchRoute
{
    _routeSearch = [[BMKRouteSearch alloc] init];
    
    
//    BMKPlanNode *start = [[BMKPlanNode alloc] init];
//    start.pt = _userLocation.location.coordinate;
//    start.cityName = @"合肥市";
//    BMKPlanNode *end = [[BMKPlanNode alloc] init];
//    end.pt = CLLocationCoordinate2DMake(31.851313, 117.271324);
//    end.cityName = @"合肥市";
//
//    BMKDrivingRoutePlanOption *driveOption = [[BMKDrivingRoutePlanOption alloc] init];
//    driveOption.from = start;
//    driveOption.to = end;
//    driveOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
//
//    BOOL flag = [_routeSearch drivingSearch:driveOption];
//    if (flag) {
//        SHLog(@"驾车规划检索成功")
//    } else {
//        SHLog(@"驾车规划检索失败")
//    }
    
}

#pragma mark - 事件
//骑行
- (IBAction)driveWalkBtnClick:(UIButton *)sender {
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = CLLocationCoordinate2DMake(31.831313, 117.305042);
    start.cityName = @"合肥市shi";
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = CLLocationCoordinate2DMake(31.851313, 117.271324);
    end.cityName = @"合肥市";
    
    BMKRidingRoutePlanOption *option = [[BMKRidingRoutePlanOption alloc] init];
    option.from = start;
    option.to = end;
    
    BOOL flag = [_routeSearch ridingSearch:option];
    if (flag) {
        SHLog(@"骑行规划检索成功")
    } else {
        SHLog(@"骑行规划检索发送失败")
    }
}

//驾车
- (IBAction)driveCarBtnClick:(UIButton *)sender {
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = _userLocation.location.coordinate;
    start.cityName = @"合肥市shi";
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = CLLocationCoordinate2DMake(31.851313, 117.271324);
    end.cityName = @"合肥市";
    
    BMKDrivingRoutePlanOption *driveOption = [[BMKDrivingRoutePlanOption alloc] init];
    driveOption.from = start;
    driveOption.to = end;
    driveOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    
    BOOL flag = [_routeSearch drivingSearch:driveOption];
    if (flag) {
        SHLog(@"驾车规划检索成功")
    } else {
        SHLog(@"驾车规划检索失败")
    }
    
    
    
}




/**
 *  设置地图属性
 */
- (void)setMapProperty
{
    self.mapView.showsUserLocation = YES;
    //设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    //允许旋转地图
    self.mapView.rotateEnabled = YES;
    //设置地图显示大小比例等级
    [_mapView setZoomLevel:16.1];
    
    //显示比例尺和比例尺的位置
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(0, SHScreenH - 90);
    //定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = YES;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = YES;//精度圈是否显示
    
    [self.mapView updateLocationViewWithParam:displayParam];
    
    
    
}

//实现相关代理 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    SHLog(@"didUpdateUserHeading")
    [_locService stopUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    SHLog(@"%f-%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    BMKPointAnnotation *poiAn = [self creatPointWithLocaiton:userLocation.location title:@"这是您的位置"];
    BMKAnnotationView *an = [_mapView viewForAnnotation:poiAn];
    an.tag = 10000;
    
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = _userLocation.location.coordinate;
    start.cityName = @"合肥市";
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = CLLocationCoordinate2DMake(self.lat, self.lon);
    end.cityName = @"合肥市";
    
    BMKDrivingRoutePlanOption *driveOption = [[BMKDrivingRoutePlanOption alloc] init];
    driveOption.from = start;
    driveOption.to = end;
    driveOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    
    BOOL flag = [_routeSearch drivingSearch:driveOption];
    if (flag) {
        SHLog(@"驾车规划检索成功")
    } else {
        SHLog(@"驾车规划检索失败")
    }
    
    [_locService stopUserLocationService];
    
    
    
}

#pragma mark - annotation添加标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }
    
    //这里没做任何的判断，开发者可以根据自己的要求，判断不同点给不同的图
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    //newAnnotationView.image = [UIImage imageNamed:@"returnBack"];
    newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
    return newAnnotationView;
}

/** 封装添加大头针方法 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title;
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapView addAnnotation:point];
    return point;
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    //这里是点击大头针上面气泡触发的方法，可以写点击触发事件。如果需要区分是哪个大头针被点中，我用的是给她加tag值
    NSLog(@"%ld",(long)view.tag);
}



- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = navColor;
        polylineView.strokeColor = navColor;
        polylineView.lineWidth = 3.0;
        return polylineView;
        
    }
    
    return nil;
}

#pragma mark - BMKRouteSearchDelegate
/**
 *  返回公交搜索结果
 *  searcher    搜索对象
 *  result      搜索结果 类型为BMKTransitRouteResult
 *  error       错误号         BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    
}

/**
 *  返回驾乘搜索结果
 *  sercher 搜索对象
 *  result  搜索结果    类型为BMKDrivingRouteResult
 *  error   错误号     BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        
        
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"我的位置";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                
                if (plan.duration.dates > 0) {
                    item.title = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
                } else if (plan.duration.dates == 0 && plan.duration.hours > 0) {
                    item.title = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
                } else if (plan.duration.dates == 0 && plan.duration.hours == 0 && plan.duration.minutes > 0) {
                    item.title = [NSString stringWithFormat:@"距离：%.2f公里", _distance / 1000];
                }
                
//                item.title = @"终点我是谁哈哈哈哈哈哈哈哈哈哈哈哈哈";
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
        SHLog(@"adsfasfd---%d", planPointCounts);
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
        //[_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
    }
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"icon_nav_start"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"icon_nav_end"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"icon_nav_bus"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"icon_nav_rail"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            //UIImage* image = [UIImage imageNamed:@"icon_direction"];
            //view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            //view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageNamed:@"icon_nav_waypoint"];
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









- (IBAction)buttonClick:(UIButton *)sender {
    //SH_TwoViewController *vc = [[SH_TwoViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    
    //时间选择
//    SH_DateTimePickerView *pickerView = [[SH_DateTimePickerView alloc] init];
//    self.datePickerView = pickerView;
//    pickerView.dateDelegate = self;
//    pickerView.pickerViewMode = SHDatePickerViewHM;
//    [self.view addSubview:pickerView];
//    [pickerView showDateTimePickerView];
    
    
    //二级联动
//    self.cityChoose = [[SH_CitySelected alloc] init];
//    self.cityChoose.pickerViewType = SH_PickerViewServiceType;
//    self.cityChoose.citySelectedBlock = ^(NSString *string) {
//        SHLog(@"%@---", string)
//    };
//    [self.view addSubview:self.cityChoose];
    
    //弹框
//    SH_AlertView *alertView = [[SH_AlertView alloc] initWithTitle:@"adf" message:@"adf" cancelBtnTitle:@"0" otherBtnTitle:@"1"];
//    alertView.delegate = self;
//    [alertView show];
    
//    NSArray *imgUrls = @[@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg",@"http://imgk.zol.com.cn/dcbbs/2342/a2341460.jpg",@"http://www.zhlzw.com/UploadFiles/Article_UploadFiles/201204/20120412123912727.jpg",@"http://www.zhlzw.com/UploadFiles/Article_UploadFiles/201303/2013030914500355.jpg"];
//    SH_PictureScanView *picView = [[SH_PictureScanView alloc] initWithFrame:self.view.bounds withImgs:nil withImgUrl:imgUrls];
//    picView.eventBlock = ^(NSString *event){
//        NSLog(@"触发事件%@",event);
//    };
//    //[self.view addSubview:picView];
//    UIWindow * window = [UIApplication sharedApplication].windows[0];
//    [window addSubview:picView];
    
    
//    SH_DateTimePickerView *pickerView = [[SH_DateTimePickerView alloc] init];
//    self.datePickView = pickerView;
//    pickerView.dateDelegate = self;
//    pickerView.pickerViewMode = SHDatePickerViewYMD;
//    [self.view addSubview:pickerView];
//    [pickerView showDateTimePickerView];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingGif = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        SHLog(@"%@", photos)
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

#pragma mark - SHDateTimePickerViewDelegate
- (void)didClickFinishDateTimePickerView:(NSString *)date {
    NSLog(@"adsfaf%@", date);
    
}

#pragma mark - SHAlertViewDelegate
- (void)shAlertView:(SH_AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SHLog(@"%ld", (long)buttonIndex)
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
