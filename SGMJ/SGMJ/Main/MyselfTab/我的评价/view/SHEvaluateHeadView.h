//
//  SHEvaluateHeadView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>



@class SHEvaluateDetailModel;


@protocol SHEditEvaluateDetailDelegate <NSObject>

- (void)beginEditEvaluate:(SHEvaluateDetailModel *)detailModel;

@end


@interface SHEvaluateHeadView : UIView


@property (nonatomic, strong) SHEvaluateDetailModel *detailModel;

@property (nonatomic, strong) UIButton *editButton;             //修改评论

@property (nonatomic, weak) id <SHEditEvaluateDetailDelegate>delegate;



@end
