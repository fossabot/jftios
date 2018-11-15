//
//  SHCatagoryViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/13.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHCatagoryViewCell.h"
#import "SHCatagoryListModel.h"
#import "SDPhotoBrowser.h"
#import "SHOrderViewController.h"
#import "SHPersonalViewController.h"
#import "SHChatViewController.h"
#import "SH_TestViewController.h"

@interface SHCatagoryViewCell() <SDPhotoBrowserDelegate>

@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UIImageView *busyImgV;
@property (nonatomic, strong) UIImageView *authImgV;
@property (nonatomic, strong) UILabel *nameL;

@property (nonatomic, strong) UIImageView *firstImgV;
@property (nonatomic, strong) UIImageView *secImgV;
@property (nonatomic, strong) UIImageView *thirdImgV;
@property (nonatomic, strong) UIImageView *fourImgV;
@property (nonatomic, strong) UIImageView *fiveImgV;
@property (nonatomic, strong) UILabel *creditL;

@property (nonatomic, strong) UIButton *distanceButton;
@property (nonatomic, strong) UIButton *phoneButton;
@property (nonatomic, strong) UIButton *followButton;


@property (nonatomic, strong) UIImageView *oneImgV;
@property (nonatomic, strong) UIImageView *twoImgV;
@property (nonatomic, strong) UIImageView *threeImgV;
@property (nonatomic, strong) UILabel *timeL;

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *priceL;


@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *orderButton;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UIButton *testButton;

@end


@implementation SHCatagoryViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self stepUI];
    }
    return self;
}

- (void)stepUI
{
    
    _headImgV = [[UIImageView alloc] init];
    _headImgV.image = [UIImage imageNamed:@"defaultHead"];
    _headImgV.layer.cornerRadius = 25;
    _headImgV.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImageView)];
    [_headImgV addGestureRecognizer:tap];
    _headImgV.userInteractionEnabled = YES;
    [self.contentView addSubview:_headImgV];
    
    
    _busyImgV = [[UIImageView alloc] init];
    _busyImgV.image = [UIImage imageNamed:@"easeTime"];
    [self.contentView addSubview:_busyImgV];
    
    _authImgV = [[UIImageView alloc] init];
    _authImgV.image = [UIImage imageNamed:@"authorize"];
    [self.contentView addSubview:_authImgV];
    
    _nameL = [[UILabel alloc] init];
    _nameL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.contentView addSubview:_nameL];
    
    _firstImgV = [[UIImageView alloc] init];
    _firstImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_firstImgV];
    _secImgV = [[UIImageView alloc] init];
    _secImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_secImgV];
    _thirdImgV = [[UIImageView alloc] init];
    _thirdImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_thirdImgV];
    _fourImgV = [[UIImageView alloc] init];
    _fourImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_fourImgV];
    _fiveImgV = [[UIImageView alloc] init];
    _fiveImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_fiveImgV];
    
    _oneImgV = [[UIImageView alloc] init];
    _oneImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
    
    [self.contentView addSubview:_oneImgV];
    _twoImgV = [[UIImageView alloc] init];
    _twoImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
    [self.contentView addSubview:_twoImgV];
    _threeImgV = [[UIImageView alloc] init];
    _threeImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
    [self.contentView addSubview:_threeImgV];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClick:)];
    [_oneImgV addGestureRecognizer:backTap];
    UITapGestureRecognizer *backTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClick:)];
    [_twoImgV addGestureRecognizer:backTap2];
    UITapGestureRecognizer *backTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClick:)];
    [_threeImgV addGestureRecognizer:backTap3];
    _oneImgV.tag = 0;
    _oneImgV.userInteractionEnabled = YES;
//    [_twoImgV addGestureRecognizer:backTap];
    _twoImgV.userInteractionEnabled = YES;
    _twoImgV.tag = 1;
//    [_threeImgV addGestureRecognizer:backTap];
    _threeImgV.userInteractionEnabled = YES;
    _threeImgV.tag = 2;
    
    _creditL = [[UILabel alloc] init];
    _creditL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _creditL.backgroundColor = SHColorFromHex(0xa2e2fb);
    _creditL.textColor = navColor;
    _creditL.layer.cornerRadius = 5;
    _creditL.clipsToBounds = YES;
    _creditL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_creditL];
    
    _titleL = [[UILabel alloc] init];
    _titleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.contentView addSubview:_titleL];
    
    _contentL = [[UILabel alloc] init];
    _contentL.font = [UIFont systemFontOfSize:13.0];
    _contentL.textColor  =SHColorFromHex(0x9a9a9a);
    _contentL.numberOfLines = 0;
    [_contentL sizeToFit];
    [self.contentView addSubview:_contentL];
    
    _timeL = [[UILabel alloc] init];
    _timeL.textColor = SHColorFromHex(0xeca962);
    _timeL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.contentView addSubview:_timeL];
    
    _priceL = [[UILabel alloc] init];
    _priceL.textColor = SHColorFromHex(0xd43c33);
    _priceL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.contentView addSubview:_priceL];
    
    _distanceButton = [[UIButton alloc] init];
    [_distanceButton setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_distanceButton addTarget:self action:@selector(distanceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _distanceButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.contentView addSubview:_distanceButton];
    
    _phoneButton = [[UIButton alloc] init];
    [_phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_phoneButton setImage:[UIImage imageNamed:@"iphone"] forState:UIControlStateNormal];
    [self.contentView addSubview:_phoneButton];
    //notcollect   heard
    _followButton = [[UIButton alloc] init];
    [_followButton addTarget:self action:@selector(followButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_followButton setImage:[UIImage imageNamed:@"notcollect"] forState:UIControlStateNormal];
    [self.contentView addSubview:_followButton];
    
    _chatButton = [[UIButton alloc] init];
    [_chatButton setTitle:@"私聊" forState:UIControlStateNormal];
    [_chatButton addTarget:self action:@selector(chatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _chatButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [_chatButton setTitleColor:SHColorFromHex(0xfa9f47) forState:UIControlStateNormal];
    [_chatButton setBackgroundColor:SHColorFromHex(0xfbe7ca)];
    _chatButton.layer.cornerRadius = 6;
    _chatButton.clipsToBounds = YES;
    [self.contentView addSubview:_chatButton];
    
    _orderButton = [[UIButton alloc] init];
    [_orderButton setTitle:@"立即下单" forState:UIControlStateNormal];
    [_orderButton addTarget:self action:@selector(makeOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _orderButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [_orderButton setTitleColor:SHColorFromHex(0x12b1f5) forState:UIControlStateNormal];
    [_orderButton setBackgroundColor:SHColorFromHex(0xa2e2fb)];
    _orderButton.layer.cornerRadius = 6;
    _orderButton.clipsToBounds = YES;
    [self.contentView addSubview:_orderButton];
    
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_lineLabel];
    
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    [_busyImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImgV.mas_right).offset(-6);
        make.top.mas_equalTo(_headImgV.mas_top);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_authImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImgV.mas_bottom);
        make.left.equalTo(_headImgV.mas_right).offset(-6);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top).offset(3);
        make.left.equalTo(_busyImgV.mas_right).offset(5);
        
    }];
    
    [_firstImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImgV.mas_bottom).offset(-3);
        make.left.mas_equalTo(_nameL.mas_left);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_secImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_firstImgV.mas_centerY);
        make.left.equalTo(_firstImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_thirdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_firstImgV.mas_centerY);
        make.left.equalTo(_secImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_fourImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_firstImgV.mas_centerY);
        make.left.equalTo(_thirdImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_fiveImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_firstImgV.mas_centerY);
        make.left.equalTo(_fourImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_creditL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_firstImgV.mas_centerY);
        make.left.equalTo(_fiveImgV.mas_right).offset(5);
        make.width.mas_equalTo(30);
    }];
    
    [_distanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.centerY.mas_equalTo(_headImgV.mas_centerY);
        
    }];
    
    [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_distanceButton.mas_centerY);
        make.right.equalTo(_distanceButton.mas_left).offset(-30);
        make.height.and.width.mas_equalTo(22);
    }];
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_phoneButton.mas_centerY);
        make.right.equalTo(_phoneButton.mas_left).offset(-20);
        make.height.and.width.mas_equalTo(22);
    }];
    
    [_oneImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgV.mas_left);
        make.top.equalTo(_headImgV.mas_bottom).offset(10);
//        make.height.mas_equalTo(70);
        make.width.mas_equalTo((SHScreenW - 52) / 3);
        make.height.mas_equalTo(_oneImgV.mas_width).multipliedBy(0.8);// 高/宽 == 0.6
    }];
    
    [_twoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_oneImgV.mas_centerY);
        make.left.equalTo(_oneImgV.mas_right).offset(10);
//        make.height.mas_equalTo(70);
        make.width.mas_equalTo((SHScreenW - 52) / 3);
        make.height.mas_equalTo(_oneImgV.mas_width).multipliedBy(0.8);// 高/宽 == 0.6
    }];
    
    [_threeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_oneImgV.mas_centerY);
        make.left.equalTo(_twoImgV.mas_right).offset(10);
//        make.height.mas_equalTo(70);
        make.width.mas_equalTo((SHScreenW - 52) / 3);
        make.height.mas_equalTo(_oneImgV.mas_width).multipliedBy(0.8);// 高/宽 == 0.6
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgV.mas_left);
        make.top.equalTo(_oneImgV.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgV.mas_left);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentL.mas_bottom).offset(10);
        make.left.mas_equalTo(_headImgV.mas_left);
        make.height.mas_equalTo(20);
    }];
    
    [_priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgV.mas_left);
        make.top.equalTo(_timeL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        //make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_priceL.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    [_chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_priceL.mas_centerY);
        make.right.equalTo(_orderButton.mas_left).offset(-20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.equalTo(_priceL.mas_bottom).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

- (void)setListModel:(SHCatagoryListModel *)listModel
{
    
    _listModel = listModel;
    if (SH_AppDelegate.personInfo.userId == listModel.providerId) {
        _followButton.hidden = YES;
        _phoneButton.hidden = YES;
        _distanceButton.hidden = YES;
        _chatButton.hidden = YES;
        _orderButton.hidden = YES;
        
    }else{
        _followButton.hidden = NO;
        _phoneButton.hidden = NO;
        _distanceButton.hidden = NO;
        _chatButton.hidden = NO;
        _orderButton.hidden = NO;
    }
    
    if (listModel.providerStatus == 0) {
        //闲
        _busyImgV.image = [UIImage imageNamed:@"easeTime"];
    } else if (listModel.providerStatus == 1) {
        //忙
        _busyImgV.image = [UIImage imageNamed:@"busy"];
    }
    
    
    [_headImgV sd_setImageWithURL:listModel.providerAvatar placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    
//    [_headImgV.imageView sd_setImageWithURL:[NSURL URLWithString:listModel.providerAvatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameL.text = listModel.providerNickName;
    _creditL.text = [NSString stringWithFormat:@"%d", listModel.creditScore];
    if (listModel.creditScore == 0) {
        
    } else if (listModel.creditScore == 1) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"collection"];
        _thirdImgV.image = [UIImage imageNamed:@"collection"];
        _fourImgV.image = [UIImage imageNamed:@"collection"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (listModel.creditScore == 2) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"collection"];
        _fourImgV.image = [UIImage imageNamed:@"collection"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (listModel.creditScore == 3) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _fourImgV.image = [UIImage imageNamed:@"collection"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (listModel.creditScore == 4) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _fourImgV.image = [UIImage imageNamed:@"evaXing"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (listModel.creditScore == 5) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _fourImgV.image = [UIImage imageNamed:@"evaXing"];
        _fiveImgV.image = [UIImage imageNamed:@"evaXing"];
    }
    
    if (listModel.isFollowed == 0) {
        [_followButton setImage:[UIImage imageNamed:@"notcollect"] forState:UIControlStateNormal];
    } else if (listModel.isFollowed == 1) {
        [_followButton setImage:[UIImage imageNamed:@"heard"] forState:UIControlStateNormal];
    }
    
    _titleL.text = [NSString stringWithFormat:@"标题：%@", listModel.serveSupply[@"title"]];
    _contentL.text = [NSString stringWithFormat:@"描述：%@", listModel.serveSupply[@"description"]];
    SHLog(@"%@", listModel.serveSupply[@"startTime"])
    SHLog(@"%@", listModel.serveSupply[@"endTime"])
    
    if ([listModel.serveSupply[@"isAuto"] integerValue] == 0) {
        //0开启免打扰--
        NSArray *startArray = [listModel.serveSupply[@"startTime"] componentsSeparatedByString:@" "];
        NSArray *endArray = [listModel.serveSupply[@"endTime"] componentsSeparatedByString:@" "];
        _timeL.text = [NSString stringWithFormat:@"开始:%@--结束:%@", startArray[1], endArray[1]];
        
    } else if ([listModel.serveSupply[@"isAuto"] integerValue]== 1) {
        _timeL.text = @"开始:00:00--结束:24:00";
    }
    
    
    _priceL.text = [NSString stringWithFormat:@"%@元/%@", listModel.serveSupply[@"price"], listModel.serveSupply[@"unit"]];
    
    NSArray *imgArr = listModel.serveSupply[@"imageList"];
    if (imgArr.count == 1) {
        [_oneImgV sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        _twoImgV.hidden = YES;
        _threeImgV.hidden = YES;
    } else if (imgArr.count == 2) {
        [_oneImgV sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        [_twoImgV sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        _threeImgV.hidden = YES;
    } else if (imgArr.count == 3) {
        [_oneImgV sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        [_twoImgV sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        [_threeImgV sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    }
    
    
    [_distanceButton setTitle:[NSString stringWithFormat:@"%.2fkm", listModel.distance] forState:UIControlStateNormal];

    
}

//头像
- (void)clickHeadImageView
{
    SHLog(@"点击头像")
    SHPersonalViewController *Vc = [[SHPersonalViewController alloc] init];
    //Vc.model = _listModel;
    Vc.providerId = _listModel.providerId;
    [[self viewController].navigationController pushViewController:Vc animated:YES];
}

//关注
- (void)followButtonClick
{
    NSDictionary *dic = @{
                          @"careId":@(_listModel.providerId)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHFollowOtherUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
            if ([msg isEqualToString:@"关注成功！"]) {
                SHLog(@"qwerqwerqw")
                [_followButton setImage:[UIImage imageNamed:@"heard"] forState:UIControlStateNormal];
            } else if ([msg isEqualToString:@"取消关注成功!"]) {
                SHLog(@"取消关注成功给你")
                [_followButton setImage:[UIImage imageNamed:@"notcollect"] forState:UIControlStateNormal];
            }
            if ([_delegate respondsToSelector:@selector(followAndCancel)]) {
                [_delegate followAndCancel];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//电话
- (void)phoneButtonClick
{
    [self callPhoneStr:_listModel.providerPhone];
}

//距离
- (void)distanceButtonClick
{
    SHLog(@"点击距离")
    SHWeakSelf
    
    if ([SH_AppDelegate isPersonLogin]) {
        if ([AppDelegate isLocationServiceOpen]) {
            SH_TestViewController *Vc = [[SH_TestViewController alloc] init];
            Vc.lat = [_listModel.serveSupply[@"lat"] doubleValue];
            Vc.lon = [_listModel.serveSupply[@"lon"] doubleValue];
            Vc.serverId = [_listModel.serveSupply[@"id"] integerValue];
            [[self viewController].navigationController pushViewController:Vc animated:YES];
            
        } else {
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"开启接单需要您开启定位方便用户查看与您的位置距离" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[weakSelf viewController].navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            UIAlertAction *act2=[UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
//                if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
//                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                        [[UIApplication sharedApplication] openURL:url];
//                    }
//                } else {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
//                }
            }];
            [controller addAction:act1];
            [controller addAction:act2];
            [[self viewController].navigationController presentViewController:controller animated:YES completion:^{
                
            }];
        }
        
    } else {
        [SH_AppDelegate userLogin];
    }
}

//聊天
- (void)chatButtonClick
{
    SHLog(@"点击聊天")
    if ([SH_AppDelegate isPersonLogin]) {
        SHChatViewController *viewController = [[SHChatViewController alloc] initWithConversationChatter:_listModel.providerPhone conversationType:EMConversationTypeChat];
        viewController.title = _listModel.providerNickName;
        viewController.phone = _listModel.providerPhone;
        [[self viewController].navigationController pushViewController:viewController animated:YES];
    } else {
        [SH_AppDelegate userLogin];
    }
    
    
}

//立即下单
- (void)makeOrderButtonClick
{
    
    SHOrderViewController *vc = [[SHOrderViewController alloc] init];
    vc.listModel = _listModel;
    [[self viewController].navigationController pushViewController:vc animated:YES];
    
}

//图片点击
- (void)pictureClick:(UITapGestureRecognizer *)tap
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    //设置容器视图，父视图
//    browser.sourceImagesContainerView = _pictureBGView;
    browser.currentImageIndex = tap.view.tag;
    NSArray *imgArr = _listModel.serveSupply[@"imageList"];
    browser.imageCount = imgArr.count;
    browser.delegate = self;
    [browser show];
}

-(void)callPhoneStr:(NSString*)phoneStr  {
    NSString *str2 = [[UIDevice currentDevice] systemVersion];
    
    if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
    {
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    if (@available(iOS 10.0, *)) {
                        [app openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil                                                                                ];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [[self viewController].navigationController presentViewController:alert animated:YES completion:nil];
        
    }else {
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"是否拨打电话" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    if (@available(iOS 10.0, *)) {
                        [app openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil                                                                                ];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [[self viewController].navigationController presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark -- 遍历视图，找到UIViewController
- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    UIViewController *vc = nil;
    return vc;
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index

{
    NSArray *imgArr = _listModel.serveSupply[@"imageList"];
    //拿到显示的图片的高清图片地址
    NSURL *url = [NSURL URLWithString:imgArr[index]];
    
    return url;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [_contentL sizeToFit];
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
