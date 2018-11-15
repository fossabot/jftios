//
//  SHRAdverViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/12.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHRAdverViewController.h"
#import "SHLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "SH_AlertView.h"
#import "SHRelCataModel.h"
#import "SHCatagoryView.h"
#import "TZImagePickerController.h"
#import "ImageUtil.h"
#import "SHOrderModel.h"
#import "SHPayOrderVController.h"

@interface SHRAdverViewController () <UIGestureRecognizerDelegate, UITextViewDelegate, TZImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) SH_AlertView *alertView;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *catagoryButton;//分类
@property (weak, nonatomic) IBOutlet UITextField *mainTitleTF;//主题
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;//添加描述
@property (weak, nonatomic) IBOutlet UILabel *placeholderL;//占位符
@property (weak, nonatomic) IBOutlet UIButton *quesOneBtn;//问题1
@property (weak, nonatomic) IBOutlet UIButton *quesTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *quesThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fusheButton;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswerL;//正确答案

@property (weak, nonatomic) IBOutlet UIButton *picOneBtn;//第一个图片按钮
@property (weak, nonatomic) IBOutlet UIButton *delPicBtn;//第一个删除图片按钮
@property (weak, nonatomic) IBOutlet UIButton *picTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *delTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *picThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *delThreeBtn;

@property (weak, nonatomic) IBOutlet UILabel *picDescripL;//上传描述
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;//选择位置
@property (nonatomic) CLLocationCoordinate2D locationPt;
@property (weak, nonatomic) IBOutlet UITextField *totalNumTF;//投放总份数

@property (weak, nonatomic) IBOutlet UITextField *rewardTF;//答题奖励



@property (weak, nonatomic) IBOutlet UIView *quesAlertView;
@property (strong, nonatomic) IBOutlet UIView *questionView;//问题背景

@property (weak, nonatomic) IBOutlet UILabel *questionNumL;//第几个问题
@property (weak, nonatomic) IBOutlet UITextView *questionTView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderL;
@property (weak, nonatomic) IBOutlet UITextField *answerATF;
@property (weak, nonatomic) IBOutlet UITextField *answerBTF;
@property (weak, nonatomic) IBOutlet UITextField *answerCTF;
@property (weak, nonatomic) IBOutlet UIButton *answerAButton;
@property (weak, nonatomic) IBOutlet UIButton *answerBbutton;
@property (weak, nonatomic) IBOutlet UIButton *answerCButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midHeightContraint;


@property (nonatomic, strong) NSMutableArray *cataArray;    //分类数组
@property (nonatomic, strong) NSMutableDictionary *cataDict;//分类字典
@property (nonatomic, strong) SHCatagoryView *catagoryView;
@property (nonatomic, copy) NSString *catagoryString;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyL;


/**
 *  传参
 */
//正确答案勾选button
@property (nonatomic, strong) UIButton *tempAnsSelectBtn;
//问题按钮
@property (nonatomic, strong) UIButton *tempQuesButton;

//第一个问题、答案、正确答案
@property (nonatomic, copy) NSString *questionOne;//
@property (nonatomic, copy) NSString *answerOneA;
@property (nonatomic, copy) NSString *answerOneB;
@property (nonatomic, copy) NSString *answerOneC;
@property (nonatomic, copy) NSString *questionOneAnswer;//

//第二个问题、答案、正确答案
@property (nonatomic, copy) NSString *questionTwo;//
@property (nonatomic, copy) NSString *answerTwoA;
@property (nonatomic, copy) NSString *answerTwoB;
@property (nonatomic, copy) NSString *answerTwoC;
@property (nonatomic, copy) NSString *questionTwoAnswer;//

//第三个问题、答案、正确答案
@property (nonatomic, copy) NSString *questionThree;//
@property (nonatomic, copy) NSString *answerThreeA;
@property (nonatomic, copy) NSString *answerThreeB;
@property (nonatomic, copy) NSString *answerThreeC;
@property (nonatomic, copy) NSString *questionThreeAnswer;//


@property (nonatomic, strong) NSMutableArray *imageUrlArr;//选中的图片数组
@property (nonatomic, strong) NSMutableArray *localImgArray;//留存的本地图片UIImage
@property (nonatomic, strong) NSMutableArray *urlImgArray;//图片url数组

@end

@implementation SHRAdverViewController



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
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    _questionView.frame = CGRectMake(0, 0, SHScreenW, SHScreenH);
    _questionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    UITapGestureRecognizer *tapRecognizerWeibo=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizerWeibo.delegate = self;
    _questionView.userInteractionEnabled = YES;
    tapRecognizerWeibo.numberOfTapsRequired = 1;
    tapRecognizerWeibo.numberOfTouchesRequired = 1;
    [_questionView addGestureRecognizer:tapRecognizerWeibo];
    
    //[self loadCatagoaryData];
    
    
}

- (void) initBaseInfo
{
    self.navigationItem.title = @"发布答题";
    
    [_catagoryButton setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_mainTitleTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    _placeholderL.textColor = SHColorFromHex(0x9a9a9a);
    _picDescripL.textColor = SHColorFromHex(0x9a9a9a);
    [_quesOneBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_quesOneBtn setBackgroundColor:SHColorFromHex(0xf2f2f2)];
    [_quesTwoBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_quesTwoBtn setBackgroundColor:SHColorFromHex(0xf2f2f2)];
    [_quesThreeBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_quesThreeBtn setBackgroundColor:SHColorFromHex(0xf2f2f2)];
    _picDescripL.textColor = SHColorFromHex(0x9a9a9a);
    [_locationBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    _placeHolderL.textColor = SHColorFromHex(0x9a9a9a);
    [_totalNumTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_answerATF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_answerBTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_answerCTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_rewardTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    
    _rewardTF.keyboardType = UIKeyboardTypeDecimalPad;
    _rewardTF.delegate = self;
    
    _quesAlertView.layer.cornerRadius = 10;
    _quesAlertView.clipsToBounds = YES;
    _payButton.layer.cornerRadius = 10;
    _payButton.clipsToBounds = YES;
    
    _picTwoBtn.hidden = YES;
    _delPicBtn.hidden = YES;
    _delTwoBtn.hidden = YES;
    _picThreeBtn.hidden = YES;
    _delThreeBtn.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scrollViewBG.contentSize = CGSizeMake(SHScreenW, _scrollViewBG.height + 310);
    });
    
    _cataArray = [NSMutableArray array];
    _cataDict = [NSMutableDictionary dictionary];
    
    _questionOneAnswer = @"";
    _questionTwoAnswer = @"";
    _questionThreeAnswer = @"";
    
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影的透明度
    _bottomView.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    _bottomView.layer.shadowRadius = 4.0f;
    _bottomView.layer.shadowOffset = CGSizeMake(5,5);
    
    _imageUrlArr = [NSMutableArray array];
    _localImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    _urlImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
}

/**
 *  加载分类数据
 */
- (void)loadCatagoaryData
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaServCatUrl params:nil success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (code == 0) {
            NSArray *array = [SHRelCataModel mj_objectArrayWithKeyValuesArray:JSON[@"categories"]];
            [_cataArray addObjectsFromArray:array];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (SHRelCataModel *model in array) {
                NSMutableArray *secondArr = [NSMutableArray array];
                for (NSDictionary *dictionary in model.childList) {
                    [secondArr addObject:dictionary[@"name"]];
                }
                [dic setValue:secondArr ? secondArr : nil forKey:model.name];
            }
            _cataDict = dic;
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  选择分类按钮
 */
- (IBAction)catagoryButtonClick:(UIButton *)sender {
    [self removeAllKeyboard];
    _catagoryView = [[SHCatagoryView alloc] initWithArray:@[@"商业",@"个人",@"其他"]];
    _catagoryView.type = SHAdvertisementType;
    _catagoryView.catagoarySelectBlock = ^(NSString *leftString, NSString *rightString, NSString *string) {
        ////SHLog(@"%@_%@_%@", leftString, rightString, string)
        [_catagoryButton setTitle:string forState:UIControlStateNormal];
        [_catagoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:_catagoryView];
    
}

/**
 *  辐射范围选择
 */
- (IBAction)fusheButtonClick:(UIButton *)sender {
    [self removeAllKeyboard];
    _catagoryView = [[SHCatagoryView alloc] initWithArray:@[@"10",@"100",@"1000",@"5000"]];
    _catagoryView.type = SHAdvertisementType;
    _catagoryView.catagoarySelectBlock = ^(NSString *leftString, NSString *rightString, NSString *string) {
        //SHLog(@"%@_%@_%@", leftString, rightString, string)
        [_fusheButton setTitle:string forState:UIControlStateNormal];
        [_fusheButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:_catagoryView];
}





/**
 *  问题按钮
 */
- (IBAction)questionButtonClick:(UIButton *)sender {
    
    if ([self dealWithQuestionButtonWithButton:sender]) {
        if (sender.tag == 100) {
            _questionNumL.text = @"问题1:";
        } else if (sender.tag == 110) {
            _questionNumL.text = @"问题2:";
        } else if (sender.tag == 120) {
            _questionNumL.text = @"问题3:";
        }
        _tempQuesButton = sender;
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        _quesAlertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
        [UIView animateWithDuration: 0.5 animations: ^{
            //获取当前UIWindow并添加一个视图
            UIApplication *app = [UIApplication sharedApplication];
            [app.keyWindow addSubview:_questionView];
            [_questionTView becomeFirstResponder];
            _placeHolderL.alpha = 0;
            _quesAlertView.transform = transform;
            
        } completion: nil];
        
    }
    
    
}

/**
 *  正确答案按钮
 */
- (IBAction)correctSelectButtonClick:(UIButton *)sender {
    if (_tempAnsSelectBtn == sender) {
        
    } else {
        [_tempAnsSelectBtn setImage:[UIImage imageNamed:@"payNoSelected"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];
        _tempAnsSelectBtn = sender;
        if (_tempQuesButton.tag == 100) {
            if (sender.tag == 200) {
                _questionOneAnswer = @"A";
            } else if (sender.tag == 210) {
                _questionOneAnswer = @"B";
            } else if (sender.tag == 220) {
                _questionOneAnswer = @"C";
            }
        } else if (_tempQuesButton.tag == 110) {
            if (sender.tag == 200) {
                _questionTwoAnswer = @"A";
            } else if (sender.tag == 210) {
                _questionTwoAnswer = @"B";
            } else if (sender.tag == 220) {
                _questionTwoAnswer = @"C";
            }
        } else if (_tempQuesButton.tag == 120) {
            if (sender.tag == 200) {
                _questionThreeAnswer = @"A";
            } else if (sender.tag == 210) {
                _questionThreeAnswer = @"B";
            } else if (sender.tag == 220) {
                _questionThreeAnswer = @"C";
            }
        }
    }
    
    
}

#pragma mark - 选取相片
//选择图片
- (IBAction)pictureButtonClick:(UIButton *)sender {
    //SHLog(@"%d", sender.tag)
    [self selectPictureWithButton:sender];
}

//删除图片
- (IBAction)deleteButtonClick:(UIButton *)sender {
    if (sender.tag == 11) {
        ////SHLog(@"%@", _localImgArray)
        ////SHLog(@"%@", _urlImgArray)
        //第一个删除按钮（第一个删除按钮出现的时候，最少显示一张图片）
        if (![_localImgArray[0] isEqualToString:@""] && [_localImgArray[1] isEqualToString:@""] && [_localImgArray[2] isEqualToString:@""]) {
            //有一张图片，剩余两个是空的
            ////SHLog(@"只有一张图片")
            _picTwoBtn.hidden = YES;
            _delPicBtn.hidden = YES;
            [_localImgArray removeObjectAtIndex:0];
            [_urlImgArray removeObjectAtIndex:0];
            [_localImgArray addObject:@""];
            [_urlImgArray addObject:@""];
            [_picOneBtn setBackgroundImage:[UIImage imageNamed:@"pictureBG"] forState:UIControlStateNormal];
            
        } else if (![_localImgArray[0] isEqualToString:@""] && ![_localImgArray[1] isEqualToString:@""] && [_localImgArray[2] isEqualToString:@""]) {
            //有两张图片，最后一张是空的
            ////SHLog(@"有两张图片")
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
            ////SHLog(@"有三张图片")
            _delThreeBtn.hidden = YES;
            [_localImgArray removeObjectAtIndex:0];
            [_urlImgArray removeObjectAtIndex:0];
            [_localImgArray addObject:@""];
            [_urlImgArray addObject:@""];
            [_picOneBtn setBackgroundImage:_urlImgArray[0] forState:UIControlStateNormal];
            [_picTwoBtn setBackgroundImage:_urlImgArray[1] forState:UIControlStateNormal];
            [_picThreeBtn setBackgroundImage:[UIImage imageNamed:@"pictureBG"] forState:UIControlStateNormal];
            
        }
        ////SHLog(@"%@", _localImgArray)
        ////SHLog(@"%@", _urlImgArray)
    } else if (sender.tag == 21) {
        //第二个删除按钮
        //判断数组包含 @"" 的位数
        //一种是三张图片
        ////SHLog(@"%@", _localImgArray)
        //一种是两张图片
        if ([_localImgArray[2] isEqualToString:@""] && ![_localImgArray[1] isEqualToString:@""]) {
            ////SHLog(@"第二张有图片，但是第三张没有图片")
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
            ////SHLog(@"三张都不是空的")
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
        //SHLog(@"%@", photos)
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
        //SHLog(@"第一个按钮")
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
                    
                    ////SHLog(@"%@", weakSelf.imageUrlArr)
                    // //SHLog(@"%@", _localImgArray)
                } else {
                    [MBProgressHUD showError:@"图片上传失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"图片上传失败"];
            }];
            
            
        }
    } else if (button.tag == 20) {
        //SHLog(@"第二个按钮")
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
        //SHLog(@"第三个按钮")
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

/**
 *  定位
 */
- (IBAction)locationBtnClick:(UIButton *)sender {
    SHWeakSelf
    if (!AppDelegate.isLocationServiceOpen) {
        [self openLocationFunction];
    } else {
        SHLocationViewController *vc = [[SHLocationViewController alloc] init];
        vc.addressBlock = ^(NSString *address, NSString *name, CLLocationCoordinate2D pt, NSString *city) {
            //SHLog(@"%@-%@_%3.5f_%3.5f", address,name,pt.latitude,pt.longitude)
            [_locationBtn setTitle:[NSString stringWithFormat:@"%@%@", address, name] forState:UIControlStateNormal];
            [_locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _locationPt = pt;
            [weakSelf uploadUserLocationWithLat:_locationPt.latitude andLng:_locationPt.longitude];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

//设置--开启定位服务
- (void)openLocationFunction
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
    {
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"打开定位开关提供更优质的服务" message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:sureAction];
    [alertView addAction:cancelAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
}

- (void)uploadUserLocationWithLat:(double)lat andLng:(double)lng
{
    NSDictionary *dic = @{
                          @"lng":@(lng),
                          @"lat":@(lat)
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHLocationUrl params:dic success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%d", code)
        if (code == 0) {
            SHLog(@"发广告上传定位成功")
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  取消
 */
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [UIView animateWithDuration: 0.5 animations: ^{
        [self dealWithQuestionView];
        [_questionView removeFromSuperview];
    } completion: nil];
    
}
/**
 *  确定
 */
- (IBAction)sureButtonClick:(UIButton *)sender {
    
    
    //添加问题的时候判断
    if ([self judgeQuestionView]) {
        if (_tempQuesButton.tag == 100) {
            [_quesOneBtn setTitle:_questionTView.text forState:UIControlStateNormal];
            [_quesOneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _correctAnswerL.text = [NSString stringWithFormat:@"正确答案：1.%@", _questionOneAnswer];
            
            _questionOne = _questionTView.text;
            _answerOneA = _answerATF.text;
            _answerOneB = _answerBTF.text;
            _answerOneC = _answerCTF.text;
            
        } else if (_tempQuesButton.tag == 110) {
            [_quesTwoBtn setTitle:_questionTView.text forState:UIControlStateNormal];
            [_quesTwoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _correctAnswerL.text = [NSString stringWithFormat:@"%@,2.%@", _correctAnswerL.text, _questionTwoAnswer];
            
            _questionTwo = _questionTView.text;
            _answerTwoA = _answerATF.text;
            _answerTwoB = _answerBTF.text;
            _answerTwoC = _answerCTF.text;
            
        } else if (_tempQuesButton.tag == 120) {
            [_quesThreeBtn setTitle:_questionTView.text forState:UIControlStateNormal];
            [_quesThreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _correctAnswerL.text = [NSString stringWithFormat:@"%@,3.%@", _correctAnswerL.text, _questionThreeAnswer];

            _questionThree = _questionTView.text;
            _answerThreeA = _answerATF.text;
            _answerThreeB = _answerBTF.text;
            _answerThreeC = _answerCTF.text;
            
        }
        
        
        [UIView animateWithDuration: 0.5 animations: ^{
            //消失之前格式化问题和答案
            [self dealWithQuestionView];
            [_questionView removeFromSuperview];
        } completion: nil];
    }
    
}

#pragma mark - 支付按钮
- (IBAction)payButonClick:(UIButton *)sender {
    //SHLog(@"%@", _localImgArray)
    if ([self dealWithAllParagrams]) {
        //处理下单--支付页面
        [self dealWithAllParagramsToOrder];
    }
}

//下单
- (void)dealWithAllParagramsToOrder
{
    SHWeakSelf
    NSString *imgUrl = [NSString stringWithFormat:@"%@,%@,%@", _localImgArray[0], _localImgArray[1], _localImgArray[2]];
    //答案请用|分割 如： 可以|不可以|A （选项1|选项2|选项3|正确答案）
    NSString *answer1 = [NSString stringWithFormat:@"%@|%@|%@|%@", _answerOneA, _answerOneB, _answerOneC, _questionOneAnswer];
    NSString *answer2 = [NSString stringWithFormat:@"%@|%@|%@|%@", _answerTwoA, _answerTwoB, _answerTwoC, _questionTwoAnswer];
//    NSString *answer3 = [NSString stringWithFormat:@"%@|%@|%@|%@", _answerThreeA, _answerThreeB, _answerThreeC, _questionThreeAnswer];
//    @"answer3":answer3,
//    @"problem3":_questionThree,

    NSDictionary *dic = @{
                          @"category":_catagoryButton.currentTitle,
                          @"title":_mainTitleTF.text,
                          @"profit":_rewardTF.text,
                          @"deliveryNum":_totalNumTF.text,
                          @"pics":imgUrl,
                          @"adRadius":_fusheButton.currentTitle,
                          @"lng":@(_locationPt.longitude),
                          @"lat":@(_locationPt.latitude),
                          @"problem1":_questionOne,
                          @"problem2":_questionTwo,
                          @"answer1":answer1,
                          @"answer2":answer2,
                          @"introduce":_descriptionTV.text
                          };
    SHLog(@"%@", dic)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaseAdverUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"信息填写成功" withSecond:2.0];
            SHOrderModel *orderModel = [SHOrderModel mj_objectWithKeyValues:JSON[@"order"]];
            [weakSelf goToPayViewController:orderModel];
        } else {
            [MBProgressHUD showMBPAlertView:@"数据请求出错，请稍后再试" withSecond:2.0];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)goToPayViewController:(SHOrderModel *)orderModel
{
    SHPayOrderVController *vc = [[SHPayOrderVController alloc] init];
    vc.orderNo = orderModel.orderNo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 各种参数情况判断
/**
 *  问题view消失的手势
 */
-(void)handleTap:(UITapGestureRecognizer *)recognizer
{
    
}


/**
 *  处理问题按钮
 *  问题按钮是依次相应的
 */
- (BOOL)dealWithQuestionButtonWithButton:(UIButton *)button
{
    //通过添加问题之后的正确答案进行判断
    if (button.tag == 110) {
        ////SHLog(@"问题二按钮")
        if ([_questionOneAnswer isEqualToString:@""]) {
            [MBProgressHUD showMBPAlertView:@"请优先填写问题1" withSecond:2.0];
            return NO;
        }
    } else if (button.tag == 120) {
        if ([_questionOneAnswer isEqualToString:@""]) {
            [MBProgressHUD showMBPAlertView:@"请优先填写问题1" withSecond:2.0];
            return NO;
        }
        if ([_questionTwoAnswer isEqualToString:@""]) {
            [MBProgressHUD showMBPAlertView:@"请优先填写问题2" withSecond:2.0];
            return NO;
        }
    }
    
    return YES;
}



/**
 *  问题的内容判断
 */
- (BOOL)judgeQuestionView
{
    if ([NSString isEmpty:_questionTView.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入问题" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_answerATF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入A的答案" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_answerBTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入B的答案" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_answerCTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入C的答案" withSecond:2.0];
        return NO;
    }
    
    //勾选答案
    if ([_questionOneAnswer isEqualToString:@""]) {
        [MBProgressHUD showMBPAlertView:@"请勾选正确答案" withSecond:2.0];
        return NO;
    }
    if (_tempQuesButton.tag == 110) {
        if ([_questionTwoAnswer isEqualToString:@""]) {
            [MBProgressHUD showMBPAlertView:@"请勾选正确答案" withSecond:2.0];
            return NO;
        }
    }
    if (_tempQuesButton.tag == 120) {
        if ([_questionThreeAnswer isEqualToString:@""]) {
            [MBProgressHUD showMBPAlertView:@"请勾选正确答案" withSecond:2.0];
            return NO;
        }
    }
    
    
    return YES;
}

/**
 *  每次弹出问题view，置空
 */
- (void)dealWithQuestionView
{
    _questionTView.text = @"";
    _answerATF.text = @"";
    _answerBTF.text = @"";
    _answerCTF.text = @"";
    
    _tempAnsSelectBtn = nil;
    [_answerAButton setImage:[UIImage imageNamed:@"payNoSelected"] forState:UIControlStateNormal];
    [_answerBbutton setImage:[UIImage imageNamed:@"payNoSelected"] forState:UIControlStateNormal];
    [_answerCButton setImage:[UIImage imageNamed:@"payNoSelected"] forState:UIControlStateNormal];
    
}

/**
 *  所有参数判断
 */
- (BOOL)dealWithAllParagrams
{
    if ([_catagoryButton.currentTitle isEqualToString:@"请选择分类"]) {
        [MBProgressHUD showMBPAlertView:@"请选择分类" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_mainTitleTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入主题" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_descriptionTV.text]) {
        [MBProgressHUD showMBPAlertView:@"请添加描述" withSecond:2.0];
        return NO;
    }
    if ([_fusheButton.currentTitle isEqualToString:@"请选择辐射范围(单位：km)"]) {
        [MBProgressHUD showMBPAlertView:@"请选择辐射范围" withSecond:2.0];
        return NO;
    }
    if ([_questionOneAnswer isEqualToString:@""]) {
        [MBProgressHUD showMBPAlertView:@"请添加问题1" withSecond:2.0];
        return NO;
    }
    if ([_questionTwoAnswer isEqualToString:@""]) {
        [MBProgressHUD showMBPAlertView:@"请添加问题2" withSecond:2.0];
        return NO;
    }
//    if ([_questionThreeAnswer isEqualToString:@""]) {
//        [MBProgressHUD showMBPAlertView:@"请添加问题3" withSecond:2.0];
//        return NO;
//    }
    //添加图片
    for (NSInteger i = 0; i < _localImgArray.count; i++) {
        if ([_localImgArray[i] isEqualToString:@""]) {
            NSString *string = [NSString stringWithFormat:@"请选择第%ld张图片", (long)i];
            [MBProgressHUD showMBPAlertView:string withSecond:2.0];
            return NO;
        }
    }
    
    if ([_locationBtn.currentTitle isEqualToString:@"请选择您的位置"]) {
        [MBProgressHUD showMBPAlertView:@"请选择您的位置" withSecond:2.0];
        return NO;
    }
    
    if ([NSString isEmpty:_totalNumTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入投放总份数" withSecond:2.0];
        return NO;
    }
    if ([[_totalNumTF.text substringToIndex:1] isEqualToString:@"0"]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的投放总份数" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_rewardTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入每份答题奖励" withSecond:2.0];
        return NO;
    }
    
    return YES;
}



#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_quesAlertView]) {
        return NO;
    }
    
    return YES;
    
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
    if (textView == _descriptionTV) {
        _placeholderL.alpha = 0;
    } else if (textView == _questionTView) {
        _placeHolderL.alpha = 0;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView == _descriptionTV) {
        if (textView.text.length == 0) {
            _placeholderL.alpha = 1;
        }
    } else if (textView == _questionTView) {
        if (textView.text.length == 0) {
            _placeHolderL.alpha = 1;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextView *)textView
{
    SHLog(@"%@", textView.text)
    if (![NSString isEmpty:_totalNumTF.text] && ![NSString isEmpty:_rewardTF.text]) {
        _totalMoneyL.text = [NSString stringWithFormat:@"￥%.2f元", [_totalNumTF.text integerValue] * [_rewardTF.text doubleValue]];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _rewardTF) {
        NSString *text             = _rewardTF.text;
        NSString *decimalSeperator = @".";
        NSCharacterSet *charSet    = nil;
        NSString *numberChars      = @"0123456789";
        
        if ([string isEqualToString:decimalSeperator] && [text length] == 0) {
            return NO;
        }
        
        NSRange decimalRange = [text rangeOfString:decimalSeperator];
        BOOL isDecimalNumber = (decimalRange.location != NSNotFound);
        if (isDecimalNumber) {
            charSet = [NSCharacterSet characterSetWithCharactersInString:numberChars];
            if ([string rangeOfString:decimalSeperator].location != NSNotFound) {
                return NO;
            }
        }
        else {
            numberChars = [numberChars stringByAppendingString:decimalSeperator];
            charSet = [NSCharacterSet characterSetWithCharactersInString:numberChars];
        }
        
        NSCharacterSet *invertedCharSet = [charSet invertedSet];
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:invertedCharSet];
        text = [text stringByReplacingCharactersInRange:range withString:trimmedString];
        
        if (isDecimalNumber) {
            NSArray *arr = [text componentsSeparatedByString:decimalSeperator];
            if ([arr count] == 2) {
                if ([arr[1] length] > 2) {
                    return NO;
                }
            }
        }
        
        textField.text = text;
    } else {
        return YES;
    }
    return NO;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    SHLog(@"%@", textField.text)
}



/**
 *  移除所有键盘响应
 */
- (void)removeAllKeyboard
{
    [_descriptionTV resignFirstResponder];
    [_mainTitleTF resignFirstResponder];
    [_totalNumTF resignFirstResponder];
    [_rewardTF resignFirstResponder];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
