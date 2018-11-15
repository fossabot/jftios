//
//  SHPersonMainModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/24.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHPerNeedModel;
@class SHPerCommentModel;
@class SHRealeaseServiceModel;
@interface SHPersonMainModel : NSObject


@property (nonatomic, strong) SHPerCommentModel *assesses;
@property (nonatomic, strong) SHPerNeedModel *needs;
@property (nonatomic, strong) SHRealeaseServiceModel *serveSupplies;

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, assign) NSInteger fansNum;
@property (nonatomic, assign) NSInteger followNum;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, assign) NSInteger isFollow;
@property (nonatomic, copy) NSString *mobile;


@end
