//
//  SHNeedTableViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHNeedTableViewCell.h"
#import "SHNeedTingModel.h"
#import "SHPersonalViewController.h"

@interface SHNeedTableViewCell ()

@property (nonatomic, strong) UIImageView *headImgV;        //头像
@property (nonatomic, strong) UIImageView *authImgV;        //认证图片
@property (nonatomic, strong) UILabel *nameLabel;           //姓名
@property (nonatomic, strong) UIButton *followButton;       //关注按钮
@property (nonatomic, strong) UIButton *phoneButton;        //电话按钮
@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) UILabel *distanceLabel;       //距离
@property (nonatomic, strong) UILabel *contentLabel;        //描述
@property (nonatomic, strong) UIImageView *statusImgV;      //状态图片
@property (nonatomic, strong) UILabel *statusLabel;         //状态
@property (nonatomic, strong) UILabel *leftDayLabel;        //剩余天数
@property (nonatomic, strong) UILabel *forecastLabel;       //预估价格
@property (nonatomic, strong) UIButton *robOrderButton;     //抢单按钮
@property (nonatomic, strong) UILabel *lineLabel;           //底部颜色

@end

@implementation SHNeedTableViewCell

- (void)setFrame:(CGRect)frame{
//    frame.size.height -= 3;
//    frame.origin.y += 3;
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    //头像13+40
    _headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 40, 40)];
    _headImgV.layer.cornerRadius = _headImgV.height / 2;
    _headImgV.clipsToBounds = YES;
    _headImgV.image = [UIImage imageNamed:@"defaultHead"];
    _headImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImgV)];
    [_headImgV addGestureRecognizer:tap];
    [self.contentView addSubview:_headImgV];
    
    //认证图片
    _authImgV = [[UIImageView alloc] init];
    _authImgV.image = [UIImage imageNamed:@"authorize"];
    [self.contentView addSubview:_authImgV];
    [_authImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headImgV.mas_right).offset(6);
        make.bottom.mas_equalTo(_headImgV.mas_bottom);
        make.height.with.width.mas_equalTo(12);
    }];

    //姓名
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    _nameLabel.text = @"我的名字";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.centerY.mas_equalTo(_headImgV.mas_centerY);
    }];

    //电话
    _phoneButton = [[UIButton alloc] init];
    [_phoneButton setImage:[UIImage imageNamed:@"iphone"] forState:UIControlStateNormal];
    [_phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_phoneButton];
    [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.top.mas_equalTo(_headImgV.mas_top);
        make.height.and.width.mas_equalTo(25);
    }];

    //关注按钮
    _followButton = [[UIButton alloc] init];
    [_followButton setImage:[UIImage imageNamed:@"notcollect"] forState:UIControlStateNormal];
    [_followButton addTarget:self action:@selector(followButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followButton];
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_phoneButton.mas_left).offset(-20);
        make.centerY.mas_equalTo(_phoneButton.mas_centerY);
        make.height.and.width.mas_equalTo(_phoneButton.mas_width);
    }];

    //标题10+20
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    _titleLabel.text = @"标题：";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_bottom).offset(10);
        make.left.mas_equalTo(_headImgV.mas_left);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(_phoneButton.mas_right);

    }];

    //距离
    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.textColor = navColor;
    _distanceLabel.font = SH_FontSize(14);
    _distanceLabel.text = @"111KM";
    [self.contentView addSubview:_distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.centerY.mas_equalTo(_titleLabel.mas_top);

    }];


    //描述
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:12.0];
    _contentLabel.textColor = SHColorFromHex(0x9a9a9a);
    _contentLabel.numberOfLines = 0;
    [_contentLabel sizeToFit];
    _contentLabel.text = @"描述";
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.right.mas_equalTo(_phoneButton.mas_right);

    }];
    
    //状态图片
    _statusImgV = [[UIImageView alloc] init];
    _statusImgV.image = [UIImage imageNamed:@"serviceing"];
    [self.contentView addSubview:_statusImgV];
    [_statusImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgV.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(10);
        make.height.and.width.mas_equalTo(15);
    }];
    

    //状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.font = [UIFont systemFontOfSize:14.0];
    _statusLabel.text = @"竞价中";
    _statusLabel.textColor = SHColorFromHex(0xf55d6b);
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_statusImgV.mas_centerY);
        make.left.equalTo(_statusImgV.mas_right).offset(10);
        make.height.mas_equalTo(15);
    }];

    //剩余天数
    _leftDayLabel = [[UILabel alloc] init];
    _leftDayLabel.text = @"剩余天数：";
    _leftDayLabel.textColor = SHColorFromHex(0x9a9a9a);
    _leftDayLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_leftDayLabel];
    [_leftDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgV.mas_left);
        make.top.equalTo(_statusLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    //预估价格
    _forecastLabel = [[UILabel alloc] init];
    _forecastLabel.text = @"预算：";
    _forecastLabel.font = [UIFont systemFontOfSize:12.0];
    _forecastLabel.textColor = SHColorFromHex(0x9a9a9a);
    [self.contentView addSubview:_forecastLabel];
    [_forecastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftDayLabel.mas_right).offset(20);
        make.centerY.mas_equalTo(_leftDayLabel.mas_centerY);
    }];

    
    //抢单按钮
//    _robOrderButton = [[UIButton alloc] init];
//    [_robOrderButton setTitle:@"立即抢单" forState:UIControlStateNormal];
//    [_robOrderButton setBackgroundColor:SHColorFromHex(0xa2e2fb)];
//    _robOrderButton.titleLabel.font = SH_FontSize(14);
//    [_robOrderButton setTitleColor:navColor forState:UIControlStateNormal];
//    [self.contentView addSubview:_robOrderButton];
//    [_robOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(_phoneButton.mas_right);
//        make.centerY.equalTo(_statusLabel.mas_bottom).offset(8);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(30);
//    }];
//    _robOrderButton.cornerRadius = 10;
//    _robOrderButton.clipsToBounds = YES;
    
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftDayLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)tapHeadImgV
{
    SHLog(@"点击头像")
    SHPersonalViewController *Vc = [[SHPersonalViewController alloc] init];
    Vc.providerId = _model.needUserId;
    [[self viewController].navigationController pushViewController:Vc animated:YES];
}

- (void)followButtonClick
{
    NSDictionary *dic = @{
                          @"careId":@(_model.needUserId)
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
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)phoneButtonClick
{
    
    [self callPhoneStr:_model.phone];
    
}

#pragma mark - Model
- (void)createMainViewCellWithSHNeedTingModel:(SHNeedTingModel *)model
{
    _model = model;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:model.needUserAvatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameLabel.text = model.needUserNickName;
    
    _titleLabel.text = [NSString stringWithFormat:@"标题：%@", model.title];
    _contentLabel.text = [NSString stringWithFormat:@"描述：%@", model.content];
    NSString *leftString = @"剩余天数：";
    NSString *rightString = [NSString stringWithFormat:@"%d天", model.leftDays];
    _leftDayLabel.text = [NSString stringWithFormat:@"%@%@", leftString, rightString];
    
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:_leftDayLabel.text];
    NSRange range1 = [[hintString string] rangeOfString:rightString];
    [hintString addAttribute:NSForegroundColorAttributeName value:SHColorFromHex(0xf5ac5d) range:range1];
    _leftDayLabel.attributedText = hintString;
    
    NSString *foreString = @"预算：";
    NSString *foreRightStr = [NSString stringWithFormat:@"%.2f元", model.money];
    _forecastLabel.text = [NSString stringWithFormat:@"%@%@", foreString, foreRightStr];
    NSMutableAttributedString *forecastString = [[NSMutableAttributedString alloc] initWithString:_forecastLabel.text];
    NSRange range2 = [[forecastString string] rangeOfString:foreRightStr];
    [forecastString addAttribute:NSForegroundColorAttributeName value:SHColorFromHex(0xf5ac5d) range:range2];
    _forecastLabel.attributedText = forecastString;
    
    _distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", model.distance];
    
    //状态 0竞价中 1服务进行中 2已完成 3 退款 4 超时 5 弃标
    if (model.status == 0) {
        _statusImgV.image = [UIImage imageNamed:@"beingBidding"];
        _statusLabel.text = @"竞价中";
    } else if (model.status == 1) {
        _statusImgV.image = [UIImage imageNamed:@"serviceing"];
        _statusLabel.text = @"服务进行中";
    } else if (model.status == 2) {
        _statusImgV.image = [UIImage imageNamed:@"haveDone"];
        _statusLabel.text = @"已完成";
    } else if (model.status == 3) {
        _statusImgV.image = [UIImage imageNamed:@"beingBidding"];
        _statusLabel.text = @"退款";
    } else if (model.status == 4) {
        _statusImgV.image = [UIImage imageNamed:@"haveCancel"];
        _statusLabel.text = @"超时";
    } else if (model.status == 5) {
        _statusImgV.image = [UIImage imageNamed:@"haveCancel"];
        _statusLabel.text = @"弃标";
    }
    
    if (SH_AppDelegate.personInfo.userId == model.needUserId) {
        _followButton.hidden = YES;
        _phoneButton.hidden = YES;
        _distanceLabel.hidden = YES;
    } else {
        _followButton.hidden = NO;
        _phoneButton.hidden = NO;
        _distanceLabel.hidden = NO;
    }
    
    
    
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_contentLabel sizeToFit];
}

+ (CGFloat)cellHeightWithModel:(SHNeedTingModel *)model
{
    NSString *content = model.content;
    // 写法1.
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
    CGRect contentRect = [content boundingRectWithSize:CGSizeMake(SHScreenW - 26, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    CGFloat contentHeight;
    contentHeight = ceilf(contentRect.size.height);
    return 177 + contentHeight;
}













- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
