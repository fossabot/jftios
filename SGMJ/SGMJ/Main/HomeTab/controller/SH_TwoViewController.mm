//
//  SH_TwoViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/21.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_TwoViewController.h"
#import "SH_TestViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface RouteAnnotation: BMKPointAnnotation
{
    int _type;//0.起点 1.终点 2.公交 3.地铁 4.驾乘 5.途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;


@end

@interface SH_TwoViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKRouteSearchDelegate>

//百度地图对象
@property (nonatomic, strong) BMKMapView *mapView;
//locService对象
@property (nonatomic, strong) BMKLocationService *locService;
//路线搜索对象
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

//用户位置
@property (nonatomic, strong) BMKUserLocation *userLocation;

@end

@implementation SH_TwoViewController


- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _routeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _routeSearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMapView];
    [self getUserLocation];
    [self searchRoute];
    
    
    
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
    self.mapView.showsUserLocation = NO;//篮圈
    //设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    //允许旋转地图
    self.mapView.rotateEnabled = YES;
    //设置地图缩略图等级
    [_mapView setZoomLevel:16.1];
    //显示比例尺，和比例尺位置
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(0, SHScreenH - 90);
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

#pragma mark - createUI
- (void)createUI
{
    
}

#pragma mark - BMKMapViewDelegate
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    [_mapView updateLocationData:userLocation];
    //设置定位到的位置为屏幕中心
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //轨迹绘画
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = _userLocation.location.coordinate;
    start.cityName = SH_AppDelegate.personInfo.city;
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = CLLocationCoordinate2DMake(31.831313, 117.305042);
    end.cityName = SH_AppDelegate.personInfo.city;
    
    //驾乘
//    BMKDrivingRoutePlanOption *driveOption = [[BMKDrivingRoutePlanOption alloc] init];
//    driveOption.from = start;
//    driveOption.to = end;
//    //不获取路况信息
//    driveOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;
//    BOOL flag = [_routeSearch drivingSearch:driveOption];
//    if (flag) {
//        SHLog(@"骑乘检索返送成功")
//    } else {
//        SHLog(@"骑乘检所发送失败")
//    }
    
    //公交
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= SH_AppDelegate.personInfo.city;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routeSearch transitSearch:transitRouteSearchOption];
    if(flag){
        NSLog(@"bus检索发送成功");
    }
    else{
        NSLog(@"bus检索发送失败");
    }
    
    /**
     *计算指定两点之间的距离
     *@param a 第一个坐标点
     *@param b 第二个坐标点
     *@return 两点之间的距离，单位：米
     */
    BMKMapPoint pointStart = BMKMapPointForCoordinate(start.pt);
    BMKMapPoint pointEnd = BMKMapPointForCoordinate(end.pt);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pointStart, pointEnd);
    SHLog(@"%f", distance)
    [MBProgressHUD showMBPAlertView:[NSString stringWithFormat:@"%f距离目的地", distance] withSecond:2.0];
    
    
//    BMKPointAnnotation *poiAn = [self creatPointWithLocaiton:userLocation.location title:@"这是您的位置"];
//    BMKAnnotationView *an = [_mapView viewForAnnotation:poiAn];
//    an.tag = 1000;
    
    //[_locService stopUserLocationService];//需要停止定位，否则创建打头阵的时候会不断地添加
    
    
    /**
     *判断点是否在圆内
     *@param point 待判断的平面坐标点
     *@param center 目标圆形的中心点平面坐标
     *@param radius 目标圆形的半径，单位m
     *@return 如果在内，返回YES，否则返回NO
     */
    //UIKIT_EXTERN BOOL BMKCircleContainsPoint(BMKMapPoint point, BMKMapPoint center, double radius);
    
    if (BMKCircleContainsPoint(pointStart, pointEnd, 20)) {
        [MBProgressHUD showMBPAlertView:@"到达目的地" withSecond:2.0];
        [_locService stopUserLocationService];
    }
    
    /**
     *判断点是否在圆内
     *@param point 待判断的经纬度坐标点
     *@param center 目标圆形的中心点经纬度坐标
     *@param radius 目标圆形的半径，单位m
     *@return 如果在内，返回YES，否则返回NO
     */
    //UIKIT_EXTERN BOOL BMKCircleContainsCoordinate(CLLocationCoordinate2D point, CLLocationCoordinate2D center, double radius);
    
}

/** 封装添加大头针方法 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapView addAnnotation:point];
    return point;
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
    SHLog(@"viewForAnnotation")
    //这里判断不同的点给不同的图
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.image = [UIImage imageNamed:@"start_node"];
    newAnnotationView.animatesDrop = YES;//设置该标注点动画显示
    return newAnnotationView;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    SHLog(@"getRouteAnnotationView")
    //0.起点 1.终点 2.公交 3.地铁 4.驾乘 5.途经点
    BMKAnnotationView *view = nil;
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







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)loginBtnClick:(id)sender {
    
    SH_TestViewController *vc = [[SH_TestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}






@end
