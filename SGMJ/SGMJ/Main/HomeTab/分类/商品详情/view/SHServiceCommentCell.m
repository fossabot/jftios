//
//  SHServiceCommentCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHServiceCommentCell.h"
#import "SHServiceCommentModel.h"
#import "SHPersonUserModel.h"


@interface SHServiceCommentCell ()

@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UIImageView *authoriseImgV;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *scoreL;
@property (nonatomic, strong) UIImageView *firstImgV;
@property (nonatomic, strong) UIImageView *secImgV;
@property (nonatomic, strong) UIImageView *thirdImgV;
@property (nonatomic, strong) UIImageView *fourImgV;
@property (nonatomic, strong) UIImageView *fiveImgV;

@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *evaOneImgV;
@property (nonatomic, strong) UIImageView *evaTwoImgV;
@property (nonatomic, strong) UIImageView *evaThirdImgV;
@property (nonatomic, strong) UILabel *bottomL;

@end


@implementation SHServiceCommentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self stepUI];
    }
    return self;
}

- (void)stepUI
{
//    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(13);
//        make.top.equalTo(self.mas_top).offset(10);
//        make.height.and.width.mas_equalTo(40);
//
//    }];
    
    [self.authoriseImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImgV.mas_right).offset(6);
        make.bottom.mas_equalTo(self.headImgV.mas_bottom);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImgV.mas_top);
        make.left.equalTo(self.headImgV.mas_right).offset(15);
        
    }];
    
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImgV.mas_top);
        make.right.equalTo(self.mas_right).offset(-13);
        
    }];
     
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImgV.mas_bottom);
        make.left.mas_equalTo(self.nameL.mas_left);
        
    }];
    
    [self.firstImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.scoreL.mas_centerY);
        make.left.equalTo(self.scoreL.mas_right).offset(2);
        make.width.and.height.mas_equalTo(12);
    }];
     
    [self.secImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.left.equalTo(self.firstImgV.mas_right).offset(2);
        make.width.and.height.mas_equalTo(12);
    }];
    
    [self.thirdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.left.equalTo(self.secImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.fourImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.left.equalTo(self.thirdImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.fiveImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstImgV.mas_centerY);
        make.left.equalTo(self.fourImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameL.mas_left);
        make.top.equalTo(self.scoreL.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-13);
    }];
    
    [self.evaOneImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameL.mas_left);
        make.top.equalTo(self.contentL.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(80);
    }];
    
    [self.evaTwoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.evaOneImgV.mas_centerY);
        make.left.equalTo(self.evaOneImgV.mas_right).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(60);
    }];
    
    [self.evaThirdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.evaOneImgV.mas_centerY);
        make.left.equalTo(self.evaTwoImgV.mas_right).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(60);
    }];
    
    [self.bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
}

- (void)setModel:(SHServiceCommentModel *)model
{
    _model = model;
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    self.nameL.text = model.user.nickName;
    self.timeL.text = model.user.createTime;
    self.contentL.hidden = NO;
    if ([model.content isEqualToString:@""]) {
        
        //self.contentL.text = @"用户暂无评论!";
    } else {
        self.contentL.text = model.content;
    }
    SHLog(@"%@", self.contentL.text)
    if (model.images.count == 0) {
        self.evaOneImgV.hidden = YES;
        self.evaTwoImgV.hidden = YES;
        self.evaThirdImgV.hidden = YES;
    } else if (model.images.count == 1) {
        if (![model.images[0] isEqualToString:@""]) {
            self.evaOneImgV.hidden = NO;
            [self.evaOneImgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaTwoImgV.hidden = YES;
            self.evaThirdImgV.hidden = YES;
        } else {
            self.evaOneImgV.hidden = YES;
            self.evaTwoImgV.hidden = YES;
            self.evaThirdImgV.hidden = YES;
        }
    } else if (model.images.count == 2) {
        if ([model.images[0] isEqualToString:@""] && [model.images[1] isEqualToString:@""]) {
            self.evaOneImgV.hidden = YES;
            self.evaTwoImgV.hidden = YES;
            self.evaThirdImgV.hidden = YES;
        } else if (![model.images[0] isEqualToString:@""] && [model.images[1] isEqualToString:@""]) {
            self.evaOneImgV.hidden = NO;
            [self.evaOneImgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaTwoImgV.hidden = YES;
            self.evaThirdImgV.hidden = YES;
        } else if (![model.images[0] isEqualToString:@""] && ![model.images[1] isEqualToString:@""]) {
            self.evaOneImgV.hidden = NO;
            [self.evaOneImgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaTwoImgV.hidden = NO;
            [self.evaTwoImgV sd_setImageWithURL:[NSURL URLWithString:model.images[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaThirdImgV.hidden = YES;
        }
    } else if (model.images.count == 3) {
        if ([model.images[0] isEqualToString:@""] && [model.images[1] isEqualToString:@""] && [model.images[2] isEqualToString:@""]) {
            self.evaOneImgV.hidden = YES;
            self.evaTwoImgV.hidden = YES;
            self.evaThirdImgV.hidden = YES;
        } else if (![model.images[0] isEqualToString:@""] && [model.images[1] isEqualToString:@""] && [model.images[2] isEqualToString:@""]) {
            self.evaOneImgV.hidden = NO;
            [self.evaOneImgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaTwoImgV.hidden = YES;
            self.evaThirdImgV.hidden = YES;
        } else if (![model.images[0] isEqualToString:@""] && ![model.images[1] isEqualToString:@""] && [model.images[2] isEqualToString:@""]) {
            self.evaOneImgV.hidden = NO;
            [self.evaOneImgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaTwoImgV.hidden = NO;
            [self.evaTwoImgV sd_setImageWithURL:[NSURL URLWithString:model.images[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaThirdImgV.hidden = YES;
        } else if (![model.images[0] isEqualToString:@""] && ![model.images[1] isEqualToString:@""] && ![model.images[2] isEqualToString:@""]) {
            SHLog(@"%@", model.images)
            self.evaOneImgV.hidden = NO;
            [self.evaOneImgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaTwoImgV.hidden = NO;
            [self.evaTwoImgV sd_setImageWithURL:[NSURL URLWithString:model.images[1]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
            self.evaThirdImgV.hidden = NO;
            [self.evaThirdImgV sd_setImageWithURL:[NSURL URLWithString:model.images[2]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        }
    }
    
    
    if (model.average == 0) {
        self.firstImgV.image = [UIImage imageNamed:@"collection"];
        self.secImgV.image = [UIImage imageNamed:@"collection"];
        self.thirdImgV.image = [UIImage imageNamed:@"collection"];
        self.fourImgV.image = [UIImage imageNamed:@"collection"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (model.average == 1) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"collection"];
        self.thirdImgV.image = [UIImage imageNamed:@"collection"];
        self.fourImgV.image = [UIImage imageNamed:@"collection"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (model.average == 2) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"evaXing"];
        self.thirdImgV.image = [UIImage imageNamed:@"collection"];
        self.fourImgV.image = [UIImage imageNamed:@"collection"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (model.average == 3) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"evaXing"];
        self.thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fourImgV.image = [UIImage imageNamed:@"collection"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (model.average == 4) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"evaXing"];
        self.thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fourImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fiveImgV.image = [UIImage imageNamed:@"collection"];
    } else if (model.average == 5) {
        self.firstImgV.image = [UIImage imageNamed:@"evaXing"];
        self.secImgV.image = [UIImage imageNamed:@"evaXing"];
        self.thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fourImgV.image = [UIImage imageNamed:@"evaXing"];
        self.fiveImgV.image = [UIImage imageNamed:@"evaXing"];
    }
    
}


#pragma mark - lazying
- (UIImageView *)headImgV
{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 40, 40)];
        _headImgV.image = [UIImage imageNamed:@"defaultHead"];
        _headImgV.layer.cornerRadius = 20;
        _headImgV.layer.masksToBounds = YES;
        [self addSubview:_headImgV];
    }
    return _headImgV;
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
        _scoreL.textColor = SHColorFromHex(0x9a9a9a);
        _scoreL.font = [UIFont systemFontOfSize:10.0];
        _scoreL.text = @"打分：";
        [self addSubview:_scoreL];
    }
    return _scoreL;
}

- (UILabel *)timeL
{
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:10.0];
        _timeL.textColor = SHColorFromHex(0x9a9a9a);
        [self addSubview:_timeL];
    }
    return _timeL;
}

- (UILabel *)contentL
{
    if (!_contentL) {
        _contentL = [[UILabel alloc] init];
        _contentL.font = [UIFont systemFontOfSize:12.0];
        _contentL.numberOfLines = 0;
        _contentL.text = @"用户暂无评论！";
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

- (UIImageView *)evaOneImgV
{
    if (!_evaOneImgV) {
        _evaOneImgV = [[UIImageView alloc] init];
        _evaOneImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
        _evaOneImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
        [_evaOneImgV addGestureRecognizer:tap];
        [self addSubview:_evaOneImgV];
    }
    return _evaOneImgV;
}

- (UIImageView *)evaTwoImgV
{
    if (!_evaTwoImgV) {
        _evaTwoImgV = [[UIImageView alloc] init];
        _evaTwoImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
        _evaTwoImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
        [_evaTwoImgV addGestureRecognizer:tap];
        [self addSubview:_evaTwoImgV];
    }
    return _evaTwoImgV;
}

- (UIImageView *)evaThirdImgV
{
    if (!_evaThirdImgV) {
        _evaThirdImgV = [[UIImageView alloc] init];
        _evaThirdImgV.image = [UIImage imageNamed:NoImagePlaceHolder];
        _evaThirdImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
        [_evaThirdImgV addGestureRecognizer:tap];
        [self addSubview:_evaThirdImgV];
    }
    return _evaThirdImgV;
}

#pragma mark - action
- (void)tapImage
{
    SHLog(@"点击图片")
    
    
}




- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
