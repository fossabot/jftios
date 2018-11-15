//
//  SHMenuTableViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMenuTableViewCell : UITableViewCell
{
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *conLabel;
@property (nonatomic, strong) UIView *lineView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width height:(CGFloat)height;
- (void)setContentByTitArray:(NSMutableArray *)titArray ImgArray:(NSMutableArray *)imgArray row:(NSInteger)row;





@end
