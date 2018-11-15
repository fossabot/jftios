//
//  SHCatagoryView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHCatagoryType){
    SHCatagorySelectType,               //分类选择
    SHSexSelectType,                    //性别选择
    SHAdvertisementType                 //广告
};

typedef void(^SHCatagoarySelectBlock)(NSString *leftString,NSString *rightString,NSString *string);

@interface SHCatagoryView : UIView

@property (nonatomic, assign) SHCatagoryType type;

@property (nonatomic, copy) SHCatagoarySelectBlock catagoarySelectBlock;

@property (nonatomic, strong) NSArray *needArray;

- (instancetype)initWithDict:(NSMutableDictionary *)dic;

- (instancetype)initWithArray:(NSArray *)array;

@end
