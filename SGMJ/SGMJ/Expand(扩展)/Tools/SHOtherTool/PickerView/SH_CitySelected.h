//
//  SH_CitySelected.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SH_PickerViewAddressType,               //地址选择器
    SH_PickerViewSexType,                   //性别选择器
    SH_PickerViewServiceType                //服务类别选择器
} SH_PickerViewSelectedType;

typedef void(^CitySelectedSureBtnClick)(NSString *province ,NSString *city ,NSString *town);

@interface SH_CitySelected : UIView

@property (nonatomic, strong) NSString *province;           /** 省 */
@property (nonatomic, strong) NSString *city;               /** 市 */
@property (nonatomic, strong) NSString *town;               /** 县 */
@property (nonatomic, copy) CitySelectedSureBtnClick config;

@end
