//
//  SH_QuestionViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_QuestionViewCell.h"

@interface SH_QuestionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *awardL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UIButton *answerButtobn;


@end


@implementation SH_QuestionViewCell



- (void)setListModel:(SHHomeListModel *)listModel
{
    _listModel = listModel;
    
    _titleL.text = _listModel.title;
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSForegroundColorAttributeName : SH_RedMoneyColor, NSFontAttributeName : SH_MoneyLogoFont}];
    
    NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:_listModel.profit attributes:@{NSForegroundColorAttributeName : SH_RedMoneyColor, NSFontAttributeName : SH_MoneyStringFont}];
    [attr1 appendAttributedString:attr2];
    
    _awardL.attributedText = attr1;
    _leftL.text = [NSString stringWithFormat:@"已答 %ld/%ld", (long)_listModel.surplusNum,_listModel.deliveryNum];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_listModel.pics[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    
    _distanceL.text = [NSString stringWithFormat:@"%.2fkm", _listModel.distance];
    
}









@end
