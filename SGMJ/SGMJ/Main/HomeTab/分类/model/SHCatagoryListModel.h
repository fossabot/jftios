//
//  SHCatagoryListModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SHCatagoryListModel : NSObject


@property (nonatomic, assign) NSInteger creditScore;//评分
@property (nonatomic, assign) double distance;//距离
//@property (nonatomic, assign) NSInteger isFollowed;//是否关注了
@property (nonatomic, assign) BOOL isFollowed;//是否关注了
@property (nonatomic, copy) NSString *providerAvatar;//服务者头像
@property (nonatomic, assign) NSInteger providerId;//服务者id
@property (nonatomic, copy) NSString *providerNickName;//服务者昵称
@property (nonatomic, copy) NSString *providerPhone;//服务者联系方式
@property (nonatomic, assign) NSInteger providerStatus;//服务者状态      0.闲   1.忙
@property (nonatomic, strong) NSDictionary *serveSupply;
@property (nonatomic, strong) NSArray *orderAssesses;       //评论数组



/**
 
 amount                 数据
 title                  标题
 arriveAddress          到达地址
 createTime             创建时间
 departAddress          初始地址
 description            描述
 downTime
 endTime                结束时间
 id                     id
 imageList              图片数组
 isAuto                 是否显示时间
 isOpen                 是否跟踪地址
 lat
 lon
 mainCat                主分类
 subCat                 次分类
 phone                  电话
 price                  价格
 startTime              开始时间
 status                 状态
 unit                   单位
 unitId
 upTime
 userId                 用户id
 */








@end
