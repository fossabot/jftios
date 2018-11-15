//
//  SHApplySkillVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHApplySkillVController.h"
#import "SHMyOrderCenterVController.h"
#import "SHMySkillModel.h"
//#import "SHMyOrderDetailModel.h"
#import "TZImagePickerController.h"
#import "ImageUtil.h"


@interface SHApplySkillVController () <UITextViewDelegate, TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *picOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *delPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *picTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *delTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *picThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *delThreeBtn;

@property (nonatomic, strong) NSMutableArray *imageUrlArr;//选中的图片数组
@property (nonatomic, strong) NSMutableArray *localImgArray;//留存的本地图片UIImage
@property (nonatomic, strong) NSMutableArray *urlImgArray;//图片url数组

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;

@property (weak, nonatomic) IBOutlet UILabel *warningL;

@end

@implementation SHApplySkillVController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //return
    //SHColorFromHex(0x00a9f0)
    //字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //修改返回按钮
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 30, 44);
    UIImage * bImage = [[UIImage imageNamed: @"returnBack"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn addTarget:self action:@selector(back) forControlEvents: UIControlEventTouchUpInside];
    [btn setImage:bImage forState: UIControlStateNormal];
    UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = - 20;
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, lb];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    self.navigationController.navigationBar.barTintColor = SHColorFromHex(0x00a9f0);
    
}

- (void)back
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    
}


- (void)initBaseInfo
{    
    if (self.type == SHOrderDoneType) {
        self.navigationItem.title = @"上传凭证";
        _warningL.hidden = NO;
    } else if (self.type == SHSkillAuthoriseType) {
        self.navigationItem.title = @"职业认证";
        _warningL.hidden = YES;
    } else if (self.type == SHFeedBackType) {
        self.navigationItem.title = @"投诉";
        _warningL.hidden = YES;
    } else if (self.type == SHSuggestBackType) {
        self.navigationItem.title = @"问题和建议";
        _warningL.hidden = YES;
    }
    
    
    self.view.backgroundColor = SHColorFromHex(0xf2f2f2);
    
    _imageUrlArr = [NSMutableArray array];
    _localImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    _urlImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    _delPicBtn.hidden = YES;
    _picTwoBtn.hidden = YES;
    _delTwoBtn.hidden = YES;
    _picThreeBtn.hidden = YES;
    _delThreeBtn.hidden = YES;
    
    _sureButton.layer.cornerRadius = _sureButton.height / 2;
    _sureButton.clipsToBounds = YES;
    
}

//选择图片
- (IBAction)pictureButtonClick:(UIButton *)sender {
    [self selectPictureWithButton:sender];
}

//删除图片
- (IBAction)deleteButtonClick:(UIButton *)sender {
    if (sender.tag == 11) {
        //SHLog(@"%@", _localImgArray)
        //SHLog(@"%@", _urlImgArray)
        //第一个删除按钮（第一个删除按钮出现的时候，最少显示一张图片）
        if (![_localImgArray[0] isEqualToString:@""] && [_localImgArray[1] isEqualToString:@""] && [_localImgArray[2] isEqualToString:@""]) {
            //有一张图片，剩余两个是空的
            //SHLog(@"只有一张图片")
            _picTwoBtn.hidden = YES;
            _delPicBtn.hidden = YES;
            [_localImgArray removeObjectAtIndex:0];
            [_urlImgArray removeObjectAtIndex:0];
            [_localImgArray addObject:@""];
            [_urlImgArray addObject:@""];
            [_picOneBtn setBackgroundImage:[UIImage imageNamed:@"pictureBG"] forState:UIControlStateNormal];
            
        } else if (![_localImgArray[0] isEqualToString:@""] && ![_localImgArray[1] isEqualToString:@""] && [_localImgArray[2] isEqualToString:@""]) {
            //有两张图片，最后一张是空的
            //SHLog(@"有两张图片")
            _picThreeBtn.hidden = YES;
            _delTwoBtn.hidden = YES;
            [_localImgArray removeObjectAtIndex:0];
            [_urlImgArray removeObjectAtIndex:0];
            [_localImgArray addObject:@""];
            [_urlImgArray addObject:@""];
            [_picTwoBtn setBackgroundImage:[UIImage imageNamed:@"pictureBG"] forState:UIControlStateNormal];
            [_picOneBtn setBackgroundImage:_urlImgArray[0] forState:UIControlStateNormal];
            
        } else if (![_localImgArray[2] isEqualToString:@""]) {
            //有三张图片，没有空的:删除第一张，最后添加 @""
            //SHLog(@"有三张图片")
            _delThreeBtn.hidden = YES;
            [_localImgArray removeObjectAtIndex:0];
            [_urlImgArray removeObjectAtIndex:0];
            [_localImgArray addObject:@""];
            [_urlImgArray addObject:@""];
            [_picOneBtn setBackgroundImage:_urlImgArray[0] forState:UIControlStateNormal];
            [_picTwoBtn setBackgroundImage:_urlImgArray[1] forState:UIControlStateNormal];
            [_picThreeBtn setBackgroundImage:[UIImage imageNamed:@"pictureBG"] forState:UIControlStateNormal];
            
        }
        //SHLog(@"%@", _localImgArray)
        //SHLog(@"%@", _urlImgArray)
    } else if (sender.tag == 21) {
        //第二个删除按钮
        //判断数组包含 @"" 的位数
        //一种是三张图片
        //SHLog(@"%@", _localImgArray)
        //一种是两张图片
        if ([_localImgArray[2] isEqualToString:@""] && ![_localImgArray[1] isEqualToString:@""]) {
            //SHLog(@"第二张有图片，但是第三张没有图片")
            //两张图片，删除第二张，第三张隐藏，第二张显示背景图
            _delThreeBtn.hidden = YES;
            _picThreeBtn.hidden = YES;
            _delTwoBtn.hidden = YES;
            [_picTwoBtn setBackgroundImage:[UIImage imageNamed:@"pictureBG"] forState:UIControlStateNormal];
            [_localImgArray removeObjectAtIndex:1];
            [_urlImgArray removeObjectAtIndex:1];
            [_localImgArray addObject:@""];
            [_urlImgArray addObject:@""];
            
        } else if (![_localImgArray[2] isEqualToString:@""]) {
            //SHLog(@"三张都不是空的")
            //三张图片，删除第二张，第三张移动到第二张，第三张显示背景图
            _delThreeBtn.hidden = YES;
            [_localImgArray removeObjectAtIndex:1];
            [_urlImgArray removeObjectAtIndex:1];
            [_localImgArray addObject:@""];
            [_urlImgArray addObject:@""];
            [_picThreeBtn setBackgroundImage:[UIImage imageNamed:@"pictureBG"] forState:UIControlStateNormal];
            [_picTwoBtn setBackgroundImage:_urlImgArray[1] forState:UIControlStateNormal];
            
        }
        
    } else if (sender.tag == 31) {
        //第三个删除按钮
        _delThreeBtn.hidden = YES;
        [_picThreeBtn setBackgroundImage:[UIImage imageNamed:@"pictureBG"] forState:UIControlStateNormal];
        [_localImgArray removeLastObject];
        [_urlImgArray removeLastObject];
        [_localImgArray addObject:@""];
        [_urlImgArray addObject:@""];
        
    }
}

//进入相册选择图片
- (void)selectPictureWithButton:(UIButton *)btn
{
    SHWeakSelf
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingGif = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        SHLog(@"%@", photos)
        if (photos.count == 0) {
            
        } else {
            [weakSelf takeOffPictureWithArray:photos withButton:btn];
        }
    }];
    imagePickerVc.naviBgColor = navColor;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



//处理选择的相册
- (void)takeOffPictureWithArray:(NSArray<UIImage *> *)photos withButton:(UIButton *)button
{
    if (photos.count == 1) {
        _delPicBtn.hidden = NO;
        _picTwoBtn.hidden = NO;
    } else if (photos.count == 2) {
        _delPicBtn.hidden = NO;
        _picTwoBtn.hidden = NO;
        _delTwoBtn.hidden = NO;
        _picThreeBtn.hidden = NO;
    } else if (photos.count == 3) {
        _delPicBtn.hidden = NO;
        _picTwoBtn.hidden = NO;
        _delTwoBtn.hidden = NO;
        _picThreeBtn.hidden = NO;
        _delThreeBtn.hidden = NO;
    }
    SHWeakSelf
    //点击第一个按钮
    if (button.tag == 10) {
        SHLog(@"第一个按钮")
        [self.imageUrlArr removeAllObjects];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        for (NSInteger i = 0; i < photos.count; i++) {
            //裁剪图片为正方形
            //UIImage *scaleImage = [ImageUtil image:photos[i] fillSize:CGSizeMake(240, 240)];
            UIImage *scaleImage = [ImageUtil imageWithOriginalImage:photos[i] scale:0.8];
            //压缩图片
            UIImage *compressImage = [ImageUtil comparessImageFromOriginalImage:scaleImage];
            [SG_HttpsTool uploadImageWithURL:imageUrlString image:scaleImage success:^(id JSON, int code, NSString *msg) {
                if (code == 0) {
                    
                    [MBProgressHUD hideHUDForView:weakSelf.view];
                    NSDictionary *dic = JSON[@"data"];
                    NSString *string = [NSString stringWithFormat:@"%@%@", imageSuccessUrl,dic[@"url"]];
                    [weakSelf.imageUrlArr addObject:string];
                    
                    if (i == 0) {
                        _delPicBtn.hidden = NO;
                        [_picOneBtn setBackgroundImage:compressImage forState:UIControlStateNormal];
                        
                    } else if (i == 1) {
                        _picTwoBtn.hidden = NO;
                        _delPicBtn.hidden = NO;
                        _delTwoBtn.hidden = NO;
                        [_picTwoBtn setBackgroundImage:compressImage forState:UIControlStateNormal];
                    } else if (i == 2) {
                        _picTwoBtn.hidden = NO;
                        _delPicBtn.hidden = NO;
                        _delTwoBtn.hidden = NO;
                        _picThreeBtn.hidden = NO;
                        _delThreeBtn.hidden = NO;
                        [_picThreeBtn setBackgroundImage:compressImage forState:UIControlStateNormal];
                    }
                    
                    [_localImgArray replaceObjectAtIndex:i withObject:string];
                    [_urlImgArray replaceObjectAtIndex:i withObject:compressImage];
                    
                    //SHLog(@"%@", weakSelf.imageUrlArr)
                    // SHLog(@"%@", _localImgArray)
                } else {
                    [MBProgressHUD showError:@"图片上传失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"图片上传失败"];
            }];
            
            
        }
    } else if (button.tag == 20) {
        SHLog(@"第二个按钮")
        //根据选中图片进行判断，更改图片，如果是选取一张，更换第二个，如果是选取两张，更还后两张
        [self.imageUrlArr removeAllObjects];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        for (NSInteger i = 0; i < photos.count; i++) {
            //            if (i == 2) {
            //                break;
            //            }
            //裁剪图片为正方形
            //UIImage *scaleImage = [ImageUtil image:photos[i] fillSize:CGSizeMake(240, 240)];
            UIImage *scaleImage = [ImageUtil imageWithOriginalImage:photos[i] scale:0.8];
            //压缩图片
            UIImage *compressImage = [ImageUtil comparessImageFromOriginalImage:scaleImage];
            [SG_HttpsTool uploadImageWithURL:imageUrlString image:scaleImage success:^(id JSON, int code, NSString *msg) {
                if (code == 0) {
                    [MBProgressHUD hideHUDForView:weakSelf.view];
                    NSDictionary *dic = JSON[@"data"];
                    NSString *string = [NSString stringWithFormat:@"%@%@", imageSuccessUrl,dic[@"url"]];
                    [weakSelf.imageUrlArr addObject:string];
                    
                    //如果选中图片个数是一的话，更换第二个按钮的图片
                    if (i == 0) {
                        _picTwoBtn.hidden = NO;
                        _delPicBtn.hidden = NO;
                        _delTwoBtn.hidden = NO;
                        _picThreeBtn.hidden = NO;
                        [_picTwoBtn setBackgroundImage:compressImage forState:UIControlStateNormal];
                    } else if (i == 1) {
                        _picTwoBtn.hidden = NO;
                        _delPicBtn.hidden = NO;
                        _delTwoBtn.hidden = NO;
                        _picThreeBtn.hidden = NO;
                        _delThreeBtn.hidden = NO;
                        [_picThreeBtn setBackgroundImage:compressImage forState:UIControlStateNormal];
                    }
                    
                    if (i <= 1) {
                        [_localImgArray replaceObjectAtIndex:i + 1 withObject:string];
                        [_urlImgArray replaceObjectAtIndex:i+1 withObject:compressImage];
                    }
                    
                    
                } else {
                    [MBProgressHUD showError:@"图片上传失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"图片上传失败"];
            }];
            
            
        }
    } else if (button.tag == 30) {
        SHLog(@"第三个按钮")
        [self.imageUrlArr removeAllObjects];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        for (NSInteger i = 0; i < photos.count; i++) {
            //裁剪图片为正方形
            //UIImage *scaleImage = [ImageUtil image:photos[i] fillSize:CGSizeMake(240, 240)];
            UIImage *scaleImage = [ImageUtil imageWithOriginalImage:photos[i] scale:0.8];
            //压缩图片
            UIImage *compressImage = [ImageUtil comparessImageFromOriginalImage:scaleImage];
            [SG_HttpsTool uploadImageWithURL:imageUrlString image:scaleImage success:^(id JSON, int code, NSString *msg) {
                if (code == 0) {
                    [MBProgressHUD hideHUDForView:weakSelf.view];
                    NSDictionary *dic = JSON[@"data"];
                    NSString *string = [NSString stringWithFormat:@"%@%@", imageSuccessUrl,dic[@"url"]];
                    [weakSelf.imageUrlArr addObject:string];
                    
                    if (i == 0) {
                        _picTwoBtn.hidden = NO;
                        _delPicBtn.hidden = NO;
                        _delTwoBtn.hidden = NO;
                        _picThreeBtn.hidden = NO;
                        _delThreeBtn.hidden = NO;
                        [_picThreeBtn setBackgroundImage:compressImage forState:UIControlStateNormal];
                        
                    }
                    
                    if (i == 0) {
                        [_localImgArray replaceObjectAtIndex:2 withObject:string];
                        [_urlImgArray replaceObjectAtIndex:2 withObject:compressImage];
                    }
                    
                } else {
                    [MBProgressHUD showError:@"图片上传失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"图片上传失败"];
            }];
            
            if (i != 0) {
                break;
            }
            
        }
    }
    
}

- (BOOL)judgeAllParagramsSure
{
    if ([NSString isEmpty:_textView.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入文字" withSecond:2.0];
        return NO;
    }
    
    if ([_localImgArray[0] isEqualToString:@""] && [_localImgArray[1] isEqualToString:@""] && [_localImgArray[2] isEqualToString:@""]) {
        [MBProgressHUD showMBPAlertView:@"请上传至少一张图片" withSecond:2.0];
        return NO;
    }
    
    return YES;
}


- (IBAction)sureButtonClick:(UIButton *)sender {
    if ([self judgeAllParagramsSure]) {
        if (self.type == SHOrderDoneType) {
            //订单完成上传凭证
            [self orderDoneRequest];
        } else if (self.type == SHSkillAuthoriseType) {
            //技能认证上传凭证
            [self skillAuthoriseRequest];
        } else if (self.type == SHFeedBackType) {
            //投诉接口
            [self loadSuggestAndBack];
        } else if (self.type == SHSuggestBackType) {
            //问题和建议
            SHLog(@"问题和建议")
            [self loadSuggestAndBack];
        }
    }
    
    
}

//建议和反馈接口,投诉
- (void)loadSuggestAndBack
{
    NSDictionary *dic = nil;
    NSString *urlString = nil;
    for (NSString *url in _localImgArray) {
        if ([url isEqualToString:@""]) {
            
        } else {
            if (urlString) {
                urlString = [NSString stringWithFormat:@"%@,%@", urlString,url];
            } else {
                urlString = [NSString stringWithFormat:@"%@",url];
            }
            
        }
    }
    if (self.type == SHFeedBackType) {
        dic = @{
                @"content":_textView.text,
                @"model":@"COMPLAINTS",
                @"images":urlString,
                
                };
    } else if (self.type == SHSuggestBackType) {
        dic = @{
                @"content":_textView.text,
                @"model":@"SUGGESTION",
                @"images":urlString,
                
                };
    }
    SHLog(@"%@", dic)
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHFeedBackAndSugUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"反馈成功" withSecond:2.0];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
}

//订单完成之后上传凭证
- (void)orderDoneRequest
{
    SHWeakSelf
    NSString *urlString = nil;
    for (NSString *url in _localImgArray) {
        if ([url isEqualToString:@""]) {
            
        } else {
            if (urlString) {
                urlString = [NSString stringWithFormat:@"%@,%@", urlString,url];
            } else {
                urlString = [NSString stringWithFormat:@"%@",url];
            }
            
        }
    }
    SHLog(@"%@", urlString)
    
    NSDictionary *dic = @{
                          @"orderNo":_orderNo,
                          @"content":_textView.text,
                          @"images":urlString
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHOrderDoneUploadUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"上传成功" withSecond:2.0];
            if (weakSelf.orderDoneBlock) {
                weakSelf.orderDoneBlock(_orderNo);
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
            
//            if (_intype == SHOrderListPushType) {
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadOrderList" object:nil];
//            } else {
//                SHLog(@"推送不走这个")
//            }
            
            [weakSelf back];
        } else {
            [MBProgressHUD showMBPAlertView:@"上传失败" withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMBPAlertView:@"上传失败" withSecond:2.0];
    }];
    
}

//技能认证上传凭据
- (void)skillAuthoriseRequest
{
    SHWeakSelf
    NSString *urlString = nil;
    for (NSString *url in _localImgArray) {
        if ([url isEqualToString:@""]) {
            
        } else {
            if (urlString) {
                urlString = [NSString stringWithFormat:@"%@,%@", urlString,url];
            } else {
                urlString = [NSString stringWithFormat:@"%@",url];
            }
            
        }
    }
    NSDictionary *dic = @{
                          @"verifyId":@(_model.ID),
                          @"introduce":_textView.text,
                          @"imgList":urlString
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHSkillAuthoriseUrl params:dic success:^(id JSON, int code, NSString *msg) {
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
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

//UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    int num = 100;
    _textView = textView;
    _placeHolderL.hidden = YES;
    _numberL.text = [NSString stringWithFormat:@"%ld/100",(long)textView.text.length];
    
    if (_textView.text.length >= num) {
        _textView.text = [_textView.text substringToIndex:num];
    }
    //取消安润点击权限，并显示文字
    if (_textView.text.length == 0) {
        _placeHolderL.hidden = NO;
    }
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
