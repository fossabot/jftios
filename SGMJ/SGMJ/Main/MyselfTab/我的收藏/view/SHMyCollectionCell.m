//
//  SHMyCollectionCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMyCollectionCell.h"

static CGFloat margin = 13;

@interface SHMyCollectionCell()

#pragma mark 第一个view
//头像
@property (nonatomic, strong) UIImageView *headImgV;

//认证image
@property (nonatomic, strong) UIImageView *authImgV;

//名称
@property (nonatomic, strong) UILabel *nameLabel;

//查看的时间
@property (nonatomic, strong) UILabel *timeLabel;

//价格
@property (nonatomic, strong) UILabel *priceLabel;

#pragma mark - 第二个view
//图片view
@property (nonatomic, strong) UIView *pictureView;
@property (nonatomic, strong) NSMutableArray *imageVArray;

//描述
@property (nonatomic, strong) UILabel *contentLabel;

//描述下方的划线
@property (nonatomic, strong) UILabel *colorLabel;

#pragma mark - 第三个view
@property (nonatomic, strong) UIView *bottomView;
//来自地点
@property (nonatomic, strong) UILabel *fromLabel;

//是否取消关注
@property (nonatomic, strong) UIButton *followButton;

@end

@implementation SHMyCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.imageVArray = [NSMutableArray array];
        [self initView];
    }
    return self;
}

- (void)initView
{
    SHLog(@"adfadr")
    [self initTopView];
    //[self initCenterView];
    //[self initBottomView];
}


//第一个view
- (void)initTopView
{
    //头像
    self.headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, 50, 50)];
    self.headImgV.layer.cornerRadius = 25;
    self.headImgV.clipsToBounds = YES;
    [self.contentView addSubview:self.headImgV];
    
    //认证头像
    self.authImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.headImgV.width + margin - 10, self.headImgV.height + margin - 10, 20, 20)];
    [self.contentView addSubview:self.authImgV];
    
    //名称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgV.frame) + 24, 27, 0, 20)];
    self.nameLabel.font = SH_FontSize(15);
    self.nameLabel.text = @"dfafsd";
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.nameLabel];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame) + 12, 0, 20)];
    self.timeLabel.font = SH_FontSize(14);
    self.timeLabel.text = @"afdfasd";
    self.timeLabel.textColor = SHColorFromHex(0xb7b6b6);
    [self.contentView addSubview:self.timeLabel];
    
    //价格
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHScreenW - 13 - 80, self.headImgV.centerY, 80, 30)];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel.font = SH_FontSize(16);
    self.priceLabel.textColor = SHColorFromHex(0xd84841);
    [self.contentView addSubview:self.priceLabel];
    
    
}

//第二个view
- (void)initCenterView
{
    //九张图片
//    for (int i = 0; i < 9; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:imageView];
//        [self.imageVArray addObject:imageView];
//        
//    }
    self.pictureView = [[UIView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.headImgV.frame) + 15, SHScreenW - 2 * margin, 80)];
    self.pictureView.backgroundColor = navColor;
    [self.contentView addSubview:self.pictureView];
    
    //描述
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.pictureView.frame) + 15, SHScreenW - 2 * margin, 0)];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"asdfadsfa";
    self.contentLabel.font = SH_FontSize(15);
    //计算文本的高度
    CGRect contentRect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.contentLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SH_FontSize(15)} context:nil];
    self.contentLabel.height = contentRect.size.height;
    [self.contentView addSubview:self.contentLabel];
    
    //分界线
    self.colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame) + 12, SHScreenW, 0.5)];
    self.colorLabel.backgroundColor = SHColorFromHex(0xb7b6b6);
    [self.contentView addSubview:self.colorLabel];
    
    
}

//第三个view
- (void)initBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colorLabel.frame), SHScreenW, 42)];
    [self.contentView addSubview:self.bottomView];
    
    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel.centerY = self.bottomView.centerY;
    self.fromLabel.x = margin;
    self.fromLabel.text = @"来自合肥";
    [self.bottomView addSubview:self.fromLabel];
    
    self.followButton = [[UIButton alloc] initWithFrame:CGRectMake(SHScreenW - 10 - 100, 10, 100, 30)];
    self.followButton.cornerRadius = 5;
    self.followButton.clipsToBounds = YES;
    [self.followButton.layer setBorderWidth:1.0];
    self.followButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
    [self.bottomView addSubview:self.followButton];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
