//
//  TakeOrSelectPhotoUtil.m
//  NetPhone
//
//  Created by common on 13-10-11.
//  Copyright (c) 2013年 青牛软件. All rights reserved.
//

#import "TakeOrSelectPhotoUtil.h"
#import "MBProgressHUD+EL.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

static TakeOrSelectPhotoUtil *_instanse;

@interface TakeOrSelectPhotoUtil ()

@property (nonatomic, weak) UIViewController *mViewController;

@end

@implementation TakeOrSelectPhotoUtil
@synthesize mViewController;

+ (TakeOrSelectPhotoUtil *)sharedInstanse
{
    if (!_instanse) {
        _instanse = [[TakeOrSelectPhotoUtil alloc] init];
    }
    return _instanse;
}

+ (void)release
{
    
}

/**
 *  拍照或者摄像
 */
- (void)takePhotoFromViewController:(UIViewController *)viewController ImagePickerMode:(ImagePickerMode)mode AllowsEditing:(BOOL)allowsEditing {
    if(EL_IOS7)
    {
        //拍照仅仅涉及相机权限
        if (mode == kImagePickerModePhoto)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL videoGranted) {
                if (videoGranted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self commonTakePhotoFromViewController:viewController ImagePickerMode:mode AllowsEditing:allowsEditing];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [MBProgressHUD showAlertViewWithText:@"您尚未开启家服通APP相机授权，不能使用该功能。请到\"设置-易购生活365-相机\"中开启"];
                    });
                }
            }];
        }
        //摄像涉及的权限
        else
        {
            //相机权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL videoGranted) {
                if (videoGranted) {
                    //麦克风权限
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL audioGranted) {
                        if (audioGranted) {
                            //相片权限
                            ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc] init];
                            __block BOOL isStop=NO;
                            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                if (!isStop) {
                                    if (*stop) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [MBProgressHUD showAlertViewWithText:@"您尚未开启家服通APP相机授权，不能使用该功能。请到\"设置-家服通APP-相机\"中开启"];
                                        });
                                    }
                                    else
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self commonTakePhotoFromViewController:viewController ImagePickerMode:mode AllowsEditing:allowsEditing];
                                        });
                                        isStop=YES;
                                    }
                                }
                            } failureBlock:^(NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD showAlertViewWithText:@"您尚未开启家服通APP相机授权，不能使用该功能。请到\"设置-易购生活365-相机\"中开启"];
                                });
                            }];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD showAlertViewWithText:@"您尚未开启家服通APP相机授权，不能使用该功能。请到\"设置-易购生活365-相机\"中开启"];
                            });
                        }
                    }];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showAlertViewWithText:@"您尚未开启家服通APP相机授权，不能使用该功能。请到\"设置-易购生活365-相机\"中开启"];
                    });
                }
            }];
        }
    }
    else
    {
        //7以下拍摄涉及相片权限
        if (mode == kImagePickerModeVideo) {
            ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc] init];
            __block BOOL isStop=NO;
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (!isStop) {
                    if (*stop) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showAlertViewWithText:@"在隐私设置中开启可视的照片权限"];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            SHLog(@"commonTakePhotoFromViewController ImagePickerMode ");
                            [self commonTakePhotoFromViewController:viewController ImagePickerMode:mode AllowsEditing:allowsEditing];
                        });
                        isStop=YES;
                    }
                }
            } failureBlock:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showAlertViewWithText:@"在隐私设置中开启可视的照片权限"];
                });
            }];
        }
        else
        {
            [self commonTakePhotoFromViewController:viewController ImagePickerMode:mode AllowsEditing:allowsEditing];
        }
    }
}



- (void)commonTakePhotoFromViewController:(UIViewController *)viewController ImagePickerMode:(ImagePickerMode)mode AllowsEditing:(BOOL)allowsEditing
{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.mViewController = viewController;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.allowsEditing = allowsEditing;
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            
            NSString *requiredMediaType = (NSString *)kUTTypeImage;
            if (mode == kImagePickerModeVideo) {
                requiredMediaType = (NSString *)kUTTypeMovie;
                SHLog(@"你选择了拍摄视频");
                // 设置录制视频的质量
                [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeMedium];
                //设置最长摄像时间
                [imagePickerController setVideoMaximumDuration:30.f];
            }
            NSArray *arrMediaTypes = [NSArray arrayWithObjects:requiredMediaType, nil];
            [imagePickerController setMediaTypes:arrMediaTypes];
            
            imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            imagePickerController.showsCameraControls = YES;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
            
        } else {
            [MBProgressHUD showAlertViewWithText:@"设备不支持拍照功能"];
        }
}

/**
 *  选择一张图片文件
 */
- (void)selectPhotoFromViewController:(UIViewController *)viewController AllowsEditing:(BOOL)allowsEditing
{
    self.mViewController = viewController;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = allowsEditing;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.mViewController) {
        [self.mViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.mViewController && [self.mViewController respondsToSelector:@selector(didFinishTakeOrSelectPhoto:)]) {
        [self.mViewController performSelector:@selector(didFinishTakeOrSelectPhoto:) withObject:info];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.mViewController) {
        
        [self.mViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)resetViewFrame
{
    if (EL_IOS7E) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.mViewController.navigationController.view.frame;
            SHLog(@"%f;%f;%f;%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
            
            CGFloat statusBarHeight = [[UIApplication sharedApplication] isStatusBarHidden] ? 0.0f : 20.0f;
            UINavigationBar *navBar = self.mViewController.navigationController.navigationBar;
            [navBar setFrame:CGRectMake(0, 0, navBar.frame.size.width, navBar.frame.size.height + statusBarHeight)];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [self.mViewController.view setBounds:CGRectMake(0, statusBarHeight * -1, self.mViewController.view.bounds.size.width, self.mViewController.view.bounds.size.height)];
        }];
    }
}

@end
