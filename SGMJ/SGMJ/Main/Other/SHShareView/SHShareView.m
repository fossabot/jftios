//
//  SHShareView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHShareView.h"
#import "SHButton.h"
#import "SHSharePlatform.h"
//#import <UMSocialCore/UMSocialCore.h>
#import <UMShare/UMShare.h>
#import "SDPhotoBrowser.h"
#import <Photos/Photos.h>

static CGFloat const SHShreButtonHeight = 90.f;         //按钮高
static CGFloat const SHShreButtonWith = 76.f;           //按钮宽
static CGFloat const SHShreHeightSpace = 15.f;          //竖间距
static CGFloat const SHShreCancelHeight = 46.f;         //取消按钮高


@interface SHShareView () <UIGestureRecognizerDelegate, SDPhotoBrowserDelegate>

@property (nonatomic, strong) UIView *bottomPopView;
@property (nonatomic, strong) NSMutableArray *platformArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) SHShareModel *shareModel;
@property (nonatomic, assign) SHShareContentType shareContentType;
@property (nonatomic, assign) CGFloat shareViewHeight;  //分享视图的高度

@property (nonatomic, strong) UIImageView *codeImgV;

@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation SHShareView

//初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.platformArray = [NSMutableArray array];
        self.buttonArray = [NSMutableArray array];
        
        //初始化分享平台
        [self setUpPlatformsItems];
        
        
        _codeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SHScreenW / 2 - 60, SHScreenH / 2 - 60, 120, 120)];
        
        [self addSubview:_codeImgV];
        
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.layer.borderWidth = 1;
        _saveBtn.borderColor = [UIColor whiteColor];
        [_saveBtn addTarget:self action:@selector(clickSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.hidden = YES;
        [self addSubview:_saveBtn];
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_codeImgV.mas_bottom).offset(10);
            make.width.mas_equalTo(_codeImgV.mas_width);
            make.centerX.mas_equalTo(_codeImgV.mas_centerX);
            make.height.mas_equalTo(30);
        }];
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [tap addTarget:self action:@selector(closeShareView)];
        [self addGestureRecognizer:tap];
        
        //计算分享视图的总高度
        self.shareViewHeight = SHShreHeightSpace * 2 + SHShreButtonHeight + SHShreCancelHeight + 30;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SHScreenW / 2 - 60, 20, 120, 20)];
        titleL.text = @"分享至";
        titleL.font = [UIFont systemFontOfSize:15.f];
        titleL.textAlignment = NSTextAlignmentCenter;
        [self.bottomPopView addSubview:titleL];
        
        UILabel *lineOneL = [[UILabel alloc] init];
        lineOneL.centerY = titleL.centerY;
        lineOneL.backgroundColor = SHColorFromHex(0xedeaea);
        lineOneL.frame = CGRectMake(0, titleL.centerY, (SHScreenW - 120) / 2, 0.5);
        [self.bottomPopView addSubview:lineOneL];
        
        UILabel *lineTwoL = [[UILabel alloc] initWithFrame:CGRectMake(SHScreenW - lineOneL.width, titleL.centerY, lineOneL.width, 0.5)];
        lineTwoL.backgroundColor = SHColorFromHex(0xedeaea);
        [self.bottomPopView addSubview:lineTwoL];
        
        int columnCount = 5;
        //计算间隙
        CGFloat appMargin = (SHScreenW - columnCount * SHShreButtonWith) / (columnCount + 1);
        for (int i = 0; i < self.platformArray.count; i++) {
            SHSharePlatform *platform = self.platformArray[i];
            //计算列号和行号
            int colX = i%columnCount;
            int rowY = i/columnCount;
            //计算坐标
            CGFloat buttonX = appMargin + colX * (SHShreButtonWith + appMargin);
            CGFloat buttonY = SHShreHeightSpace + rowY * (SHShreButtonHeight + SHShreHeightSpace) + 25;
            SHButton *shareBtn = [[SHButton alloc] init];
            [shareBtn setTitle:platform.name forState:UIControlStateNormal];
            [shareBtn setTitleColor:SHColorFromHex(0x8a8a8a) forState:UIControlStateNormal];
            shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            [shareBtn setImage:[UIImage imageNamed:platform.iconStateNormal] forState:UIControlStateNormal];
            [shareBtn setImage:[UIImage imageNamed:platform.iconStateHighlighted] forState:UIControlStateHighlighted];
            shareBtn.frame = CGRectMake(10, 10, 30, 30);
            [shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
            //按钮加tag，区分点击
            shareBtn.tag = platform.sharePlatform;
            [self.bottomPopView addSubview:shareBtn];
            shareBtn.frame = CGRectMake(buttonX, buttonY, SHShreButtonWith, SHShreButtonHeight);
            
            [self.bottomPopView addSubview:shareBtn];
            [self.buttonArray addObject:shareBtn];
        }
        
        //按钮动画
        for (SHButton *button in self.buttonArray) {
            NSInteger idx = [self.buttonArray indexOfObject:button];
            
            CGAffineTransform fromTransform = CGAffineTransformMakeTranslation(0, 50);
            button.transform = fromTransform;
            button.alpha = 0.3;
            [UIView animateWithDuration:0.9 + idx * 0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.transform = CGAffineTransformIdentity;
                button.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, self.shareViewHeight - SHShreCancelHeight, SHScreenW, SHShreCancelHeight)];
        [cancelButton setTitleColor:SHColorFromHex(0x8a8a8a) forState:UIControlStateNormal];
        cancelButton.backgroundColor = SHColorFromHex(0xedeaea);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [cancelButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomPopView addSubview:cancelButton];
        [self addSubview:self.bottomPopView];
    }
    return self;
}

//点击保存图片
- (void)clickSaveBtnClick
{
    if (_codeImgV.image == nil) {
        [MBProgressHUD showError:@"图片未加载成功" toView:self];
        return;
    }
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:_codeImgV.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        SHLog(@"success = %d, error = %@", success, error)
        if (success == 1) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMBPAlertView:@"保存成功" withSecond:2.0];
                });
            });
        } else {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMBPAlertView:@"保存失败" withSecond:2.0];
                });
            });
        }
        
        

        
    }];
    
    
}



- (void)showShareViewWithSHShareModel:(SHShareModel *)shareModel shareContentType:(SHShareContentType)shareContentType
{
    self.shareModel = shareModel;
    self.shareContentType = shareContentType;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.bottomPopView.frame = CGRectMake(0, SHScreenH - self.shareViewHeight, SHScreenW, self.shareViewHeight);
    }];
}

#pragma mark - 点击了分享按钮
- (void)clickShare:(UIButton *)sender
{
    //友盟社会化分享组件
    switch (sender.tag) {
        case SHShareTypeWeChatSession://微信好友
            SHLog(@"微信好友")
            [self shareLinkToPlatform:UMSocialPlatformType_WechatSession shareConentType:self.shareContentType];
            [self closeShareView];
            break;
        case SHShareTypeWeChatTimeline://微信朋友圈
            [self shareLinkToPlatform:UMSocialPlatformType_WechatTimeLine shareConentType:self.shareContentType];
            [self closeShareView];
            break;
        case SHShareTypeQQ://QQ
            [self shareLinkToPlatform:UMSocialPlatformType_QQ shareConentType:self.shareContentType];
            [self closeShareView];
            break;
        case SHShareTypeQzone://QQ空间
            [self shareLinkToPlatform:UMSocialPlatformType_Qzone shareConentType:self.shareContentType];
            [self closeShareView];
            break;
        case SHShareTypeErWeiMa://二维码
            SHLog(@"点击二维码")
            SHLog(@"%@", self.shareModel.url)
            
            [self createQRcodeWithUrl:self.shareModel.url];
            break;
        default:
            break;
    }
    
}

- (void)createQRcodeWithUrl:(NSString *)url
{
    // 1.创建过滤器
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    
    //    NSString *dataString = @"http://www.520it.com";
    
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    
    CIImage *outputImage = [filter outputImage];
    
    // 5.将CIImage转换成UIImage，并放大显示
    
    _codeImgV.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100];
    
    _saveBtn.hidden = NO;
    
}

/**
 
 * 根据CIImage生成指定大小的UIImage
 
 *
 
 * @param image CIImage
 
 * @param size 图片宽度
 
 */

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size

{
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}





#pragma mark - 导入友盟社会化分享组件,分享链接到三方平台
- (void)shareLinkToPlatform:(UMSocialPlatformType)shareToPlatform shareConentType:(SHShareContentType)shareConentType
{
    switch (self.shareContentType) {
        case SHShareContentTypeText://文本分享
        {
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            //设置文本
            messageObject.text = self.shareModel.title;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:shareToPlatform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
                [self shareResult:result error:error];

            }];
        }
            break;
        case SHShareContentTypeImage:
            {
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

                //创建图片内容对象
                UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                SHLog(@"%@", self.shareModel.thumbImage)
                [shareObject setShareImage:self.shareModel.thumbImage];

                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;

                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:shareToPlatform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
                    [self shareResult:result error:error];

                }];
            }
            break;
        case SHShareContentTypeLink:
            {
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                SHLog(@"%@", self.shareModel.thumbImage)

                NSURL *url = [NSURL URLWithString:self.shareModel.thumbImage];
                UIImage *imagea = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                UMShareWebpageObject *webPageObject = [UMShareWebpageObject shareObjectWithTitle:self.shareModel.title descr:self.shareModel.descr thumImage:imagea];

                webPageObject.webpageUrl = self.shareModel.url;
                messageObject.shareObject = webPageObject;

                [[UMSocialManager defaultManager] shareToPlatform:shareToPlatform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
                    [self shareResult:result error:error];
                }];
            }
            break;
        default:
            break;
    }


}

#pragma mark - 分享结果处理
- (void)shareResult:(id)result error:(NSError *)error
{
    if (!error) {
        //分享成功
        [MBProgressHUD showMBPAlertView:@"分享成功" withSecond:2.0];
    } else {
        //分享失败
    }
}


#pragma mark - 设置平台
- (void)setUpPlatformsItems
{
    //防止审核失败，最好先判断是否安装微信、QQ
    //微信好友
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        SHSharePlatform *wechatSessionModel = [[SHSharePlatform alloc] init];
        wechatSessionModel.iconStateNormal = @"weixin_allshare";
        wechatSessionModel.iconStateHighlighted = @"weixin_allshare_night";
        wechatSessionModel.sharePlatform = SHShareTypeWeChatSession;
        wechatSessionModel.name = @"微信好友";
        [self.platformArray addObject:wechatSessionModel];
    }
    
    //微信朋友圈
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
        SHSharePlatform *wechatTimeLineModel = [[SHSharePlatform alloc] init];
        wechatTimeLineModel.iconStateNormal = @"pyq_allshare";
        wechatTimeLineModel.iconStateHighlighted = @"pyq_allshare_night";
        wechatTimeLineModel.sharePlatform = SHShareTypeWeChatTimeline;
        wechatTimeLineModel.name = @"微信朋友圈";
        [self.platformArray addObject:wechatTimeLineModel];
    }
    
    //QQ好友
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        SHSharePlatform *qqModel = [[SHSharePlatform alloc] init];
        qqModel.iconStateNormal = @"qq_allshare";
        qqModel.iconStateHighlighted = @"qq_allshare_night";
        qqModel.sharePlatform = SHShareTypeQQ;
        qqModel.name = @"QQ好友";
        [self.platformArray addObject:qqModel];
    }
    
    //QQ空间
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        SHSharePlatform *qqZone = [[SHSharePlatform alloc] init];
        qqZone.iconStateNormal = @"qqkj_allshare";
        qqZone.iconStateHighlighted = @"qqkj_allshare_night";
        qqZone.sharePlatform = SHShareTypeQzone;
        qqZone.name = @"QQ空间";
        [self.platformArray addObject:qqZone];
        
    }
    
    //二维码
    SHSharePlatform *erWeiMaModel = [[SHSharePlatform alloc] init];
    erWeiMaModel.iconStateNormal = @"erweima";
    erWeiMaModel.iconStateHighlighted = @"erweima";
    erWeiMaModel.sharePlatform = SHShareTypeErWeiMa;
    erWeiMaModel.name = @"二维码";
    [self.platformArray addObject:erWeiMaModel];
    
    
}



- (UIView *)bottomPopView
{
    if (_bottomPopView == nil) {
        _bottomPopView = [[UIView alloc] initWithFrame:CGRectMake(0, SHScreenH, SHScreenW, self.shareViewHeight)];
        _bottomPopView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomPopView;
}

#pragma mark - 点击背景关闭视图
- (void)closeShareView
{
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [UIColor clearColor];
        [_codeImgV removeFromSuperview];
        self.bottomPopView.frame = CGRectMake(0, SHScreenH, SHScreenW, self.shareViewHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


#pragma  mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.bottomPopView]) {
        return NO;
    }
    return YES;
}









@end




