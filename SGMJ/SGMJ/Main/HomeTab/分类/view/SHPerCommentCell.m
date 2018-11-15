//
//  SHPerCommentCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPerCommentCell.h"
#import "SHPerCommentModel.h"



@interface SHPerCommentCell ()

@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UIImageView *authImgV;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *scoreL;
@property (nonatomic, strong) UIImageView *firstImgV;
@property (nonatomic, strong) UIImageView *secImgV;
@property (nonatomic, strong) UIImageView *thirdImgV;
@property (nonatomic, strong) UIImageView *fourImgV;
@property (nonatomic, strong) UIImageView *fifImgV;
@property (nonatomic, strong) UILabel *contentL;

@property (nonatomic, strong) UILabel *lineL;

@end

@implementation SHPerCommentCell

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
    _nameL.text = @"姓名";
    _nameL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.contentView addSubview:_nameL];
    
    _timeL = [[UILabel alloc] init];
    _timeL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    [self.contentView addSubview:_timeL];
    
    _scoreL = [[UILabel alloc] init];
    _scoreL.text = @"打分：";
    _scoreL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    [self.contentView addSubview:_scoreL];
    
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
    _fifImgV = [[UIImageView alloc] init];
    _fifImgV.image = [UIImage imageNamed:@"collection"];
    [self.contentView addSubview:_fifImgV];
    
    _contentL = [[UILabel alloc] init];
    _contentL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_contentL sizeToFit];
    _contentL.numberOfLines = 0;
    [self.contentView addSubview:_contentL];
    
    _lineL = [[UILabel alloc] init];
    _lineL.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_lineL];
    
    
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.height.and.width.mas_offset(40);
        
    }];
    
    [_authImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImgV.mas_bottom);
        make.right.equalTo(_headImgV.mas_right).offset(6);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.centerY.mas_equalTo(_nameL.mas_centerY);
    }];
    
    [_scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameL.mas_left);
        make.top.equalTo(_nameL.mas_bottom).offset(10);
        
    }];
    
    [_firstImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_scoreL.mas_centerY);
        make.left.equalTo(_scoreL.mas_right).offset(3);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_secImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_firstImgV.mas_centerY);
        make.left.equalTo(_firstImgV.mas_right).offset(2);
        make.height.and.width.offset(12);
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
    
    [_fifImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_firstImgV.mas_centerY);
        make.left.equalTo(_fourImgV.mas_right).offset(2);
        make.height.and.width.mas_equalTo(12);
    }];
    
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scoreL.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameL.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [_lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    
}

- (void)setModel:(SHPerCommentModel *)model
{
    _model = model;
    _contentL.text = model.content;
    _timeL.text = model.createTime;
    _nameL.text = model.user[@"nickName"];
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    if (model.average == 0) {
        
    } else if (model.average == 1) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
    } else if (model.average == 2) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
    } else if (model.average == 3) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
    } else if (model.average == 4) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _fourImgV.image = [UIImage imageNamed:@"evaXing"];
    } else if (model.average == 5) {
        _firstImgV.image = [UIImage imageNamed:@"evaXing"];
        _secImgV.image = [UIImage imageNamed:@"evaXing"];
        _thirdImgV.image = [UIImage imageNamed:@"evaXing"];
        _fourImgV.image = [UIImage imageNamed:@"evaXing"];
        _fifImgV.image = [UIImage imageNamed:@"evaXing"];
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
