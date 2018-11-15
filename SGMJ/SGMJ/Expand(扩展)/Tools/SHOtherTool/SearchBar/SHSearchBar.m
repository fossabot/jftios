//
//  SHSearchBar.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSearchBar.h"


#define DefulatBorderColor [UIColor colorWithRed:4/255.0 green:193/255.0 blue:173/255.0 alpha:1.0].CGColor
#define DefulatTintColor [UIColor colorWithRed:4/255.0 green:193/255.0 blue:173/255.0 alpha:1.0];
#define DefulatPlacehoderString @"搜索"

@implementation SHSearchBar

#pragma mark - override  initWithFrame:
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithFrame:frame];
    }
    return self;
    
}

#pragma mark public     initialization
- (instancetype)initWithFrame:(CGRect)frame boardColor:(UIColor *)color placeholderString:(NSString *)placehoderString
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.boardColor = color;
        self.placeholderString = placehoderString;
        [self setupWithFrame:frame];
    }
    return self;
}



#pragma mark - private method
- (void)setupWithFrame:(CGRect)frame
{
    self.layer.cornerRadius = frame.size.height / 2.0;
    self.clipsToBounds = YES;
//    if (self.boardLineWidth < 1.0 || self.boardLineWidth > 5.0) {
//        self.layer.borderWidth = 1.0;
//    } else {
//        self.layer.borderWidth = self.boardLineWidth;
//    }
//    self.barTintColor = [UIColor whiteColor];
//    self.layer.borderColor = self.boardColor.CGColor ? self.boardColor.CGColor : DefulatBorderColor;
    self.tintColor = self.boardColor?self.boardColor:DefulatTintColor;
    self.placeholder = self.placeholderString?self.placeholderString:DefulatPlacehoderString;
}



@end
