//
//  SHVerifyIDViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/22.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHVerifyIDViewController.h"
#import "TZImagePickerController.h"
#import "ImageUtil.h"


@interface SHVerifyIDViewController () <TZImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;

@property (weak, nonatomic) IBOutlet UIImageView *forwardImgV;
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UILabel *fordwardL;
@property (weak, nonatomic) IBOutlet UILabel *backL;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, copy) NSString *forwardImgString;//正面身份证url
@property (nonatomic, copy) NSString *backImgString;//反面身份证url
@property (nonatomic, strong) NSMutableArray *forwardImgArray;
@property (nonatomic, strong) NSMutableArray *backImgArray;

@end

@implementation SHVerifyIDViewController

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
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    self.navigationController.navigationBar.barTintColor = SHColorFromHex(0x00a9f0);
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"实名认证";
    
    _fordwardL.textColor = SHColorFromHex(0x9a9a9a);
    _backL.textColor = SHColorFromHex(0x9a9a9a);
    [_nameTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    [_cardNumTF setValue:SHColorFromHex(0x9a9a9a) forKeyPath:@"_placeholderLabel.textColor"];
    _submitButton.layer.cornerRadius = _submitButton.height / 2;
    _submitButton.clipsToBounds = YES;
    [_submitButton setBackgroundColor:navColor];
    
    //添加手势
    _forwardImgV.userInteractionEnabled = YES;
    _backImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *forwardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardImageViewClick:)];
    _forwardImgV.tag = 10;
    [_forwardImgV addGestureRecognizer:forwardTap];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageViewClick:)];
    _backImgV.tag = 11;
    [_backImgV addGestureRecognizer:backTap];
    
    
    _forwardImgArray = [NSMutableArray array];
    _backImgArray = [NSMutableArray array];
    
    
}

//正面UIImageView添加手势
- (void)forwardImageViewClick:(UIGestureRecognizer *)gestureRecognizer
{
    SHWeakSelf
    UIGestureRecognizer *tap = (UIGestureRecognizer *)gestureRecognizer;
    NSInteger tag = tap.view.tag;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.naviBgColor = navColor;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            
            [weakSelf dealWithPictureWithArray:photos andTag:tag];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
//反面UIImageView添加手势
- (void)backImageViewClick:(UIGestureRecognizer *)gestureRecognizer
{
    SHWeakSelf
    UIGestureRecognizer *tap = (UIGestureRecognizer *)gestureRecognizer;
    NSInteger tag = tap.view.tag;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.naviBgColor = navColor;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            
            [weakSelf dealWithPictureWithArray:photos andTag:tag];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//处理选中的照片
- (void)dealWithPictureWithArray:(NSArray *)photoArray andTag:(NSInteger)tag
{
    SHWeakSelf
    //裁剪正方行
    UIImage *scaleImage = [ImageUtil image:photoArray[0] fillSize:CGSizeMake(242, 168)];
    //压缩图片
    UIImage *compressImage = [ImageUtil comparessImageFromOriginalImage:scaleImage];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (tag == 10) {
        [SG_HttpsTool uploadImageWithURL:imageUrlString image:scaleImage success:^(id JSON, int code, NSString *msg) {
            if (code == 0) {
                [weakSelf.forwardImgArray removeAllObjects];
                [weakSelf.forwardImgArray addObject:compressImage];
                [MBProgressHUD hideHUDForView:weakSelf.view];
                NSDictionary *dic = JSON[@"data"];
                NSString *string = [NSString stringWithFormat:@"%@%@", imageSuccessUrl, dic[@"url"]];
                _forwardImgString = string;
                _forwardImgV.image = _forwardImgArray[0];
            }
        } failure:^(NSError *error) {
            
        }];
    } else if (tag == 11) {
        [SG_HttpsTool uploadImageWithURL:imageUrlString image:compressImage success:^(id JSON, int code, NSString *msg) {
            if (code == 0) {
                [weakSelf.backImgArray removeAllObjects];
                [weakSelf.backImgArray addObject:compressImage];
                [MBProgressHUD hideHUDForView:weakSelf.view];
                NSDictionary *dic = JSON[@"data"];
                NSString *string = [NSString stringWithFormat:@"%@%@", imageSuccessUrl, dic[@"url"]];
                _backImgString = string;
                _backImgV.image = _backImgArray[0];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    
    
}



//提交按钮
- (IBAction)submitButton:(UIButton *)sender {
    SHWeakSelf
    if ([self judgeAllParams]) {
        NSDictionary *dic = @{
                              @"realName":_nameTF.text,
                              @"card":_cardNumTF.text,
                              @"cardFrontUrl":_forwardImgString,
                              @"cardBehindUrl":_backImgString
                              };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHVerifyCardInfoUrl params:dic success:^(id JSON, int code, NSString *msg) {
            SHLog(@"%d", code)
            SHLog(@"%@", msg)
            if (code == 0) {
                [MBProgressHUD hideHUDForView:weakSelf.view];
                [MBProgressHUD showMBPAlertView:msg withSecond:1.0];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else if (code == 500) {
                [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
        }];
        
    }
    
}

//验证参数是否满足
- (BOOL)judgeAllParams
{
    if ([NSString isEmpty:_nameTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入姓名" withSecond:1.0];
        return NO;
    }
    if ([NSString isEmpty:_cardNumTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入身份证号" withSecond:1.0];
        return NO;
    }
    if (![NSString isCorrectIDNumber:_cardNumTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的身份证号" withSecond:1.0];
        return NO;
    }
    if (_forwardImgArray.count == 0) {
        [MBProgressHUD showMBPAlertView:@"请上传身份证正面" withSecond:1.0];
        return NO;
    }
    if (_backImgArray.count == 0) {
        [MBProgressHUD showMBPAlertView:@"请上传身份证反面" withSecond:1.0];
        return NO;
    }
    return YES;
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
