//
//  SHMyEvaluateTViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMyEvaluateTViewCell.h"
#import "SHMyEvaluateModel.h"


@interface SHMyEvaluateTViewCell ()

@property (nonatomic, strong) UIView *goodBgView;           //good背景view
@property (nonatomic, strong) UIImageView *goodImgV;        //good头像
@property (nonatomic, strong) UILabel *goodContentL;        //good描述
@property (nonatomic, strong) UILabel *priceL;              //价格


@property (nonatomic, strong) UIImageView *headImgV;        //头像
@property (nonatomic, strong) UIImageView *authoriseImgV;   //认证图片
@property (nonatomic, strong) UILabel *nameL;               //名字
@property (nonatomic, strong) UILabel *scoreL;              //打分
@property (nonatomic, strong) UIImageView *firstImgV;       //第一个星星
@property (nonatomic, strong) UIImageView *secImgV;         //第二个星星
@property (nonatomic, strong) UIImageView *thirdImgV;       //第三个星星
@property (nonatomic, strong) UIImageView *fourImgV;        //第四个星星
@property (nonatomic, strong) UIImageView *fiveImgV;        //第五个星星
@property (nonatomic, strong) UILabel *timeL;               //时间
@property (nonatomic, strong) UILabel *contentL;            //内容
@property (nonatomic, strong) UILabel *feedBackL;           //回复
@property (nonatomic, strong) UIImageView *feedImgV;        //回复的图片


@property (nonatomic, strong) UILabel *bottomL;             //底部label

@property (nonatomic, strong) UIImageView *evaOneImgV;      //评论第一张图片
@property (nonatomic, strong) UIImageView *evaTwoImgV;      //第二张
@property (nonatomic, strong) UIImageView *evaThrImgV;      //第三张


@end

@implementation SHMyEvaluateTViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self stepUI];
    }
    return self;
}

- (void)stepUI
{
    //上部分view
    _goodBgView = [[UIView alloc] init];
    _goodBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_goodBgView];
    
    _goodImgV = [[UIImageView alloc] init];
    _goodImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
    [_goodBgView addSubview:_goodImgV];
    
    _goodContentL = [[UILabel alloc] init];
    _goodContentL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _goodContentL.textColor = SHColorFromHex(0x66666);
    [_goodBgView addSubview:_goodContentL];
    
    _priceL = [[UILabel alloc] init];
    _priceL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _priceL.textColor = SHColorFromHex(0xc4483c);
    [_goodBgView addSubview:_priceL];
    
    
    _headImgV = [[UIImageView alloc] init];
    _headImgV.layer.cornerRadius = 20;
    _headImgV.layer.masksToBounds = YES;
    _headImgV.image = [UIImage imageNamed:@"defaultHead"];
    [self addSubview:_headImgV];
    
    _authoriseImgV = [[UIImageView alloc] init];
    _authoriseImgV.image = [UIImage imageNamed:@"authorize"];
    [self addSubview:_authoriseImgV];
    
    _nameL = [[UILabel alloc] init];
    _nameL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [self addSubview:_nameL];
    
    _timeL = [[UILabel alloc] init];
    _timeL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    _timeL.textColor = SHColorFromHex(0x9a9a9a);
    [self addSubview:_timeL];
    
    _scoreL = [[UILabel alloc] init];
    _scoreL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    _scoreL.text = @"打分:";
    _scoreL.textColor = SHColorFromHex(0x9a9a9a);
    [self addSubview:_scoreL];
    
    _firstImgV = [[UIImageView alloc] init];
    _firstImgV.image = [UIImage imageNamed:@"collection"];
    [self addSubview:_firstImgV];
    _secImgV = [[UIImageView alloc] init];
    _secImgV.image = [UIImage imageNamed:@"collection"];
    [self addSubview:_secImgV];
    _thirdImgV = [[UIImageView alloc] init];
    _thirdImgV.image = [UIImage imageNamed:@"collection"];
    [self addSubview:_thirdImgV];
    _fourImgV = [[UIImageView alloc] init];
    _fourImgV.image = [UIImage imageNamed:@"collection"];
    [self addSubview:_fourImgV];
    _fiveImgV = [[UIImageView alloc] init];
    _fiveImgV.image = [UIImage imageNamed:@"collection"];
    [self addSubview:_fiveImgV];
    
    _contentL = [[UILabel alloc] init];
    _contentL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _contentL.numberOfLines = 0;
    [_contentL sizeToFit];
    [self addSubview:_contentL];
    
    _evaOneImgV = [[UIImageView alloc] init];
    [self addSubview:_evaOneImgV];
    
    _evaTwoImgV = [[UIImageView alloc] init];
    [self addSubview:_evaTwoImgV];
    
    _evaThrImgV = [[UIImageView alloc] init];
    [self addSubview:_evaThrImgV];
    
    _feedBackL = [[UILabel alloc] init];
    _feedBackL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    _feedBackL.textColor = SHColorFromHex(0x9a9a9a);
    _feedBackL.text = @"回复";
    [self addSubview:_feedBackL];
    
    _feedImgV = [[UIImageView alloc] init];
    _feedImgV.image = [UIImage imageNamed:@"information"];
    [self addSubview:_feedImgV];
  
    _bottomL = [[UILabel alloc] init];
    _bottomL.backgroundColor = SHColorFromHex(0xf2f2f2);
    [self addSubview:_bottomL];
    
    //masonary
    [_goodBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.left.mas_equalTo(self.contentView);
        make.height.mas_equalTo(70);
    }];
    //10
    [_goodImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodBgView.mas_top).offset(10);
        make.left.equalTo(_goodBgView.mas_left).offset(13);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    //content高度
    [_goodContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_goodImgV.mas_top);
        make.left.equalTo(_goodImgV.mas_right).offset(15);
        make.right.equalTo(_goodBgView.mas_right).offset(-13);
        
    }];
    
    //
    [_priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_goodContentL.mas_left);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(_goodImgV.mas_bottom);
    }];
    
    //服务的高度=10+content高度+35
    
    //评论头像
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(90);
        make.left.mas_equalTo(_goodImgV.mas_left);
        make.height.and.width.mas_equalTo(40);
        
    }];
    
    //认证
    [_authoriseImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImgV.mas_bottom);
        make.right.equalTo(_headImgV.mas_right).offset(6);
        make.height.and.width.mas_equalTo(12);
    }];
    
    //名字20+20
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImgV.mas_top);
        make.left.equalTo(_headImgV.mas_right).offset(15);
        make.right.equalTo(self.mas_right).offset(-13);
        make.height.mas_equalTo(20);
        
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameL.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-13);
        make.height.mas_equalTo(15);
    }];
    
    [_feedBackL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_timeL.mas_right);
        make.top.equalTo(_timeL.mas_bottom).offset(10);
        
    }];
    
    [_feedImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_feedBackL.mas_centerY);
        make.right.equalTo(_feedBackL.mas_left).offset(-5);
    }];
    
    
    //打分5+12+10
    [_scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameL.mas_left);
        make.top.equalTo(_nameL.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    
    //星星
    [_firstImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_scoreL.mas_centerY);
        make.left.equalTo(_scoreL.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    [_secImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_scoreL.mas_centerY);
        make.left.equalTo(_firstImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    [_thirdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_scoreL.mas_centerY);
        make.left.equalTo(_secImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    [_fourImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_scoreL.mas_centerY);
        make.left.equalTo(_thirdImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    [_fiveImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_scoreL.mas_centerY);
        make.left.equalTo(_fourImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    
    //content高度
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameL.mas_left);
        make.right.equalTo(self.mas_right).offset(-13);
        make.top.equalTo(_scoreL.mas_bottom).offset(10);
    }];
    
    
    [_evaOneImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentL.mas_bottom).offset(10);
        make.left.mas_equalTo(_contentL.mas_left);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    
    [_evaTwoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_evaOneImgV.mas_centerY);
        make.left.equalTo(_evaOneImgV.mas_right).offset(10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    
    [_evaThrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_evaOneImgV.mas_centerY);
        make.left.equalTo(_evaTwoImgV.mas_right).offset(10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    
    //10
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_evaOneImgV.mas_bottom).offset(10);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(self);
    }];
    
    
    //77+content高度
    //cell的高度：77+content高度+10+content高度+35=122+content高度+10+content高度+70=202
    
    
    //底部10
    
    
    
    
}

- (void)setEvaluateModel:(SHMyEvaluateModel *)evaluateModel
{
    _evaluateModel = evaluateModel;
    
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.productImg] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    _goodContentL.text = evaluateModel.productTitle;
    _priceL.text = [NSString stringWithFormat:@"%.2f元/%@", evaluateModel.productPrice,evaluateModel.productUnit];

    [_headImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.assessUserAvatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameL.text = evaluateModel.assessUserNickName;
    
    _contentL.text = evaluateModel.content;
    _timeL.text = evaluateModel.createTime;
    
    
    if (evaluateModel.score == 0) {
        _firstImgV.image = [UIImage imageNamed:@"collection"];
        _secImgV.image = [UIImage imageNamed:@"collection"];
        _thirdImgV.image = [UIImage imageNamed:@"collection"];
        _fourImgV.image = [UIImage imageNamed:@"collection"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (evaluateModel.score == 1) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"collection"];
        _thirdImgV.image = [UIImage imageNamed:@"collection"];
        _fourImgV.image = [UIImage imageNamed:@"collection"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (evaluateModel.score == 2) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"collection"];
        _fourImgV.image = [UIImage imageNamed:@"collection"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (evaluateModel.score == 3) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _fourImgV.image = [UIImage imageNamed:@"collection"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (evaluateModel.score == 4) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _fourImgV.image = [UIImage imageNamed:@"evaXing"];
        _fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (evaluateModel.score == 5) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _fourImgV.image = [UIImage imageNamed:@"evaXing"];
        _fiveImgV.image = [UIImage imageNamed:@"evaXing"];
    }

    [self dealWithImageWith:evaluateModel];
    
}

- (void)dealWithImageWith:(SHMyEvaluateModel *)evaluateModel
{
    if (evaluateModel.images.count > 0) {
        if (evaluateModel.images.count == 1) {
            if ([evaluateModel.images[0] isEqualToString:@""]) {
                _evaOneImgV.hidden = YES;
                _evaTwoImgV.hidden = YES;
                _evaThrImgV.hidden = YES;
            } else {
                [_evaOneImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaOneImgV.hidden = NO;
                _evaTwoImgV.hidden = YES;
                _evaThrImgV.hidden = YES;
            }
        }
        if (evaluateModel.images.count == 2) {
            if ([evaluateModel.images[0] isEqualToString:@""]) {
                _evaOneImgV.hidden = YES;
                _evaTwoImgV.hidden = YES;
                _evaThrImgV.hidden = YES;
            } else if (![evaluateModel.images[0] isEqualToString:@""] && [evaluateModel.images[1] isEqualToString:@""]) {
                [_evaOneImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaOneImgV.hidden = NO;
                _evaTwoImgV.hidden = YES;
                
                _evaThrImgV.hidden = YES;
            } else if (![evaluateModel.images[0] isEqualToString:@""] && ![evaluateModel.images[1] isEqualToString:@""]) {
                [_evaOneImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaOneImgV.hidden = NO;
                _evaTwoImgV.hidden = NO;
                [_evaTwoImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaThrImgV.hidden = YES;
            }
        }
        if (evaluateModel.images.count == 3) {
            if ([evaluateModel.images[0] isEqualToString:@""]) {
                _evaOneImgV.hidden = YES;
                _evaTwoImgV.hidden = YES;
                _evaThrImgV.hidden = YES;
            } else if (![evaluateModel.images[0] isEqualToString:@""] && [evaluateModel.images[1] isEqualToString:@""]) {
                [_evaOneImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaOneImgV.hidden = NO;
                _evaTwoImgV.hidden = YES;
                
                _evaThrImgV.hidden = YES;
            } else if (![evaluateModel.images[0] isEqualToString:@""] && ![evaluateModel.images[1] isEqualToString:@""] && [evaluateModel.images[2] isEqualToString:@""]) {
                [_evaOneImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaOneImgV.hidden = NO;
                _evaTwoImgV.hidden = NO;
                [_evaTwoImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaThrImgV.hidden = YES;
            } else if (![evaluateModel.images[0] isEqualToString:@""] && ![evaluateModel.images[1] isEqualToString:@""] && ![evaluateModel.images[2] isEqualToString:@""]) {
                [_evaOneImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaOneImgV.hidden = NO;
                _evaTwoImgV.hidden = NO;
                [_evaTwoImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                [_evaThrImgV sd_setImageWithURL:[NSURL URLWithString:evaluateModel.images[2]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
                _evaThrImgV.hidden = NO;
            }
        }
        
    } else {
        _evaOneImgV.hidden = YES;
        _evaTwoImgV.hidden = YES;
        _evaThrImgV.hidden = YES;
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [_contentL sizeToFit];
}














- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
