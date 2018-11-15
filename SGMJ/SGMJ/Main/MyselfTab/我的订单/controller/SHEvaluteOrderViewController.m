//
//  SHEvaluteOrderViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/5.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHEvaluteOrderViewController.h"
#import "SHStarRateView.h"

#import "TZImagePickerController.h"
#import "ImageUtil.h"
#import "SHEvaluateModel.h"


@interface SHEvaluteOrderViewController () <TZImagePickerControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *speedView;
@property (weak, nonatomic) IBOutlet UIView *taiduView;

@property (weak, nonatomic) IBOutlet UIButton *picOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *picTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *picThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *delPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *delTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *delThreeBtn;

@property (weak, nonatomic) IBOutlet UILabel *serviceScoreL;
@property (weak, nonatomic) IBOutlet UILabel *speedScoreL;
@property (weak, nonatomic) IBOutlet UILabel *taiduScoreL;

@property (nonatomic, assign) double serviceScore;
@property (nonatomic, assign) double speedScore;
@property (nonatomic, assign) double taiduScore;


@property (nonatomic, strong) NSMutableArray *imageUrlArr;  //选中的图片数组
@property (nonatomic, strong) NSMutableArray *localImgArray;//留存的本地图片UIImage
@property (nonatomic, strong) NSMutableArray *urlImgArray;  //图片url数组

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderL;

@property (weak, nonatomic) IBOutlet UIButton *evaluteButton;

@property (nonatomic, strong) SHStarRateView *starView1;
@property (nonatomic, strong) SHStarRateView *starView2;
@property (nonatomic, strong) SHStarRateView *starView3;
@property (nonatomic, strong) SHEvaluateModel *evaluateModel;

@end

@implementation SHEvaluteOrderViewController


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
    
   [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    
    
    
}

- (void)initBaseInfo
{
    
    _imageUrlArr = [NSMutableArray array];
    _localImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    _urlImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    if (self.evaluateType == SHEvaluateOrderNoType) {
        self.navigationItem.title = @"评价订单";
        _evaluteButton.layer.cornerRadius = _evaluteButton.height / 2;
        
        SHWeakSelf
        _starView1 = [[SHStarRateView alloc] initWithFrame:CGRectMake(0, 0, _serviceView.width, _serviceView.height) finish:^(CGFloat currentScore) {
            SHLog(@"%d", (int)currentScore)
            weakSelf.serviceScoreL.text = [NSString stringWithFormat:@"%d分", (int)currentScore];
            weakSelf.serviceScore = (double)currentScore;
        }];
        [_serviceView addSubview:_starView1];
        _starView2 = [[SHStarRateView alloc] initWithFrame:CGRectMake(0, 0, _speedView.width, _speedView.height) finish:^(CGFloat currentScore) {
            SHLog(@"%d", (int)currentScore)
            weakSelf.speedScoreL.text = [NSString stringWithFormat:@"%d分", (int)currentScore];
            weakSelf.speedScore = (double)currentScore;
        }];
        [_speedView addSubview:_starView2];
        _starView3 = [[SHStarRateView alloc] initWithFrame:CGRectMake(0, 0, _taiduView.width, _taiduView.height) finish:^(CGFloat currentScore) {
            SHLog(@"%d", (int)currentScore)
            weakSelf.taiduScoreL.text = [NSString stringWithFormat:@"%d分", (int)currentScore];
            weakSelf.taiduScore = (double)currentScore;
        }];
        [_taiduView addSubview:_starView3];
        
        
        _delPicBtn.hidden = YES;
        _picTwoBtn.hidden = YES;
        _delTwoBtn.hidden = YES;
        _picThreeBtn.hidden = YES;
        _delThreeBtn.hidden = YES;
    } else if (self.evaluateType == SHModifyEvaluateAsseIdType) {
        self.navigationItem.title = @"修改评价";
        SHWeakSelf
        _starView1 = [[SHStarRateView alloc] initWithFrame:CGRectMake(0, 0, _serviceView.width, _serviceView.height) finish:^(CGFloat currentScore) {
            weakSelf.serviceScoreL.text = [NSString stringWithFormat:@"%d分", (int)currentScore];
            weakSelf.serviceScore = (double)currentScore;
        }];
        [_serviceView addSubview:_starView1];
        _starView2 = [[SHStarRateView alloc] initWithFrame:CGRectMake(0, 0, _speedView.width, _speedView.height) finish:^(CGFloat currentScore) {
            weakSelf.speedScoreL.text = [NSString stringWithFormat:@"%d分", (int)currentScore];
            weakSelf.speedScore = (double)currentScore;
        }];
        [_speedView addSubview:_starView2];
        _starView3 = [[SHStarRateView alloc] initWithFrame:CGRectMake(0, 0, _taiduView.width, _taiduView.height) finish:^(CGFloat currentScore) {
            weakSelf.taiduScoreL.text = [NSString stringWithFormat:@"%d分", (int)currentScore];
            weakSelf.taiduScore = (double)currentScore;
        }];
        //starView3.currentScore = 5;
        [_taiduView addSubview:_starView3];
        
        [self loadEvaluatedETAIL];
    }
    
}

- (void)loadEvaluatedETAIL
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"assessId":@(_accessId)
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHModifyEvaDetUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            _evaluateModel = [SHEvaluateModel mj_objectWithKeyValues:JSON[@"orderAssess"]];
            [weakSelf deatWithEvaluateModel:_evaluateModel];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

//显示之前的评价
- (void)deatWithEvaluateModel:(SHEvaluateModel *)model
{
    if ([model.content isEqualToString:@"该用户没有留言！"]) {
        _placeHolderL.alpha = 1;
    } else {
        _placeHolderL.alpha = 0;
        _textView.text = model.content;
    }
    
    NSString *urlString = nil;
    SHLog(@"请求的照片：%d", model.images.count)
    if (model.images.count == 0) {
        _delPicBtn.hidden = YES;
        _picTwoBtn.hidden = YES;
        _delTwoBtn.hidden = YES;
        _picThreeBtn.hidden = YES;
        _delThreeBtn.hidden = YES;
    } else if (model.images.count == 1) {
        if ([model.images[0] isEqualToString:@""]) {
            _delPicBtn.hidden = YES;
            _picTwoBtn.hidden = YES;
            _delTwoBtn.hidden = YES;
            _picThreeBtn.hidden = YES;
            _delThreeBtn.hidden = YES;
        } else {
            
            [_picOneBtn showNetUrlImageWithUrl:model.images[0]];
            [_localImgArray replaceObjectAtIndex:0 withObject:model.images[0]];
            [_urlImgArray replaceObjectAtIndex:0 withObject:model.images[0]];
            _delPicBtn.hidden = NO;
            _picTwoBtn.hidden = NO;
            _delTwoBtn.hidden = YES;
            _picThreeBtn.hidden = YES;
            _delThreeBtn.hidden = YES;
        }
    } else if (model.images.count == 2) {
        if ([model.images[0] isEqualToString:@""] && [model.images[1] isEqualToString:@""]) {
            _delPicBtn.hidden = YES;
            _picTwoBtn.hidden = YES;
            _delTwoBtn.hidden = YES;
            _picThreeBtn.hidden = YES;
            _delThreeBtn.hidden = YES;
        } else if ([model.images[0] isEqualToString:@""] && ![model.images[1] isEqualToString:@""]) {
            [_picOneBtn showNetUrlImageWithUrl:model.images[1]];
            [_localImgArray replaceObjectAtIndex:0 withObject:model.images[1]];
            [_urlImgArray replaceObjectAtIndex:0 withObject:model.images[1]];
            _delPicBtn.hidden = NO;
            _picTwoBtn.hidden = NO;
            _delTwoBtn.hidden = YES;
            _picThreeBtn.hidden = YES;
            _delThreeBtn.hidden = YES;
        } else if (![model.images[0] isEqualToString:@""] && ![model.images[1] isEqualToString:@""]) {

            [_picOneBtn showNetUrlImageWithUrl:model.images[0]];
            [_picTwoBtn showNetUrlImageWithUrl:model.images[1]];
            [_localImgArray replaceObjectAtIndex:0 withObject:model.images[0]];
            [_localImgArray replaceObjectAtIndex:1 withObject:model.images[1]];
            [_urlImgArray replaceObjectAtIndex:0 withObject:model.images[0]];
            [_urlImgArray replaceObjectAtIndex:1 withObject:model.images[1]];
        }
    } else if (model.images.count == 3) {
        SHLog(@"请求的照片：%@", model.images)
        if ([model.images[0] isEqualToString:@""] && [model.images[1] isEqualToString:@""] && [model.images[2] isEqualToString:@""]) {
            _delPicBtn.hidden = YES;
            _picTwoBtn.hidden = YES;
            _delTwoBtn.hidden = YES;
            _picThreeBtn.hidden = YES;
            _delThreeBtn.hidden = YES;
        } else if (![model.images[0] isEqualToString:@""] && ![model.images[1] isEqualToString:@""] && [model.images[2] isEqualToString:@""]) {
            [_picOneBtn showNetUrlImageWithUrl:model.images[0]];
            [_picTwoBtn showNetUrlImageWithUrl:model.images[1]];
            [_localImgArray replaceObjectAtIndex:0 withObject:model.images[0]];
            [_localImgArray replaceObjectAtIndex:1 withObject:model.images[1]];
            [_urlImgArray replaceObjectAtIndex:0 withObject:model.images[0]];
            [_urlImgArray replaceObjectAtIndex:1 withObject:model.images[1]];
        } else if (![model.images[0] isEqualToString:@""] && ![model.images[1] isEqualToString:@""] && ![model.images[2] isEqualToString:@""]) {
            SHLog(@"请求的照片：%@", model.images)
            [_picOneBtn showNetUrlImageWithUrl:model.images[0]];
            [_picTwoBtn showNetUrlImageWithUrl:model.images[1]];
            [_picThreeBtn showNetUrlImageWithUrl:model.images[2]];
            
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.images[0]]];
            UIImage *image1 = [[UIImage alloc]initWithData:data];
            
            NSData * data1 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.images[1]]];
            UIImage *image2 = [[UIImage alloc]initWithData:data1];
            
            NSData * data2 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.images[2]]];
            UIImage *image3 = [[UIImage alloc]initWithData:data2];
            
            
            [_localImgArray replaceObjectAtIndex:0 withObject:model.images[0]];
            [_localImgArray replaceObjectAtIndex:1 withObject:model.images[1]];
            [_localImgArray replaceObjectAtIndex:2 withObject:model.images[2]];
            [_urlImgArray replaceObjectAtIndex:0 withObject:image1];
            [_urlImgArray replaceObjectAtIndex:1 withObject:image2];
            [_urlImgArray replaceObjectAtIndex:2 withObject:image3];
        }
        _starView1.currentScore = _evaluateModel.serveScore;
        _starView2.currentScore = _evaluateModel.speedScore;
        _starView3.currentScore = _evaluateModel.mannerScore;
        _speedScore = _evaluateModel.speedScore;
        _serviceScore = _evaluateModel.serveScore;
        _taiduScore = _evaluateModel.mannerScore;
        _taiduScoreL.text = [NSString stringWithFormat:@"%d分", _evaluateModel.mannerScore];
        _speedScoreL.text = [NSString stringWithFormat:@"%d分", _evaluateModel.speedScore];
        _serviceScoreL.text = [NSString stringWithFormat:@"%d分", _evaluateModel.serveScore];
        
        SHLog(@"%@", _localImgArray)
        SHLog(@"%@", _urlImgArray)
    }
    
    
//
}


//发表评论
- (void)releaseEvalute
{
    
    if ([self judgeAllParagrams]) {
        if (self.evaluateType == SHEvaluateOrderNoType) {
            [self orderNoEvaluate];
        } else if (self.evaluateType == SHModifyEvaluateAsseIdType) {
            [self modifyEvaluate];
        }
        

    }
    
}

//修改评价
- (void)modifyEvaluate
{
    SHLog(@"修改评价")
    SHLog(@"%@", _localImgArray)
    SHLog(@"%@", _urlImgArray)
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
    
    SHWeakSelf
    NSDictionary *dic = @{
                          @"assessId":@(_accessId),
                          @"speed":@(_speedScore),
                          @"serve":@(_serviceScore),
                          @"manner":@(_taiduScore),
                          @"content":_textView.text ? _textView.text : @"",
                          @"images":urlString ? urlString : @""
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateEvaluteUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            if (weakSelf.evaluateBlock) {
                weakSelf.evaluateBlock(_accessId);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
    
}

//订单号评价
- (void)orderNoEvaluate
{
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
    
    SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":_orderNo,
                          @"type":@"reply",
                          @"images":urlString ? urlString : @"",
                          @"content":_textView.text ? _textView.text : @"",
                          @"speed":@(_speedScore),
                          @"serve":@(_serviceScore),
                          @"manner":@(_taiduScore)
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHEvaluteOrderUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"评价成功" withSecond:2.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

//选择图片
- (IBAction)pictureButtonClick:(UIButton *)sender {
    [self selectPictureWithButton:sender];
}

//删除图片
- (IBAction)deleteButtonClick:(UIButton *)sender {
    if (sender.tag == 11) {
        SHLog(@"%@", _localImgArray)
        //SHLog(@"%@", _urlImgArray)
        //第一个删除按钮（第一个删除按钮出现的时候，最少显示一张图片）
        if (![_localImgArray[0] isEqualToString:@""] && [_localImgArray[1] isEqualToString:@""] && [_localImgArray[2] isEqualToString:@""]) {
            //有一张图片，剩余两个是空的
            //SHLog(@"只有一张图片")
            SHLog(@"%@", _localImgArray)
            _picTwoBtn.hidden = YES;
            _delPicBtn.hidden = YES;
            [_localImgArray removeObjectAtIndex:0];
            [_urlImgArray removeObjectAtIndex:0];
            [_localImgArray addObject:@""];
            [_urlImgArray addObject:@""];
            SHLog(@"%@", _localImgArray)
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

- (IBAction)evaluteButtonClick:(UIButton *)sender {
    [self releaseEvalute];
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


- (BOOL)judgeAllParagrams
{
//    if ([NSString isEmpty:_textView.text]) {
//        [MBProgressHUD showMBPAlertView:@"请输入您的评价" withSecond:2.0];
//        return NO;
//    }
    if (self.serviceScore == 0) {
        [MBProgressHUD showMBPAlertView:@"请对'服务'进行评价" withSecond:2.0];
        return NO;
    }
    if (self.speedScore == 0) {
        [MBProgressHUD showMBPAlertView:@"请对'速度'进行评价" withSecond:2.0];
        return NO;
    }
    if (self.taiduScore == 0) {
        [MBProgressHUD showMBPAlertView:@"请对'态度'进行评价" withSecond:2.0];
        return NO;
    }
    SHLog(@"%d", self.localImgArray.count)
    SHLog(@"%@", self.localImgArray)
//    if (([self.localImgArray[0] isEqualToString:@""] || [self.localImgArray[1] isEqualToString:@""] || [self.localImgArray[0] isEqualToString:@""])) {
//        [MBProgressHUD showMBPAlertView:@"请上传三张图片" withSecond:2.0];
//        return NO;
//    }
    
    
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







//#pragma mark - SHStarRateViewDelegate
//-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
//    NSLog(@"%ld----  %f",starRateView.tag,currentScore);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
