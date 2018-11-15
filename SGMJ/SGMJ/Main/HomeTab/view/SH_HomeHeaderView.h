//
//  SH_HomeHeaderView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HeaderViewClicked) {
    HeaderViewClickedBanner,
    HeaderViewClickedCategory,
};


#define itemW ((SHScreenW-40)/5.f)


#import <UIKit/UIKit.h>


typedef void(^CategoryClickBlock)(HeaderViewClicked clicked, NSInteger num);

@interface SH_HomeHeaderView : UIView

@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray *categoryArr;

@property (nonatomic, copy) CategoryClickBlock categoryClickBlock;

@end
