//
//  SHBaiduAddressModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHBaiduAddressModel : NSObject

@property (nonatomic, strong) NSString *deptName;
@property (nonatomic, strong) NSString *addr;


@property (nonatomic, strong) NSString *deptId;
@property (nonatomic, strong) NSString *deptNumber;
@property (nonatomic, strong) NSString *rootDept;
@property (nonatomic, strong) NSString *snCode;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *parentSnCode;
@property (nonatomic, strong) NSString *parentCityName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *distance;


/**
 
 deptId:部门ID
 deptNumber:部门编号
 deptName:部门名称
 rootDept:上级部门编号
 snCode:当前区域编号
 cityName:当前区域名称
 parentSnCode:父级区域编号
 parentCityName:父级区域名称
 addr:地址
 status:部门状态
 phone:电话号码
 lng:经度
 lat:纬度
 distance:距离(double 单位:公里)
 
 
 */















@end
