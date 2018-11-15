//
//  SHCollectionCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHCollectionCell.h"


static CGFloat margin = 13;

@interface SHCollectionCell()

#pragma mark 第一个view
@property (nonatomic, strong) UIView *topView;
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
@property (nonatomic, strong) UIView *middleView;
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

@implementation SHCollectionCell

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
    SHLog(@"去玩儿群翁人情味r")
    [self initTopView];
    //[self initCenterView];
    [self initBottomView];
}


//第一个view
- (void)initTopView
{
    SHWeakSelf
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 86)];
    [self.contentView addSubview:self.topView];
    //头像
    self.headImgV = [[UIImageView alloc] init];
    self.headImgV.image = [UIImage imageNamed:@"head"];
    [self.topView addSubview:self.headImgV];
    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.topView);
        make.left.equalTo(weakSelf.topView).with.offset(13);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    //认证
    self.authImgV = [[UIImageView alloc] init];
    self.authImgV.image = [UIImage imageNamed:@"head"];
    [self.topView addSubview:self.authImgV];
    [self.authImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headImgV.mas_right).with.offset(-10);
        make.bottom.equalTo(weakSelf.headImgV);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    //名称
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"测试";
    self.nameLabel.font = SH_FontSize(15);
    [self.topView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headImgV).with.offset(5);
        make.left.equalTo(weakSelf.headImgV.mas_right).with.offset(24);
    }];
    
    //时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = @"2小时拉过";
    self.timeLabel.font = SH_FontSize(12);
    self.timeLabel.textColor = SHColorFromHex(0xb7b6b6);
    [self.topView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel);
        make.bottom.mas_equalTo(weakSelf.headImgV).with.offset(-5);
    }];
    
    //价格
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.text = @"￥5000";
    self.priceLabel.textColor = SHColorFromHex(0xd84841);
    self.priceLabel.font = SH_FontSize(16);
    [self.topView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.topView.mas_right).with.offset(-13);
        make.centerY.mas_equalTo(weakSelf.topView);
    }];
    
}


- (void)initBottomView
{
    SHWeakSelf
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SHScreenW, 42)];
    [self.contentView addSubview:self.bottomView];
    
    //来自
    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel.text = @"来自合肥";
    self.fromLabel.textColor = navColor;
    self.fromLabel.font = SH_FontSize(12);
    [self.bottomView addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bottomView);
        make.left.equalTo(weakSelf.bottomView).with.offset(margin);
    }];
    
    //取消关注
    self.followButton = [[UIButton alloc] init];
    [self.followButton setImage:[UIImage imageNamed:@"delete3"] forState:UIControlStateNormal];
    [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
    self.followButton.titleLabel.font = SH_FontSize(12);
    self.followButton.layer.cornerRadius = 3;
    self.followButton.clipsToBounds = YES;
    self.followButton.borderWidth = 1;
    self.followButton.borderColor = navColor;
    [self.followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.followButton];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bottomView);
        make.right.equalTo(weakSelf.bottomView.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    
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
