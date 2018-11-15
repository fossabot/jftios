//
//  SHOrderListCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/1.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHOrderListCell.h"
#import "SHOrderListModel.h"
#import "SHApplySkillVController.h"
#import "SHPayOrderVController.h"
#import "SHEvaluteOrderViewController.h"

@interface SHOrderListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;



@end


@implementation SHOrderListCell

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 3;
    frame.origin.y += 3;
    [super setFrame:frame];
}

- (void)setListModel:(SHOrderListModel *)listModel
{
    _listModel = listModel;
    
    _leftButton.layer.cornerRadius = 10;
    _rightButton.layer.cornerRadius = 10;
    _leftButton.clipsToBounds = YES;
    _rightButton.clipsToBounds = YES;
    
    [_headImgV sd_setImageWithURL:listModel.userData[@"avatar"] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    _nameLabel.text = listModel.userData[@"nickName"];
    if ([listModel.orderStatus isEqualToString:@"INIT"]) {
        _statusLabel.text = @"待付款";
        if (listModel.isCustomer == 0) {
            //按钮：立即支付和取消订单  两个按钮
            _leftButton.hidden = NO;
            [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_leftButton setBackgroundColor:SHColorFromHex(0xf0e2d3)];
            [_leftButton setTitleColor:SHColorFromHex(0xe9aa5b) forState:UIControlStateNormal];
            
            [_rightButton setTitle:@"立即付款" forState:UIControlStateNormal];
            [_rightButton setTitleColor:navColor forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:SHColorFromHex(0xd5e4f2)];
            
        } else if (listModel.isCustomer == 1) {
            //按钮：立即支付和取消订单  两个按钮
            _leftButton.hidden = YES;
            [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_leftButton setBackgroundColor:SHColorFromHex(0xf0e2d3)];
            [_leftButton setTitleColor:SHColorFromHex(0xe9aa5b) forState:UIControlStateNormal];
            
            _rightButton.userInteractionEnabled = NO;
            [_rightButton setTitle:@"用户待付款" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:SHColorFromHex(0x9a9a9a)];
            
        }
    } else if ([listModel.orderStatus isEqualToString:@"RECEIVE"]) {
        _statusLabel.text = @"待服务";
        //按钮：用户-催单提醒  服务者-立即出发 一个按钮
        _leftButton.hidden = YES;
        if (listModel.isCustomer == 0) {
            [_rightButton setTitleColor:navColor forState:UIControlStateNormal];
            [_rightButton setTitle:@"我要催单" forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:SHColorFromHex(0xd5e4f2)];
        } else if (listModel.isCustomer == 1) {
            [_rightButton setTitleColor:navColor forState:UIControlStateNormal];
            [_rightButton setTitle:@"立即出发" forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:SHColorFromHex(0xd5e4f2)];
        }
        
    } else if ([listModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        _statusLabel.text = @"待确认";
        _leftButton.hidden = YES;
        //用户-确认服务   一个按钮
        [_rightButton setTitleColor:navColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"确认服务" forState:UIControlStateNormal];
        [_rightButton setBackgroundColor:SHColorFromHex(0xd5e4f2)];
    } else if ([listModel.orderStatus isEqualToString:@"UN_EVALUATION"]) {
        _statusLabel.text = @"待评价";
         _leftButton.hidden = YES;
        //立即评价
        if (listModel.isCustomer == 0) {
            [_rightButton setTitle:@"待评价" forState:UIControlStateNormal];
            [_rightButton setTitleColor:navColor forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:SHColorFromHex(0xd5e4f2)];
        } else {
            [_rightButton setTitle:@"用户待评价" forState:UIControlStateNormal];
            _rightButton.userInteractionEnabled = NO;
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        }
        
    } else if ([listModel.orderStatus isEqualToString:@"SUCCESS"]) {
        _statusLabel.text = @"已完结";
        //已完结
        _leftButton.hidden = YES;
        [_rightButton setTitle:@"已完结" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setBackgroundColor:SHColorFromHex(0x9a9a9a)];
        _rightButton.userInteractionEnabled = NO;
        
    }
    _titLabel.text = listModel.category;
    _numberL.text = [NSString stringWithFormat:@"数量：%d", listModel.amount];
    _priceL.text = listModel.unit;
    _unitLabel.text = [NSString stringWithFormat:@"￥%@元\/", listModel.univalence];
    _totalPriceL.text = listModel.realPrice;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:listModel.imgUrl] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    
}

//左按钮
- (IBAction)leftBtnClick:(UIButton *)sender {
    if ([_listModel.orderStatus isEqualToString:@"INIT"]) {
        //两个按钮：立即支付和取消订单
        SHLog(@"取消订单")
        [self cancelOrderRequest];
    } else if ([_listModel.orderStatus isEqualToString:@"RECEIVE"]) {
        //用户：催单提醒、服务者：立即出发
        if (_listModel.isCustomer == 0) {
            //我要催单接口
            //[self loadCuiDanRequest];
        } else if (_listModel.isCustomer == 1) {
            //立即出发
            //[self loadGoToServiceRightNow];
        }
    } else if ([_listModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        //确认按钮
        //[self makeSureService];
    } else if ([_listModel.orderStatus isEqualToString:@"UN_EVALUATION"]) {
        //待评价
        //[self evaluteOrderRightNow];
    } else if ([_listModel.orderStatus isEqualToString:@"SUCCESS"]) {
        
    }
    [MBProgressHUD showMBPAlertView:@"系统整改中" withSecond:2.0];
//    if ([_delegate respondsToSelector:@selector(changeOrderStatus:)]) {
//        [_delegate changeOrderStatus:INIT];
//    }
    
}

//右按钮
- (IBAction)rightButtonClick:(UIButton *)sender {
    if ([_listModel.orderStatus isEqualToString:@"INIT"]) {
        //两个按钮：立即支付和取消订单
        //立即付款
        SHLog(@"立即付款")
        [self payOrderRightNow];
    } else if ([_listModel.orderStatus isEqualToString:@"RECEIVE"]) {
        //用户：催单提醒、服务者：立即出发
        if (_listModel.isCustomer == 0) {
            //我要催单接口
            SHLog(@"我要催单")
            [self loadCuiDanRequest];
        } else if (_listModel.isCustomer == 1) {
            //立即出发
            SHLog(@"立即出发")
            [self loadGoToServiceRightNow];
        }
    } else if ([_listModel.orderStatus isEqualToString:@"UN_CONFIRMED"]) {
        //确认按钮
        SHLog(@"确认")
        [self makeSureService];
    } else if ([_listModel.orderStatus isEqualToString:@"UN_EVALUATION"]) {
        //待评价
        SHLog(@"待评价")
        [self evaluteOrderRightNow];
    } else if ([_listModel.orderStatus isEqualToString:@"SUCCESS"]) {
        
    }

}

#pragma mark - 接口请求
//取消订单
- (void)cancelOrderRequest
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_listModel.orderNo
                          };
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHCancelOrderUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"取消成功" withSecond:2.0];
            if ([_delegate respondsToSelector:@selector(changeOrderStatus:)]) {
                [_delegate changeOrderStatus:_listModel.orderStatus];
            }
        } else {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf];
    }];
    
}

//立即支付
- (void)payOrderRightNow
{
    SHPayOrderVController *vc = [[SHPayOrderVController alloc] init];
    vc.orderNo = _listModel.orderNo;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

//我要催单
- (void)loadCuiDanRequest
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_listModel.orderNo
                          };
    SHLog(@"%@", dic)
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHCuiDanOrderUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"催单成功" withSecond:2.0];
            if ([_delegate respondsToSelector:@selector(changeOrderStatus:)]) {
                [_delegate changeOrderStatus:_listModel.orderStatus];
            }
        } else if (code == 500) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf];
    }];
    
}

//立即出发
- (void)loadGoToServiceRightNow
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_listModel.orderNo
                          };
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHGoToSerRightNowUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"开始出发" withSecond:2.0];
            if ([_delegate respondsToSelector:@selector(changeOrderStatus:)]) {
                [_delegate changeOrderStatus:_listModel.orderStatus];
            }
        } else {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf];
    }];
    
    
}

//确认服务
- (void)makeSureService
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_listModel.orderNo
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHSureServiceUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            if ([_delegate respondsToSelector:@selector(changeOrderStatus:)]) {
                [_delegate changeOrderStatus:_listModel.orderStatus];
            }
        } else if (code == 100) {
            //服务者跳转到上传凭证页面
            SHApplySkillVController *vc = [[SHApplySkillVController alloc] init];
            vc.type = SHOrderDoneType;
            vc.orderNo = _listModel.orderNo;
            vc.orderDoneBlock = ^(NSString *orderNo) {
                [weakSelf dealWithEvaluteOrder];
            };
            [[weakSelf viewController].navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//立即评价
- (void)evaluteOrderRightNow
{
    SHEvaluteOrderViewController *vc = [[SHEvaluteOrderViewController alloc] init];
    vc.orderNo = _listModel.orderNo;
    vc.evaluateType = SHEvaluateOrderNoType;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

- (void)dealWithEvaluteOrder
{
    if ([_delegate respondsToSelector:@selector(changeOrderStatus:)]) {
        [_delegate changeOrderStatus:_listModel.orderStatus];
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


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headImgV.layer.cornerRadius = _headImgV.height / 2;
    _headImgV.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
