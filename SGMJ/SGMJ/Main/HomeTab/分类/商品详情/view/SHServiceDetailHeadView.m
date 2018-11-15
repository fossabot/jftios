//
//  SHServiceDetailHeadView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHServiceDetailHeadView.h"
#import "SHStarRateView.h"
#import "SDCycleScrollView.h"
#import "SHCatagoryListModel.h"



@interface SHServiceDetailHeadView ()

@property (nonatomic, strong) UIImageView *headImgV;        //头像
@property (nonatomic, strong) UIImageView *authoriseImgV;   //V
@property (nonatomic, strong) UIImageView *busyImgV;        //闲、忙
@property (nonatomic, strong) UILabel *nameL;               //名字
@property (nonatomic, strong) SHStarRateView *evaluateView; //评价的view
@property (nonatomic, strong) UIButton *cancelButton;       //关注按钮
@property (nonatomic, strong) SDCycleScrollView *cycleView;//轮播图
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *scoreL;

@property (nonatomic, strong) UIImageView *firstImgV;
@property (nonatomic, strong) UIImageView *secImgV;
@property (nonatomic, strong) UIImageView *thirdImgV;
@property (nonatomic, strong) UIImageView *fourImgV;
@property (nonatomic, strong) UIImageView *fiveImgV;

@property (nonatomic, strong) UILabel *bottomL;

@end

@implementation SHServiceDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self stepUI];
    }
    return self;
}

- (void)stepUI
{
    //20+40=60
    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self.mas_left).offset(13);
        make.height.and.width.mas_equalTo(40);
        
    }];
    
    [self.authoriseImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImgV.mas_right).offset(6);
        make.bottom.mas_equalTo(self.headImgV.mas_bottom);
        make.height.and.width.mas_equalTo(12);
        
    }];
    
    [self.busyImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImgV.mas_top);
        make.right.equalTo(self.headImgV.mas_right).offset(6);
        make.height.and.width.mas_equalTo(12);
    }];
    
    //80
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImgV.mas_top);
        make.left.equalTo(self.busyImgV.mas_right).offset(15);
        
    }];
    
    [self.firstImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameL.mas_left);
        make.bottom.mas_equalTo(self.headImgV.mas_bottom);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.secImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstImgV.mas_right).offset(3);
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.thirdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.left.equalTo(self.secImgV.mas_right).offset(3);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.fourImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.left.equalTo(self.thirdImgV.mas_right).offset(3);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.fiveImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.left.equalTo(self.fourImgV.mas_right).offset(3);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.left.equalTo(self.fiveImgV.mas_right).offset(5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(15);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImgV.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-13);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
        
    }];
    
    //234+10
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13);
        make.right.equalTo(self.mas_right).offset(-13);
        make.top.equalTo(self.headImgV.mas_bottom).offset(10);
        make.height.mas_equalTo(234);
    }];
    
    [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cycleView.mas_right);
        make.top.equalTo(self.cycleView.mas_bottom).offset(15);
    }];
    
    
    //15+20+10+10+10=65+234+60=120+234=354
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgV.mas_left);
        make.top.equalTo(self.cycleView.mas_bottom).offset(15);
        make.right.equalTo(self.priceL.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(10);
        
    }];
    
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgV.mas_left);
        make.top.equalTo(self.titleL.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-13);
        make.bottom.equalTo(self.mas_bottom).offset(15);
    }];
    
    
    
    
}

- (void)setCommentModel:(SHCatagoryListModel *)commentModel
{
    _commentModel = commentModel;
    NSArray *imgArr = commentModel.serveSupply[@"imageList"];
    self.cycleView.imageURLStringsGroup = imgArr;
    
    if (commentModel.providerStatus == 0) {
        //闲
        self.busyImgV.image = [UIImage imageNamed:@"easeTime"];
    } else if (commentModel.providerStatus == 1) {
        //忙
        self.busyImgV.image = [UIImage imageNamed:@"busy"];
    }
    
    [self.headImgV sd_setImageWithURL:commentModel.providerAvatar placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameL.text = commentModel.providerNickName;
    if (commentModel.creditScore == 0) {
        self.firstImgV.image = [UIImage imageNamed:@"collection"];
        self.secImgV.image = [UIImage imageNamed:@"collection"];
        self.thirdImgV.image = [UIImage imageNamed:@"collection"];
        self.fourImgV.image = [UIImage imageNamed:@"collection"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (commentModel.creditScore == 1) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"collection"];
        self.thirdImgV.image = [UIImage imageNamed:@"collection"];
        self.fourImgV.image = [UIImage imageNamed:@"collection"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (commentModel.creditScore == 2) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"evaXing"];
        self.thirdImgV.image = [UIImage imageNamed:@"collection"];
        self.fourImgV.image = [UIImage imageNamed:@"collection"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (commentModel.creditScore == 3) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"evaXing"];
        self.thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fourImgV.image = [UIImage imageNamed:@"collection"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (commentModel.creditScore == 4) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"evaXing"];
        self.thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fourImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (commentModel.creditScore == 5) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"evaXing"];
        self.thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fourImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fiveImgV.image = [UIImage imageNamed:@"evaXing"];
    }
    
    self.titleL.text = [NSString stringWithFormat:@"标题：%@", commentModel.serveSupply[@"title"]];
    self.contentL.text = [NSString stringWithFormat:@"描述：%@", commentModel.serveSupply[@"description"]];
    self.scoreL.text = [NSString stringWithFormat:@"%d", commentModel.creditScore];
    
    
    self.priceL.text = [NSString stringWithFormat:@"%@元\/%@", commentModel.serveSupply[@"price"], commentModel.serveSupply[@"unit"]];
    
    if (SH_AppDelegate.personInfo.userId == commentModel.providerId) {
        self.cancelButton.hidden = YES;
    }
    
    if (commentModel.isFollowed == 0) {
        [self.cancelButton setTitle:@"+关注" forState:UIControlStateNormal];
    } else if (commentModel.isFollowed == 1) {
        [self.cancelButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    
    
}


#pragma mark - lazying
- (UIImageView *)headImgV
{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc] init];
        _headImgV.image = [UIImage imageNamed:@"defaultHead"];
        _headImgV.layer.cornerRadius = 20;
        _headImgV.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImageView)];
        [_headImgV addGestureRecognizer:tap];
        _headImgV.userInteractionEnabled = YES;
        [self addSubview:_headImgV];
    }
    return _headImgV;
}

- (UIImageView *)busyImgV
{
    if (!_busyImgV) {
        _busyImgV = [[UIImageView alloc] init];
        [self addSubview:_busyImgV];
        
    }
    return _busyImgV;
}

- (UILabel *)nameL
{
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
        _nameL.font = [UIFont systemFontOfSize:14.0];
        
        [self addSubview:_nameL];
    }
    return _nameL;
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

- (UIImageView *)firstImgV
{
    
    if (!_firstImgV) {
        _firstImgV = [[UIImageView alloc] init];
        _firstImgV.image = [UIImage imageNamed:@"collection"];
        [self addSubview:_firstImgV];
    }
    return _firstImgV;
}

- (UIImageView *)secImgV
{
    if (!_secImgV) {
        _secImgV = [[UIImageView alloc] init];
        _secImgV.image = [UIImage imageNamed:@"collection"];
        [self addSubview:_secImgV];
    }
    return _secImgV;
}

- (UIImageView *)thirdImgV
{
    if (!_thirdImgV) {
        _thirdImgV = [[UIImageView alloc] init];
        _thirdImgV.image = [UIImage imageNamed:@"collection"];
        [self addSubview:_thirdImgV];
    }
    return _thirdImgV;
}

- (UIImageView *)fourImgV
{
    if (!_fourImgV) {
        _fourImgV = [[UIImageView alloc] init];
        _fourImgV.image = [UIImage imageNamed:@"collection"];
        [self addSubview:_fourImgV];
    }
    return _fourImgV;
}

- (UIImageView *)fiveImgV
{
    if (!_fiveImgV) {
        _fiveImgV = [[UIImageView alloc] init];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
        [self addSubview:_fiveImgV];
    }
    return _fiveImgV;
}

- (UILabel *)scoreL
{
    if (!_scoreL) {
        _scoreL = [[UILabel alloc] init];
        _scoreL.backgroundColor = SHColorFromHex(0xa2e2fb);
        _scoreL.textColor = navColor;
        _scoreL.layer.cornerRadius = 5;
        _scoreL.layer.masksToBounds = YES;
        _scoreL.textAlignment = NSTextAlignmentCenter;
        _scoreL.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_scoreL];
    }
    return _scoreL;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = navColor;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];;
        [_cancelButton setTitle:@"关注" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 10;
        _cancelButton.layer.masksToBounds = YES;
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}

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

- (UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)priceL
{
    if (!_priceL) {
        _priceL = [[UILabel alloc] init];
        _priceL.font = [UIFont systemFontOfSize:15];
        _priceL.textColor = SHColorFromHex(0xf5ac5d);
        _priceL.textAlignment = NSTextAlignmentRight;
        [self addSubview:_priceL];
    }
    return _priceL;
}

- (UILabel *)contentL
{
    if (!_contentL) {
        _contentL = [[UILabel alloc] init];
        _contentL.font = [UIFont systemFontOfSize:12.0];
        _contentL.textColor = SHColorFromHex(0x9a9a9a);
        _contentL.numberOfLines = 0;
        [_contentL sizeToFit];
        [self addSubview:_contentL];
    }
    return _contentL;
}

- (UILabel *)bottomL
{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc] init];
        _bottomL.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:_bottomL];
    }
    return _bottomL;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentL sizeToFit];
}

- (void)cancelButtonClick{
    if ([_delegate respondsToSelector:@selector(clickFollowButton)]) {
        [_delegate clickFollowButton];
    }
    SHWeakSelf
    NSDictionary *dic = @{
                          @"careId":@(_commentModel.providerId)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHFollowOtherUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            if ([weakSelf.cancelButton.currentTitle isEqualToString:@"+关注"]) {
                [MBProgressHUD showMBPAlertView:@"关注成功" withSecond:2.0];
                [weakSelf.cancelButton setTitle:@"取消关注" forState:UIControlStateNormal];
            } else if ([weakSelf.cancelButton.currentTitle isEqualToString:@"取消关注"]) {
                [MBProgressHUD showMBPAlertView:@"取消成功" withSecond:2.0];
                [weakSelf.cancelButton setTitle:@"+关注" forState:UIControlStateNormal];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadServiceListData" object:nil];
        }
    } failure:^(NSError *error) {
        
    }];

}

- (void)tapHeadImageView
{
    SHLog(@"点击")
    if ([_delegate respondsToSelector:@selector(clickFollowButton)]) {
        [_delegate clickFollowButton];
    }
}



@end



