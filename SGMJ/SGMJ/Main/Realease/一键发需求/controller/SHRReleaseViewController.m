//
//  SHRReleaseViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/11.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHRReleaseViewController.h"
#import "SHRelCataModel.h"
#import "SHCatagoryView.h"
#import "TZImagePickerController.h"
#import "ImageUtil.h"
#import "SHLocationViewController.h"
#import "SH_DateTimePickerView.h"


#import "SH_TestViewController.h"


@interface SHRReleaseViewController () <UITextViewDelegate,TZImagePickerControllerDelegate, SHDateTimePickerViewDelegate, UITextFieldDelegate> {
    CLLocationCoordinate2D _startPt;
    CLLocationCoordinate2D _endPt;
}

@property (nonatomic, strong) SH_DateTimePickerView *datePickView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBG;

@property (weak, nonatomic) IBOutlet UIButton *catagoryButton;//分类
@property (weak, nonatomic) IBOutlet UITextField *titleTF;//名称

@property (weak, nonatomic) IBOutlet UIButton *picOneBtn;//选择图片
@property (weak, nonatomic) IBOutlet UIButton *delPicBtn;//删除图片
@property (weak, nonatomic) IBOutlet UIButton *picTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *delTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *picThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *delThreeBtn;

@property (weak, nonatomic) IBOutlet UITextField *danweiTF;//单位
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;//图片上传描述



@property (weak, nonatomic) IBOutlet UISwitch *noDisturbSwitch;//免打扰开关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noDisturbConstraint;//免打扰约束
@property (weak, nonatomic) IBOutlet UIView *noDisturbView;//免打扰时间view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finalAddressContraint;//终点位置view约束
@property (weak, nonatomic) IBOutlet UIView *finalAddressView;//终点位置view
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;//是否开启追踪switch
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLocationContraint;//起始位置约束view
@property (weak, nonatomic) IBOutlet UIView *startLocationView;//起始位置的view



@property (weak, nonatomic) IBOutlet UITextField *jiageTF;//价格
@property (weak, nonatomic) IBOutlet UILabel *nodisturbL;//免打扰说明
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;//开始时间
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;//结束时间
@property (nonatomic, strong) UIButton *tempTimeButton;   //时间按钮
@property (weak, nonatomic) IBOutlet UILabel *locationL;//定位追踪说明

@property (weak, nonatomic) IBOutlet UIButton *startLocationBtn;//起始位置
@property (weak, nonatomic) IBOutlet UITextView *startDetailAddTV;//起始详细地址textView
@property (weak, nonatomic) IBOutlet UILabel *startDetailPlaceHolderL;//起始textView的占位符

@property (weak, nonatomic) IBOutlet UIButton *endLocationBtn;//终点位置
@property (weak, nonatomic) IBOutlet UITextView *endDetailAddTV;//终点详细位置textView
@property (weak, nonatomic) IBOutlet UILabel *endDetailPHL;//终点textView占位符Label

@property (weak, nonatomic) IBOutlet UILabel *phoneL;//电话号码
@property (weak, nonatomic) IBOutlet UITextView *discriptionTV;//描述textView
@property (weak, nonatomic) IBOutlet UILabel *descriptionPlaceL;//描述占位符




@property (weak, nonatomic) IBOutlet UIButton *releaseButton;//确认发布


@property (nonatomic, strong) SHCatagoryView *catagoryView;
@property (nonatomic, strong) NSMutableDictionary *cataDict;//分类字典
@property (nonatomic, strong) NSMutableArray *cataArray;    //分类数组
@property (nonatomic, copy) NSString *catagoaryLeftString;  //主分类选择的字符串
@property (nonatomic, copy) NSString *catagoaryRightString; //次分类字符串
@property (nonatomic, strong) NSMutableArray *imageUrlArr;//选中的图片数组
@property (nonatomic, strong) NSMutableArray *localImgArray;//留存的本地图片UIImage
@property (nonatomic, strong) NSMutableArray *urlImgArray;//图片url数组

@property (nonatomic, strong) NSString *city;



@end

@implementation SHRReleaseViewController

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
    
    [self loadCatagoaryData];
    
    _city = SH_AppDelegate.personInfo.city;
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"发布技能服务";
    
    SHLog(@"%@", SH_AppDelegate.personInfo.city)
    
    _scrollViewBG.contentSize = CGSizeMake(SHScreenW, 1000);
    
    _cataDict = [NSMutableDictionary dictionary];
    _cataArray = [NSMutableArray array];
    _imageUrlArr = [NSMutableArray array];
    _localImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    _urlImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    _delPicBtn.hidden = YES;
    _picTwoBtn.hidden = YES;
    _delTwoBtn.hidden = YES;
    _picThreeBtn.hidden = YES;
    _delThreeBtn.hidden = YES;
    [_titleTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_danweiTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_jiageTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    _descriptionL.textColor = SHColorFromHex(0x9a9a9a);
    _startDetailPlaceHolderL.textColor = SHColorFromHex(0x9a9a9a);
    _endDetailPHL.textColor = SHColorFromHex(0x9a9a9a);
    _nodisturbL.textColor = SHColorFromHex(0x9a9a9a);
    _locationL.textColor = SHColorFromHex(0x9a9a9a);
    _descriptionPlaceL.textColor = SHColorFromHex(0x9a9a9a);
    [_catagoryButton setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_startTimeBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_endTimeBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_startLocationBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    [_endLocationBtn setTitleColor:SHColorFromHex(0x9a9a9a) forState:UIControlStateNormal];
    
    _releaseButton.layer.cornerRadius = _releaseButton.height / 2;
    _releaseButton.clipsToBounds = YES;
    
    //显示scrollview高度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scrollViewBG.contentSize = CGSizeMake(SHScreenW, _scrollViewBG.height + 150 + 90);
    });
    _finalAddressContraint.constant = 0;
    _finalAddressView.hidden = YES;
    
    [_locationSwitch setOn:YES];
    _startLocationView.hidden = YES;
    
    [SH_AppDelegate openLocationTimer];
    
    _startLocationContraint.constant = -135;
    
    
    _phoneL.text = SH_AppDelegate.personInfo.mobile;
    _jiageTF.keyboardType = UIKeyboardTypeDecimalPad;
    _jiageTF.delegate = self;
    
}

/**
 *  加载分类数据
 */
- (void)loadCatagoaryData
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaServCatUrl params:nil success:^(id JSON, int code, NSString *msg) {
//        SHLog(@"%d", code)
        //SHLog(@"%@", JSON)
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

#pragma mark - action
//分类
- (IBAction)catagoryButtonClick:(UIButton *)sender {
    SHWeakSelf
    if (_cataDict) {
        _catagoryView = [[SHCatagoryView alloc] initWithDict:_cataDict];
        _catagoryView.catagoarySelectBlock = ^(NSString *leftString, NSString *rightString,NSString *string) {
            SHLog(@"%@,%@,%@", leftString,rightString,string)
            weakSelf.catagoaryLeftString = leftString;
            weakSelf.catagoaryRightString = rightString;
            [weakSelf.catagoryButton setTitle:string forState:UIControlStateNormal];
            [weakSelf.catagoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [weakSelf showFinalAddressViewWithString:leftString];
        };
        [self.view addSubview:_catagoryView];
    } else {
        [self loadCatagoaryData];
    }
    
    
}

//根据分类筛选终点位置view是否显示
- (void)showFinalAddressViewWithString:(NSString *)leftS
{
    for (SHRelCataModel *model in _cataArray) {
        if ([model.name isEqualToString:leftS]) {
            if (model.type == 3) {
                //显示终点地址view
                _finalAddressView.hidden = NO;
                _finalAddressContraint.constant = 135;
                [UIView animateWithDuration:1 animations:^{
                    _scrollViewBG.contentSize = CGSizeMake(SHScreenW, _scrollViewBG.height + 390 + 90);
                } completion:nil];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _scrollViewBG.contentSize = CGSizeMake(SHScreenW, _scrollViewBG.height + 255 + 90);
                });
                _finalAddressContraint.constant = 0;
                _finalAddressView.hidden = YES;
            }
        }
    }
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

//是否开启免打扰--选择时间段
- (IBAction)switchClick:(UISwitch *)sender {
    
    if (_noDisturbSwitch.isOn) {
        SHLog(@"打开")
        _noDisturbConstraint.constant = 91;
        _noDisturbView.hidden = NO;
    } else {
        SHLog(@"关闭")
        _noDisturbConstraint.constant = 0;
        _noDisturbView.hidden = YES;
    }
    
}

//初始-终点时间按钮
- (IBAction)timeButtonClick:(UIButton *)sender {
    _tempTimeButton = sender;
    SH_DateTimePickerView *pickerView = [[SH_DateTimePickerView alloc] init];
    self.datePickView = pickerView;
    pickerView.titleLabel.text = @"时间";
    pickerView.dateDelegate = self;
    pickerView.pickerViewMode = SHDatePickerViewHM;
    [self.view addSubview:pickerView];
    [pickerView showDateTimePickerView];

}


//是否开启追踪
- (IBAction)startLocationSwitch:(UISwitch *)sender {
    //开启的时候隐藏起始位置
    //关闭的时候显示起始位置
    if (_locationSwitch.isOn) {
        _startLocationView.hidden = YES;
        [SH_AppDelegate openLocationTimer];
        _startLocationContraint.constant = -135;
    } else {
        _startLocationView.hidden = NO;
        [SH_AppDelegate closeLocationTimer];
        _startLocationContraint.constant = 0;
    }
    
}

//出发定位按钮
- (IBAction)locationButtonClick:(UIButton *)sender {
    SHWeakSelf
    
    if (!AppDelegate.isLocationServiceOpen) {
        
        [self openLocationFunction];
        
    } else {
        SHLocationViewController *vc = [[SHLocationViewController alloc] init];
        vc.addressBlock = ^(NSString *address, NSString *name, CLLocationCoordinate2D pt, NSString *city) {
            SHLog(@"%@-%@_%3.5f_%3.5f", address,name,pt.latitude,pt.longitude)
            [weakSelf.startLocationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [weakSelf.startLocationBtn setTitle:[NSString stringWithFormat:@"%@%@", address,name] forState:UIControlStateNormal];
            _city = city;
            _startPt = pt;
            [weakSelf uploadUserLocationWithLat:_startPt.latitude andLng:_startPt.longitude];
        };
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    
}

//终点位置定位
- (IBAction)endLocationButtonClick:(UIButton *)sender {
    SHWeakSelf
    
    if (!AppDelegate.isLocationServiceOpen) {
        [self openLocationFunction];
        
    } else {
        SHLocationViewController *vc = [[SHLocationViewController alloc] init];
        vc.addressBlock = ^(NSString *address, NSString *name, CLLocationCoordinate2D pt, NSString *city) {
            SHLog(@"%@-%@_%3.5f_%3.5f", address,name,pt.latitude,pt.longitude)
            [weakSelf.endLocationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [weakSelf.endLocationBtn setTitle:[NSString stringWithFormat:@"%@%@", address,name] forState:UIControlStateNormal];
            _city = city;
            _endPt = pt;
            [weakSelf uploadUserLocationWithLat:_endPt.latitude andLng:_endPt.longitude];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

//开启定位服务
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
            SHLog(@"服务技能上传经纬度成功")
        }
    } failure:^(NSError *error) {
        
    }];
}

//确认发布
- (IBAction)makesureButtonClick:(UIButton *)sender {
    
   SHLog(@"%@", _localImgArray)
    if ([self judgeEveryParamIsPromiced]) {
        if (!AppDelegate.isLocationServiceOpen) {
            [self openLocationFunction];
            return;
        }
        NSDictionary *dic = nil;
        //_jiageTF.text
        NSString *imgUrl = [NSString stringWithFormat:@"%@,%@,%@", _localImgArray[0], _localImgArray[1], _localImgArray[2]];
        
        for (SHRelCataModel *model in _cataArray) {
            if ([model.name isEqualToString:_catagoaryLeftString]) {
                NSInteger rightID = 0;
                for (NSDictionary *dictionary in model.childList) {
                    if ([dictionary[@"name"] isEqualToString:_catagoaryRightString]) {
                        rightID = [dictionary[@"id"] integerValue];
                    }
                }
                
                // isAuto 0开启（指定服务时间） 1 关闭
                // isOpen 0开启 1 关闭(关闭后选择地址定位)
                if (model.type == 3) {//有终点位置的参数
                    if (_noDisturbSwitch.isOn) {//开启免打扰
                        if (_locationSwitch.isOn) {//开启定位
                            NSDictionary *dict = @{
                                                   @"mainCat":model.ID,
                                                   @"subCat":@(rightID),
                                                   @"title":_titleTF.text,
                                                   @"imageList":imgUrl,
                                                   @"phone":_phoneL.text,
                                                   @"price":_jiageTF.text,
                                                   @"unit":_danweiTF.text,
                                                   @"isAuto":@(0),
                                                   @"isOpen":@(0),
                                                   @"description":_discriptionTV.text,
                                                   @"arriveAddress":[NSString stringWithFormat:@"%@%@", _endLocationBtn.currentTitle, _endDetailAddTV.text],
                                                   @"latAr":@(_endPt.latitude),
                                                   @"lonAr":@(_endPt.longitude),
                                                   @"startTime":_startTimeBtn.currentTitle,
                                                   @"endTime":_endTimeBtn.currentTitle,
                                                   @"city":_city ? _city : SH_AppDelegate.personInfo.city
                                                   };
                            dic = dict;
                        } else {
                            NSDictionary *dict = @{
                                                   @"mainCat":model.ID,
                                                   @"subCat":@(rightID),
                                                   @"title":_titleTF.text,
                                                   @"imageList":imgUrl,
                                                   @"phone":_phoneL.text,
                                                   @"price":_jiageTF.text,
                                                   @"unit":_danweiTF.text,
                                                   @"isAuto":@(0),
                                                   @"isOpen":@(1),
                                                   @"description":_discriptionTV.text,
                                                   @"arriveAddress":[NSString stringWithFormat:@"%@%@", _endLocationBtn.currentTitle, _endDetailAddTV.text],
                                                   @"latAr":@(_endPt.latitude),
                                                   @"lonAr":@(_endPt.longitude),
                                                   @"departAddress":[NSString stringWithFormat:@"%@%@", _startLocationBtn.currentTitle, _startDetailAddTV.text],
                                                   @"lat":@(_startPt.latitude),
                                                   @"lon":@(_startPt.longitude),
                                                   @"startTime":_startTimeBtn.currentTitle,
                                                   @"endTime":_endTimeBtn.currentTitle,
                                                   @"city":_city ? _city : SH_AppDelegate.personInfo.city
                                                   };
                            dic = dict;
                        }
                        
                    } else {
                        if (_locationSwitch.isOn) {//开启定位
                            NSDictionary *dict = @{
                                                   @"mainCat":model.ID,
                                                   @"subCat":@(rightID),
                                                   @"title":_titleTF.text,
                                                   @"imageList":imgUrl,
                                                   @"phone":_phoneL.text,
                                                   @"price":_jiageTF.text,
                                                   @"unit":_danweiTF.text,
                                                   @"isAuto":@(1),
                                                   @"isOpen":@(0),
                                                   @"description":_discriptionTV.text,
                                                   @"arriveAddress":[NSString stringWithFormat:@"%@%@", _endLocationBtn.currentTitle, _endDetailAddTV.text],
                                                   @"latAr":@(_endPt.latitude),
                                                   @"lonAr":@(_endPt.longitude),
                                                   @"city":_city ? _city : SH_AppDelegate.personInfo.city
                                                   };
                            dic = dict;
                        } else {
                            NSDictionary *dict = @{
                                                   @"mainCat":model.ID,
                                                   @"subCat":@(rightID),
                                                   @"title":_titleTF.text,
                                                   @"imageList":imgUrl,
                                                   @"phone":_phoneL.text,
                                                   @"price":_jiageTF.text,
                                                   @"unit":_danweiTF.text,
                                                   @"isAuto":@(1),
                                                   @"isOpen":@(1),
                                                   @"description":_discriptionTV.text,
                                                   @"arriveAddress":[NSString stringWithFormat:@"%@%@", _endLocationBtn.currentTitle, _endDetailAddTV.text],
                                                   @"latAr":@(_endPt.latitude),
                                                   @"lonAr":@(_endPt.longitude),
                                                   @"departAddress":[NSString stringWithFormat:@"%@%@", _startLocationBtn.currentTitle, _startDetailAddTV.text],
                                                   @"lat":@(_startPt.latitude),
                                                   @"lon":@(_startPt.longitude),
                                                   @"city":_city ? _city : SH_AppDelegate.personInfo.city
                                                   };
                            dic = dict;
                        }
                    }
                    
                } else {//没有终点位置参数
                    if (_noDisturbSwitch.isOn) {
                        if (_locationSwitch.isOn) {
                            NSDictionary *dict = @{
                                                   @"mainCat":model.ID,
                                                   @"subCat":@(rightID),
                                                   @"title":_titleTF.text,
                                                   @"imageList":imgUrl,
                                                   @"phone":_phoneL.text,
                                                   @"price":_jiageTF.text,
                                                   @"unit":_danweiTF.text,
                                                   @"isAuto":@(0),
                                                   @"isOpen":@(0),
                                                   @"description":_discriptionTV.text,
                                                   @"startTime":_startTimeBtn.currentTitle,
                                                   @"endTime":_endTimeBtn.currentTitle,
                                                   @"city":_city ? _city : SH_AppDelegate.personInfo.city
                                                   };
                            dic = dict;
                        } else {
                            NSDictionary *dict = @{
                                                   @"mainCat":model.ID,
                                                   @"subCat":@(rightID),
                                                   @"title":_titleTF.text,
                                                   @"imageList":imgUrl,
                                                   @"phone":_phoneL.text,
                                                   @"price":_jiageTF.text,
                                                   @"unit":_danweiTF.text,
                                                   @"isAuto":@(0),
                                                   @"isOpen":@(1),
                                                   @"departAddress":[NSString stringWithFormat:@"%@%@", _startLocationBtn.currentTitle, _startDetailAddTV.text],
                                                   @"lat":@(_startPt.latitude),
                                                   @"lon":@(_startPt.longitude),
                                                   @"description":_discriptionTV.text,
                                                   @"startTime":_startTimeBtn.currentTitle,
                                                   @"endTime":_endTimeBtn.currentTitle,
                                                   @"city":_city ? _city : SH_AppDelegate.personInfo.city
                                                   };
                            dic = dict;
                        }
                    } else {
                        if (_locationSwitch.isOn) {
                            NSDictionary *dict = @{
                                                   @"mainCat":model.ID,
                                                   @"subCat":@(rightID),
                                                   @"title":_titleTF.text,
                                                   @"imageList":imgUrl,
                                                   @"phone":_phoneL.text,
                                                   @"price":_jiageTF.text,
                                                   @"unit":_danweiTF.text,
                                                   @"isAuto":@(1),
                                                   @"isOpen":@(0),
                                                   @"description":_discriptionTV.text,
                                                   @"city":_city ? _city : SH_AppDelegate.personInfo.city
                                                   };
                            dic = dict;
                        } else {
                            NSDictionary *dict = @{
                                                   @"mainCat":model.ID,
                                                   @"subCat":@(rightID),
                                                   @"title":_titleTF.text,
                                                   @"imageList":imgUrl,
                                                   @"phone":_phoneL.text,
                                                   @"price":_jiageTF.text,
                                                   @"unit":_danweiTF.text,
                                                   @"isAuto":@(1),
                                                   @"isOpen":@(1),
                                                   @"departAddress":[NSString stringWithFormat:@"%@%@", _startLocationBtn.currentTitle, _startDetailAddTV.text],
                                                   @"lat":@(_startPt.latitude),
                                                   @"lon":@(_startPt.longitude),
                                                   @"description":_discriptionTV.text,
                                                   @"city":_city ? _city : SH_AppDelegate.personInfo.city
                                                   };
                            dic = dict;
                        }
                    }
                    
                }
            }
        }
        
        SHLog(@"%@", dic)
        [self makeSureRequestWithDictionary:dic];
        
    }
    
}

//发送请求方法
- (void)makeSureRequestWithDictionary:(NSDictionary *)dic
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaseServiceUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        if (code == 0) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMBPAlertView:@"发布成功" withSecond:1.0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else if (code == 100) {
            //尊敬的用户！您还未实名认证
            
            
        }
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

//判断每个参数是否为空
- (BOOL)judgeEveryParamIsPromiced
{
    //固定的参数判断
    if ([_catagoryButton.currentTitle isEqualToString:@"请选择分类"]) {
        [MBProgressHUD showMBPAlertView:@"请选择分类" withSecond:1.0];
        return NO;
    }
    if ([NSString isEmpty:_titleTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入名称" withSecond:1.0];
        return NO;
    }
    for (NSInteger i = 0; i < _localImgArray.count; i++) {
        if ([_localImgArray[i] isEqualToString:@""]) {
            [MBProgressHUD showMBPAlertView:@"请上传三张图片" withSecond:1.0];
            return NO;
        }
    }
    if ([NSString isEmpty:_danweiTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入单位" withSecond:1.0];
        return NO;
    }
    if ([NSString isEmpty:_jiageTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入单价" withSecond:1.0];
        return NO;
    }
    
    //是否开启免打扰
    if (_noDisturbSwitch.isOn) {
        //打开
        if ([_startTimeBtn.currentTitle isEqualToString:@"请选择开始时间"]) {
            [MBProgressHUD showMBPAlertView:@"请选择开始时间" withSecond:1.0];
            return NO;
        }
        if ([_endTimeBtn.currentTitle isEqualToString:@"请选择结束时间"]) {
            [MBProgressHUD showMBPAlertView:@"情选择结束时间" withSecond:1.0];
            return NO;
        }
                
        if ([self compareDate:_startTimeBtn.currentTitle withDate:_endTimeBtn.currentTitle] != 1) {
            [MBProgressHUD showMBPAlertView:@"结束日期要延后与开始日期" withSecond:2.0];
            return NO;
        }
        
    }
    
    //类别--判断显示的终点位置
    for (SHRelCataModel *model in _cataArray) {
        if ([model.name isEqualToString:_catagoaryLeftString]) {
            if (model.type == 3) {
                if ([_endLocationBtn.currentTitle isEqualToString:@"请选择终点位置"]) {
                    [MBProgressHUD showMBPAlertView:@"请选择终点位置" withSecond:1.0];
                    return NO;
                }
                if ([NSString isEmpty:_endDetailAddTV.text]) {
                    [MBProgressHUD showMBPAlertView:@"请输入终点详细地址" withSecond:1.0];
                    return NO;
                }
            } else {
                
            }
            
        }
    }
    //是否开启追踪
    if (_locationSwitch.isOn) {
        //开启追踪
        
    } else {
        if ([_startLocationBtn.currentTitle isEqualToString:@"请选择您的位置"]) {
            [MBProgressHUD showMBPAlertView:@"请选择您的出发位置" withSecond:1.0];
            return NO;
        }
        if ([NSString isEmpty:_startDetailAddTV.text]) {
            [MBProgressHUD showMBPAlertView:@"请输入详细地址" withSecond:1.0];
            return NO;
        }
    }
    
    if ([NSString isEmpty:_discriptionTV.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入描述文字" withSecond:1.0];
        return NO;
    }
    
    return YES;
}

- (int)compareDate:(NSString*)date01 withDate:(NSString*)date02
{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setDateFormat:@"HH:mm"];
    NSDate *dt1 = [[NSDate alloc]init];
    NSDate *dt2 = [[NSDate alloc]init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    SHLog(@"%@", dt1)
    SHLog(@"%@", dt2)
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci=-1;
            break;
            //date02=date01
        case NSOrderedSame:
            ci=0;
            break;
            
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
            
    }
    return ci;
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
    //开始编辑
    if (textView == _startDetailAddTV) {
        _startDetailPlaceHolderL.alpha = 0;
    } else if (textView == _endDetailAddTV) {
        _endDetailPHL.alpha = 0;
    } else if (textView == _discriptionTV) {
        _descriptionPlaceL.alpha = 0;
    }
    
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    //将要停止编辑（不是第一响应者时）
    if (textView == _startDetailAddTV) {
        if (textView.text.length == 0) {
            _startDetailPlaceHolderL.alpha = 1;
        }
    } else if (textView == _endDetailAddTV) {
        if (textView.text.length == 0) {
            _endDetailPHL.alpha = 1;
        }
    } else if (textView == _discriptionTV) {
        if (textView.text.length == 0) {
            _descriptionPlaceL.alpha = 1;
        }
    }
    return YES;
}


#pragma mark - SHDateTimePickerViewDelegate
- (void)didClickFinishDateTimePickerView:(NSString *)date {
    SHLog(@"%@", date)
    if (_tempTimeButton.tag == 80) {
        [_startTimeBtn setTitle:date forState:UIControlStateNormal];
        [_startTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else if (_tempTimeButton.tag == 81) {
        [_endTimeBtn setTitle:date forState:UIControlStateNormal];
        [_endTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _jiageTF) {
        NSString *text             = _jiageTF.text;
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
