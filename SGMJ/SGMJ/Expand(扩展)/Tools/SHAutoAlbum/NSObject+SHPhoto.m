//
//  NSObject+SHPhoto.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "NSObject+SHPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+SH.h"

@implementation NSObject (SHPhoto)

/**
 *  打开相机
 */
- (void)showCamera
{
    //选择相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //初始化
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //设置可编辑
    //picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    //进入照相界面
    [[self getCurrentVC] presentViewController:picker animated:YES completion:nil];
}

/**
 *  获取当前控制器
 *  @return return value description
 */
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        //获取所有的窗口
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *nowW in windows) {
            if (nowW.windowLevel == UIWindowLevelNormal) {
                window = nowW;
                break;
            }
        }
        
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else {
        return window.rootViewController;
    }
    
    return result;
}

#pragma mark - 相机代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //图片
    UIImage *image;
    //判断是不是从相机过来的
    if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
        //关闭相机
        [picker dismissViewControllerAnimated:YES completion:nil];
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //通过判断picker的sourceType，如果是拍照则保存到相册中，非常重要的一部，不然，无法获取照相的图片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

/**
 *  确定相机图片保存到系统相册后，进行图片获取
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    SHLog(@"以保存")
    //操作获得的照片，我这是直接显示，你那个加到你现实的一组里面显示就好了
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library afterCameraAsset:^(ALAsset *asset) {
        SHSelfImage *image = [[SHSelfImage alloc] initWithCGImage:asset.thumbnail];
        image.asset = asset;
        //发送通知
        NSDictionary *dic = @{@"saveImage":image};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVEIMAGE" object:nil userInfo:dic];
    }];
    
}








@end
