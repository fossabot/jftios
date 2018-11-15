//
//  SHFollowFanTViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHFollowFanTViewCell.h"
#import "SHFollowAndFansModel.h"
#import "SHFollowUserModel.h"

@interface SHFollowFanTViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *signatureL;


@end


@implementation SHFollowFanTViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _followButton.layer.borderWidth = 1;
    _followButton.borderColor = navColor;
    
}


- (IBAction)followButtonClick:(UIButton *)sender {
    
    NSDictionary *dic = @{
                          @"careId":@(_model.user.ID)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHFollowOtherUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            if ([_delegate respondsToSelector:@selector(tellVCloadData)]) {
                [_delegate tellVCloadData];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)setModel:(SHFollowAndFansModel *)model
{
    _model = model;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameL.text = model.user.nickName;
    _signatureL.text = model.user.introduce;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
