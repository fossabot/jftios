//
//  SHModifyInfoVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHModifyInfoVController.h"


#define MINVALUE    5
#define MAXVALUE    18

@interface SHModifyInfoVController () <UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;


@end

@implementation SHModifyInfoVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
}

- (void)initBaseInfo
{
    if (self.modifyType == SHModifySignatureType) {
        //修改个性签名
        self.navigationItem.title = @"修改个性签名";
        self.numberL.text = @"0/18个字";
    } else if (self.modifyType == SHModifyNicknameType) {
        self.navigationItem.title = @"修改昵称";
        self.numberL.text = @"0/8个字";
    } else if (self.modifyType == SHQuesAndSuggestType) {
        self.navigationItem.title = @"问题与建议";
        self.numberL.text = @"0/100个字";
    }
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_sureButton setBackgroundColor:navColor];
    _sureButton.layer.cornerRadius = _sureButton.height / 2;
    _sureButton.clipsToBounds = YES;
    
    
    
    
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    
    if (![NSString isEmpty:_textView.text]) {
        SHWeakSelf
        if (self.modifyType == SHModifyNicknameType) {
            //修改请求
            NSDictionary *dic = @{
                                  @"nickName":_textView.text
                                  };
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateInfo params:dic success:^(id JSON, int code, NSString *msg) {
                SHLog(@"%d", code)
                [MBProgressHUD hideHUDForView:weakSelf.view];
                if (code == 0) {
                    SH_AppDelegate.personInfo.introduce = _textView.text;
                    [MBProgressHUD showMBPAlertView:@"修改成功" withSecond:2.0];
                    if (weakSelf.infoBlock) {
                        weakSelf.infoBlock(_textView.text);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {
                
            }];
        } else if (self.modifyType == SHModifySignatureType) {
            //修改请求
            NSDictionary *dic = @{
                                  @"introduce":_textView.text
                                  };
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateInfo params:dic success:^(id JSON, int code, NSString *msg) {
                SHLog(@"%d", code)
                [MBProgressHUD hideHUDForView:weakSelf.view];
                if (code == 0) {
                    SH_AppDelegate.personInfo.introduce = _textView.text;
                    [MBProgressHUD showMBPAlertView:@"修改成功" withSecond:2.0];
                    if (weakSelf.infoBlock) {
                        weakSelf.infoBlock(_textView.text);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {
                
            }];
        } else if (self.modifyType == SHQuesAndSuggestType) {
            //问题与建议
            
        }
        
    } else {
        [MBProgressHUD showMBPAlertView:@"请输入内容" withSecond:2.0];
    }
    
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _placeHolderL.alpha = 0;//开始编辑
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    //将要停止编辑（不是第一响应者时）
    if (textView.text.length == 0) {
        _placeHolderL.alpha = 1;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolderL.hidden = YES;
    
    if (self.modifyType == SHModifySignatureType) {
        //实时显示字数
        self.numberL.text = [NSString stringWithFormat:@"%lu/18个字", (unsigned long)textView.text.length];
        
        //字数限制操作
        if (textView.text.length >= 18) {
            
            textView.text = [textView.text substringToIndex:18];
            self.numberL.text = @"18/18个字";
            
        }
        
        //取消按钮点击权限，并显示提示文字
        if (textView.text.length == 0) {
            
            self.placeHolderL.hidden = NO;
            
        }
    } else if (self.modifyType == SHModifyNicknameType) {
        //实时显示字数
        self.numberL.text = [NSString stringWithFormat:@"%lu/8个字", (unsigned long)textView.text.length];
        
        //字数限制操作
        if (textView.text.length >= 8) {
            
            textView.text = [textView.text substringToIndex:8];
            self.numberL.text = @"8/8个字";
            
        }
        
        //取消按钮点击权限，并显示提示文字
        if (textView.text.length == 0) {
            
            self.placeHolderL.hidden = NO;
            
        }
    } else if (self.modifyType == SHQuesAndSuggestType) {
        //实时显示字数
        self.numberL.text = [NSString stringWithFormat:@"%lu/100个字", (unsigned long)textView.text.length];
        
        //字数限制操作
        if (textView.text.length >= 100) {
            
            textView.text = [textView.text substringToIndex:100];
            self.numberL.text = @"100/100个字";
            
        }
        
        //取消按钮点击权限，并显示提示文字
        if (textView.text.length == 0) {
            
            self.placeHolderL.hidden = NO;
            
        }
    }
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
