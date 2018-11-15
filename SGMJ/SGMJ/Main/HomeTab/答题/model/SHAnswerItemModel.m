//
//  SHAnswerItemModel.m
//  SGMJ
//
//  Created by 曾建国 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAnswerItemModel.h"

@implementation SHAnswerItemModel

- (instancetype)init
{
    if (self = [super init]) {
        self.seleteIndex = -1;
    }
    return self;
}

- (NSArray *)questionsArr {
    if (!_questionsArr) {
        _questionsArr = [NSArray arrayWithObjects:self.answerA,self.answerB,self.answerC];
    }
    return _questionsArr;
}

- (BOOL)isCorrect
{
    
    
    switch (self.seleteIndex) {
        case 0:
            if ([self.correctResponse isEqual:@"A"]) {
                return YES;
            }
            break;
        case 1:
            if ([self.correctResponse isEqual:@"B"]) {
                return YES;
            }
            break;
        case 2:
            if ([self.correctResponse isEqual:@"C"]) {
                return YES;
            }
            break;
        default:
            break;
    }
    return NO;
}


- (SHAnswerItemModel *)calculateHeight:(SHAnswerItemModel *)model
{
    CGRect rect = [model.question boundingRectWithSize:CGSizeMake(SHScreenW - 26, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f ]} context:nil];
    model.questionHeight = rect.size.height + 15;
    
    CGRect rectA = [model.answerA boundingRectWithSize:CGSizeMake(SHScreenW - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f ]} context:nil];
    model.answerAHeight = rectA.size.height + 15;
    
    
    CGRect rectB = [model.answerB boundingRectWithSize:CGSizeMake(SHScreenW - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f ]} context:nil];
    model.answerBHeight = rectB.size.height + 15;
    
    CGRect rectC = [model.answerC boundingRectWithSize:CGSizeMake(SHScreenW - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f ]} context:nil];
    model.answerCHeight = rectC.size.height + 15;
    
    return model;
}





















@end
