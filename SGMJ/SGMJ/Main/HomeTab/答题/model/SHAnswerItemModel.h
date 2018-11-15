//
//  SHAnswerItemModel.h
//  SGMJ
//
//  Created by 曾建国 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHAnswerItemModel : NSObject;

@property (nonatomic, strong) NSString *answerA;
@property (nonatomic, strong) NSString *answerB;
@property (nonatomic, strong) NSString *answerC;
@property (nonatomic, strong) NSString *correctResponse;
@property (nonatomic, strong) NSString *question;

//问题选项的数组
@property (nonatomic, strong) NSArray *questionsArr;

//选择的下标  默认为-1
@property (nonatomic, assign) NSInteger seleteIndex;
//是否选择正确  重写get方法
@property (nonatomic, assign) BOOL isCorrect;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) CGFloat questionHeight;
@property (nonatomic, assign) CGFloat answerAHeight;
@property (nonatomic, assign) CGFloat answerBHeight;
@property (nonatomic, assign) CGFloat answerCHeight;

- (SHAnswerItemModel *)calculateHeight:(SHAnswerItemModel *)model;


@end
