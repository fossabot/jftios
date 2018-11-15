//
//  SHAddressModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/9.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHAddressModel : NSObject


@property (nonatomic, copy) NSString *receiveName;
@property (nonatomic, copy) NSString *receivePhone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *detailAddress;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger isDefault;              //1 默认 0不默认


@end
