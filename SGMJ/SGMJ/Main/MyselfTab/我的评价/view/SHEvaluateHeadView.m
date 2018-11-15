//
//  SHEvaluateHeadView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHEvaluateHeadView.h"
#import "SDCycleScrollView.h"
#import "SHEvaluateDetailModel.h"

@interface SHEvaluateHeadView ()

@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UIImageView *authoriseImgV;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *evaLevelL;               //评价等级：好评、中评、差评
@property (nonatomic, strong) UILabel *contentL;                //评论
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UIView *feedBackBgV;              //回复的背景view
@property (nonatomic, strong) UILabel *feedBackL;               //回复的内容

@property (nonatomic, strong) UIView *goodBgView;
@property (nonatomic, strong) UIImageView *goodImgV;
@property (nonatomic, strong) UILabel *goodTitleL;
@property (nonatomic, strong) UILabel *goodPriceL;


@end

@implementation SHEvaluateHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - setting
- (void)setDetailModel:(SHEvaluateDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    if (detailModel.images.count > 0) {
        
        NSString *urlString = nil;
        for (int i = 0; i < detailModel.images.count; i++) {
            if (![detailModel.images[i] isEqualToString:@""]) {
                if (urlString) {
                    urlString = [NSString stringWithFormat:@"%@,%@", urlString, detailModel.images[i]];
                } else {
                    urlString = [NSString stringWithFormat:@"%@", detailModel.images[i]];
                }
            }
        }
        
        SHLog(@"%@", urlString)
        
        NSArray *array = [NSArray array];
        if (urlString) {
            array = [urlString componentsSeparatedByString:@","];
        }
        SHLog(@"%@", array)
        if (array.count > 0) {
            self.cycleView.imageURLStringsGroup = array;
        }
        
    } else {
        self.cycleView.hidden = YES;
    }
    
    
    
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:detailModel.assessUserAvatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    self.nameL.text = detailModel.assessUserNickName;
    self.timeL.text = detailModel.createTime;
    if (detailModel.score == 0 || detailModel.score == 1 || detailModel.score == 2) {
        self.evaLevelL.text = @"差评";
    } else if (detailModel.score == 3) {
        self.evaLevelL.text = @"中评";
    } else if (detailModel.score == 4 || detailModel.score == 5) {
        self.evaLevelL.text = @"好评";
    }
    self.contentL.text = detailModel.content;
    
    [self.goodImgV sd_setImageWithURL:[NSURL URLWithString:detailModel.productImg] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    self.goodTitleL.text = detailModel.productTitle;
    
    self.goodPriceL.text = [NSString stringWithFormat:@"%.2f\/%@", detailModel.productPrice, detailModel.productUnit];
    
    
}

#pragma mark - layut
- (void)layout
{
    //10+40
    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(13);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    [self.authoriseImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImgV.mas_bottom);
        make.right.equalTo(self.headImgV.mas_right).offset(6);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(12);
    }];
    
    //
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImgV.mas_top);
        
        make.left.equalTo(self.headImgV.mas_right).offset(15);
        
    }];
    
    [self.evaLevelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameL.mas_left);
        make.bottom.mas_equalTo(self.headImgV.mas_bottom);
        
    }];
    
    
    _editButton = [[UIButton alloc] init];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_editButton setTitleColor:navColor forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImgV.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-13);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];
    
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.evaLevelL.mas_centerY);
        make.left.equalTo(self.evaLevelL.mas_right).offset(10);
    }];
    
    //10+高度
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgV.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(13);
        make.right.equalTo(self.mas_right).offset(-13);
    }];
    
    //10+249+10
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentL.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(13);
        make.right.equalTo(self.mas_right).offset(-13);
        make.height.mas_equalTo(249);
    }];
    
    //高度
    [self.feedBackBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(13);
        make.right.equalTo(self.mas_right).offset(-13);
        
    }];
    
    [self.feedBackL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedBackBgV.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.feedBackBgV.mas_left).offset(5);
        make.right.equalTo(self.feedBackBgV.mas_right).offset(-5);
    }];
    
    //70
    [self.goodBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedBackBgV.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(70);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.goodImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.goodBgView.mas_centerY);
        make.left.equalTo(self.goodBgView.mas_left).offset(13);
        make.height.and.width.mas_equalTo(50);
    }];
    
    [self.goodTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodImgV.mas_right).offset(15);
        make.right.equalTo(self.mas_right).offset(-13);
        make.top.mas_equalTo(self.goodImgV.mas_top);
    }];
    
    [self.goodPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodTitleL.mas_left);
        make.bottom.mas_equalTo(self.goodImgV.mas_bottom);
    }];
    
    
}

#pragma mark - action
- (void)editButtonClick
{
    SHLog(@"编辑")
    if ([_delegate respondsToSelector:@selector(beginEditEvaluate:)]) {
        [_delegate beginEditEvaluate:_detailModel];
    }
    
    
}



#pragma mark - lazying
- (SDCycleScrollView *)cycleView
{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"mybanner"]];
        _cycleView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleView.autoScrollTimeInterval = 3;
        _cycleView.showPageControl = YES;
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [self addSubview:_cycleView];
    }
    return _cycleView;
}

- (UIImageView *)headImgV
{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc] init];
        _headImgV.image = [UIImage imageNamed:@"defaultHead"];
        _headImgV.layer.cornerRadius = 20;
        _headImgV.layer.masksToBounds = YES;
        [self addSubview:_headImgV];
    }
    return _headImgV;
}

- (UIImageView *)authoriseImgV
{
    if (!_authoriseImgV) {
        _authoriseImgV = [[UIImageView alloc] init];
        _authoriseImgV.image = [UIImage imageNamed:@"authorize"];
        [self addSubview:_authoriseImgV];
    }
    return _authoriseImgV;
}

- (UILabel *)nameL
{
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
        _nameL.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameL];
    }
    return _nameL;
}

- (UILabel *)timeL
{
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.textColor = SHColorFromHex(0x9a9a9a);
        _timeL.font = [UIFont systemFontOfSize:10];
        [self addSubview:_timeL];
    }
    return _timeL;
}

- (UILabel *)evaLevelL
{
    if (!_evaLevelL) {
        _evaLevelL = [[UILabel alloc] init];
        _evaLevelL.textColor = navColor;
        _evaLevelL.font = [UIFont systemFontOfSize:11];
        [self addSubview:_evaLevelL];
    }
    return _evaLevelL;
}

- (UIButton *)editButton
{
    if (!_editButton) {
//        _editButton = [[UIButton alloc] init];
//        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
//        [_editButton setTitleColor:navColor forState:UIControlStateNormal];
//        [_editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_editButton];
    }
    return _editButton;
}

- (UILabel *)contentL
{
    if (!_contentL) {
        _contentL = [[UILabel alloc] init];
        _contentL.font = [UIFont systemFontOfSize:14];
        [_contentL sizeToFit];
        _contentL.numberOfLines = 0;
        [self addSubview:_contentL];
    }
    return _contentL;
}

- (UIView *)feedBackBgV
{
    if (!_feedBackBgV) {
        _feedBackBgV = [[UIView alloc] init];
        [self addSubview:_feedBackBgV];
    }
    return _feedBackBgV;
}

- (UILabel *)feedBackL
{
    if (!_feedBackL) {
        _feedBackL = [[UILabel alloc] init];
        _feedBackL.font = [UIFont systemFontOfSize:12.0];
        _feedBackL.textColor = SHColorFromHex(0x666666);
        [_feedBackBgV addSubview:_feedBackL];
    }
    return _feedBackL;
}

- (UIView *)goodBgView
{
    if (!_goodBgView) {
        _goodBgView = [[UIView alloc] init];
        _goodBgView.backgroundColor = SHColorFromHex(0xf2f2f2);
        [self addSubview:_goodBgView];
    }
    return _goodBgView;
}

- (UIImageView *)goodImgV
{
    if (!_goodImgV) {
        _goodImgV = [[UIImageView alloc] init];
        _goodImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
        [_goodBgView addSubview:_goodImgV];
    }
    return _goodImgV;
}

- (UILabel *)goodTitleL
{
    if (!_goodTitleL) {
        _goodTitleL = [[UILabel alloc] init];
        _goodTitleL.font = [UIFont systemFontOfSize:14];
        _goodTitleL.textColor = SHColorFromHex(0x666666);
        [_goodBgView addSubview:_goodTitleL];
    }
    return _goodTitleL;
}

- (UILabel *)goodPriceL
{
    if (!_goodPriceL) {
        _goodPriceL = [[UILabel alloc] init];
        _goodPriceL.textColor = SHColorFromHex(0xc4483c);
        [_goodBgView addSubview:_goodPriceL];
    }
    return _goodPriceL;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentL sizeToFit];
}



@end






