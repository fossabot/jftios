//
//  SHSearchBar.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSearchBar : UISearchBar

//default #06c1ae
@property (nonatomic, strong) UIColor *boardColor;

//default lanmaq searchbar
@property (nonatomic, copy) NSString *placeholderString;

//default 1.0max 5.0 min 1.0
@property (nonatomic, assign) CGFloat boardLineWidth;


// use default set color nil , placeholderString nil
- (instancetype)initWithFrame:(CGRect)frame boardColor:(UIColor *)color placeholderString:(NSString *)placehoderString;


@end
