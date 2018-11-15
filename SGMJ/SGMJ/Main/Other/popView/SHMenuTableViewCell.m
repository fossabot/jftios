//
//  SHMenuTableViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMenuTableViewCell.h"

#define kLineXY 15.f    // 距离
#define kImgWidth 20.f    // 图片宽
#define kImgLabelWidth 10.f    // 图片和Label宽

@implementation SHMenuTableViewCell

- (UIView *)lineView
{
    if (!_lineView) {
        self.lineView = ({
            UIView *lineview = [UIView new];
            lineview.backgroundColor = SHColorFromHex(0xe4e4e4);
            lineview.frame = CGRectMake(kLineXY, 0, _width - kLineXY * 2, 1);
            lineview;
        });
    }
    return _lineView;
}

- (UIImageView *)iconImg
{
    if (!_iconImg) {
        self.iconImg = ({
            UIImageView *imageView = [UIImageView new];
            imageView.frame = CGRectMake(kLineXY, (_height-kImgWidth)/2, kImgWidth, kImgWidth);
            imageView;
        });
    }
    return _iconImg;
}

- (UILabel *)conLabel
{
    if (!_conLabel) {
        self.conLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = SHColorFromHex(0x333333);
            label.font = [UIFont systemFontOfSize:14];
            label.frame = CGRectMake(CGRectGetMaxX(self.iconImg.frame) + kImgLabelWidth, 0, _width - kImgLabelWidth - kLineXY - kImgWidth - 15, _height);
            label;
        });
    }
    return _conLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width height:(CGFloat)height
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _width = width;
        _height = height;
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.conLabel];
    }
    return self;
}


- (void)setContentByTitArray:(NSMutableArray *)titArray ImgArray:(NSMutableArray *)imgArray row:(NSInteger)row
{
    if (imgArray.count == 0) {
        _iconImg.hidden = YES;
        self.conLabel.frame = CGRectMake(kLineXY, 0, _width - kLineXY*2 , _height);
        _conLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        _iconImg.hidden = NO;
        self.conLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImg.frame) + kImgLabelWidth, 0, _width - kImgLabelWidth - kLineXY - kImgWidth - 15, _height);
        _iconImg.image = [[UIImage imageNamed:imgArray[row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _conLabel.text = titArray[row];
    }
}








- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
