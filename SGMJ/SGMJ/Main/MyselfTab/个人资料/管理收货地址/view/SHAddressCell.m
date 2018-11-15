//
//  SHAddressCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/9.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAddressCell.h"
#import "SHAddressModel.h"
#import "SHNewAddAddressVController.h"


@interface SHAddressCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation SHAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = YES;
    
    
}

- (void)setAddressModel:(SHAddressModel *)addressModel
{
    _addressModel = addressModel;
    
    _nameL.text = _addressModel.receiveName;
    _phoneL.text = _addressModel.receivePhone;
    _addressL.text = [NSString stringWithFormat:@"%@%@%@%@", _addressModel.province, _addressModel.city, _addressModel.area, _addressModel.detailAddress];
    if (_addressModel.isDefault == 1) {
        [_defaultButton setImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        [_defaultButton setTitle:@" 默认地址" forState:UIControlStateNormal];
    } else {
        [_defaultButton setImage:[UIImage imageNamed:@"unconfirmed"] forState:UIControlStateNormal];
        [_defaultButton setTitle:@" 设为默认" forState:UIControlStateNormal];
    }
    
}


- (IBAction)defaultButtonClick:(id)sender {
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    NSDictionary *dic = @{
                          @"addressId":@(_addressModel.ID)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHDefaultAddUrl params:dic success:^(id JSON, int code, NSString *msg) {
        
        if (code == 0) {
            [MBProgressHUD hideHUDForView:weakSelf.viewController.view animated:YES];
            _addressModel.isDefault = 1;
            [_defaultButton setImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
            [_defaultButton setTitle:@" 默认地址" forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"defaultAddress" object:nil userInfo:dic];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)editorButtonClick:(id)sender {
    SHNewAddAddressVController *vc = [[SHNewAddAddressVController alloc] init];
    vc.addressType = SHAddressEditType;
    vc.addressModel = _addressModel;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteButtonClick:(id)sender {
    NSDictionary *dic = @{
                          @"addressId":@(_addressModel.ID)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHDeleteAddUrl params:dic success:^(id JSON, int code, NSString *msg) {
        if (code == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAddress" object:nil userInfo:dic];
        }
    } failure:^(NSError *error) {
        
    }];
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
