//
//  SHReportPriceCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/13.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHReportPriceCell.h"
#import "SHReportPriceModel.h"
#import "SHPayOrderVController.h"

@interface SHReportPriceCell ()

@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UIImageView *authImgV;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIImageView *firImgV;
@property (nonatomic, strong) UIImageView *secImgV;
@property (nonatomic, strong) UIImageView *thirdImgV;
@property (nonatomic, strong) UIImageView *forImgV;
@property (nonatomic, strong) UIImageView *fifImgV;

@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *winningImgV;

@property (nonatomic, strong) UIImageView *oneImgV;
@property (nonatomic, strong) UIImageView *twoImgV;
@property (nonatomic, strong) UIImageView *threeImgV;

@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UILabel *lineL;

@property (nonatomic, copy) NSString *orderNo;


@end

@implementation SHReportPriceCell

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
    _headImgV.layer.cornerRadius = 20;
    _headImgV.clipsToBounds = YES;
    [self.contentView addSubview:_headImgV];
    
    _authImgV = [[UIImageView alloc] init];
    _authImgV.image = [UIImage imageNamed:@"authorize"];
    [self.contentView addSubview:_authImgV];
    
    _nameL = [[UILabel alloc] init];
    _nameL.text = @"名字";
    _nameL.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_nameL];
    
    _firImgV = [[UIImageView alloc] init];
    _firImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_firImgV];
    
    _secImgV = [[UIImageView alloc] init];
    _secImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_secImgV];
    _thirdImgV = [[UIImageView alloc] init];
    _thirdImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_thirdImgV];
    _forImgV = [[UIImageView alloc] init];
    _forImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_forImgV];
    _fifImgV = [[UIImageView alloc] init];
    _fifImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_fifImgV];
    
    _timeL = [[UILabel alloc] init];
    _timeL.font = [UIFont systemFontOfSize:12.0];
    _timeL.textColor = SHColorFromHex(0x9a9a9a);
    [self.contentView addSubview:_timeL];
    
   
    
    _oneImgV = [[UIImageView alloc] init];
    _oneImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
    [self.contentView addSubview:_oneImgV];
    _twoImgV = [[UIImageView alloc] init];
    _twoImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
    [self.contentView addSubview:_twoImgV];
    _threeImgV = [[UIImageView alloc] init];
    _threeImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
    [self.contentView addSubview:_threeImgV];
    
    _contentL = [[UILabel alloc] init];
    _contentL.font = [UIFont systemFontOfSize:12.0];;
    _contentL.numberOfLines = 0;
    [_contentL sizeToFit];
    _contentL.textColor = SHColorFromHex(0x9a9a9a);
    [self.contentView addSubview:_contentL];
    
    _priceL = [[UILabel alloc] init];
    _priceL.textColor = SHColorFromHex(0xd43c33);
    _priceL.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_priceL];
    
    _orderButton = [[UIButton alloc] init];
    [_orderButton setTitle:@"立即下单" forState:UIControlStateNormal];
    [_orderButton setTitleColor:navColor forState:UIControlStateNormal];
    [_orderButton setBackgroundColor:SHColorFromHex(0xa2e2fb)];
    [_orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _orderButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _orderButton.layer.cornerRadius = 5;
    _orderButton.clipsToBounds = YES;
    [self.contentView addSubview:_orderButton];
    
    _lineL = [[UILabel alloc] init];
    _lineL.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_lineL];
    
    
    _winningImgV = [[UIImageView alloc] init];
    _winningImgV.image = [UIImage imageNamed:@"winning"];
    [self.contentView addSubview:_winningImgV];
    
    
    //40
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.height.mas_equalTo(40);
        make.width.mas_offset(40);
    }];
    
    //
    [_authImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImgV.mas_bottom);
        make.right.equalTo(_headImgV.mas_right).offset(6);
        make.width.and.height.mas_equalTo(12);
    }];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_headImgV.mas_centerY);
        make.left.equalTo(_headImgV.mas_right).offset(10);
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_headImgV.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        
    }];
    
    
    [_fifImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_headImgV.mas_centerY);
        make.right.equalTo(_timeL.mas_left).offset(-10);
        make.width.and.height.mas_equalTo(12);
        
    }];
    [_forImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_fifImgV.mas_centerY);
        make.right.equalTo(_fifImgV.mas_left).offset(-3);
        make.width.and.height.mas_equalTo(12);
        
    }];
    [_thirdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_forImgV.mas_centerY);
        make.right.equalTo(_forImgV.mas_left).offset(-3);
        make.width.and.height.mas_equalTo(12);
        
    }];
    [_secImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_thirdImgV.mas_centerY);
        make.right.equalTo(_thirdImgV.mas_left).offset(-3);
        make.width.and.height.mas_equalTo(12);
        
    }];
    [_firImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_secImgV.mas_centerY);
        make.right.equalTo(_secImgV.mas_left).offset(-3);
        make.width.and.height.mas_equalTo(12);
    }];
    
    [_oneImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameL.mas_left);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(80);
    }];
    [_twoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_oneImgV.mas_top);
        make.left.equalTo(_oneImgV.mas_right).offset(13);
        make.width.mas_equalTo(_oneImgV);
        make.height.mas_equalTo(_oneImgV);
    }];
    [_threeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_oneImgV.mas_top);
        make.left.equalTo(_twoImgV.mas_right).offset(13);
        make.width.mas_equalTo(_oneImgV);
        make.height.mas_equalTo(_oneImgV);
    }];
    
    [_winningImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.and.width.mas_equalTo(60);
    }];
    
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneImgV.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameL.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        
    }];
    
    [_priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameL.mas_left);
        make.top.equalTo(_contentL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    
    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_priceL.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(78);
    }];
    
    
    [_lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self bringSubviewToFront:_winningImgV];
}

- (void)setModel:(SHReportPriceModel *)model
{
    [self layoutIfNeeded];
    
    _headImgV.layer.cornerRadius = _headImgV.height / 2;
    _headImgV.clipsToBounds = YES;
    _model = model;
    
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameL.text = model.nickName;
    _timeL.text = model.createTime;
    
    
    if (model.images[0]) {
        [_oneImgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    }
    if (model.images[1]) {
        [_twoImgV sd_setImageWithURL:[NSURL URLWithString:model.images[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    }
    if (model.images[2]) {
        [_threeImgV sd_setImageWithURL:[NSURL URLWithString:model.images[2]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    }
    
    
    
    _contentL.text = model.content;
    
    if (model.status == 0) {
        //未中标
        _winningImgV.hidden = YES;
        _orderButton.hidden = NO;
    } else {
        _winningImgV.hidden = NO;
        _orderButton.hidden = YES;
    }
    
    if (model.creditRating == 0) {
        
    } else if (model.creditRating == 1) {
        _firImgV.image = [UIImage imageNamed:@"evaXing"];
    } else if (model.creditRating == 2) {
        _firImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
    } else if (model.creditRating == 3) {
        _firImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
    } else if (model.creditRating == 4) {
        _firImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _forImgV.image = [UIImage imageNamed:@"evaXing"];
    } else if (model.creditRating == 5) {
        _firImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _forImgV.image = [UIImage imageNamed:@"evaXing"];
        _fifImgV.image = [UIImage imageNamed:@"evaXing"];

    }
    
    if (_isMyself == 0) {
        //自己查看
        _priceL.text = [NSString stringWithFormat:@"报价：%.2f元", model.price];

    } else {
        _priceL.text = @"报价：保密";
    }
    
}


- (void)orderButtonClick
{
    SHLog(@"立即下单")
    SHWeakSelf
    NSDictionary *dic = @{
                          @"needOfferId":@(_model.ID)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHNeedCreateOrderUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 500) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        } else if (code == 0) {
            NSDictionary *dic = JSON[@"order"];
            _orderNo = dic[@"orderNo"];
            [weakSelf dealWithOrderNo:dic[@"orderNo"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)dealWithOrderNo:(NSString *)string
{
    SHPayOrderVController *vc = [[SHPayOrderVController alloc] init];
    vc.orderNo = string;
    [[self viewController].navigationController pushViewController:vc animated:YES];
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
