//
//  SHSkillTViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSkillTViewCell.h"
#import "SHSkillModel.h"
#import "SHMySkillModel.h"
#import "SHApplySkillVController.h"

@interface SHSkillTViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation SHSkillTViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _applyButton.layer.cornerRadius = 10;
    _applyButton.clipsToBounds = YES;
    
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = YES;
    
    self.imgButton.userInteractionEnabled = NO;
    
}



- (void)setSkillModel:(SHSkillModel *)skillModel
{
    
    _skillModel = skillModel;
    
    _nameLabel.text = skillModel.name;
    //0是选中   1不选中
    if (skillModel.isSelected == 1) {
        [self.imgButton setBackgroundImage:[UIImage imageNamed:@"unsureSkill"] forState:UIControlStateNormal];
    } else {
        [self.imgButton setBackgroundImage:[UIImage imageNamed:@"sureSkill"] forState:UIControlStateNormal];
    }
    
    //0   1.审核中  2成功  3失败
    if (skillModel.status == 0) {
        self.applyButton.userInteractionEnabled = YES;
    } else if (skillModel.status == 1) {
        [self.applyButton setTitle:@"审核中" forState:UIControlStateNormal];
        self.applyButton.userInteractionEnabled = NO;
    } else if (skillModel.status == 2) {
        [self.applyButton setTitle:@"成功" forState:UIControlStateNormal];
        self.applyButton.userInteractionEnabled = NO;
    } else if (skillModel.status == 3) {
        [self.applyButton setTitle:@"重新申请" forState:UIControlStateNormal];
        self.applyButton.userInteractionEnabled = YES;
    }
    
    
    
    
}


- (void)setMyModel:(SHMySkillModel *)myModel
{
    _myModel = myModel;
    SHLog(@"%@", _myModel.categoryName)
    SHLog(@"%@", myModel.categoryName)
    _nameLabel.text = myModel.categoryName;
    
    
}

- (IBAction)applyButtonClick:(UIButton *)sender {
    
    SHLog(@"%d", _myModel.categoryId)
    
    SHApplySkillVController *vc = [[SHApplySkillVController alloc] init];
    vc.model = _myModel;
    vc.type = SHSkillAuthoriseType;
    [[self viewController].navigationController pushViewController:vc animated:YES];
    
}




- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
