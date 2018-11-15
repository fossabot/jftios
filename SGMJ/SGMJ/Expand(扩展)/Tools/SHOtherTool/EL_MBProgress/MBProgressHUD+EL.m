//
//  MBProgressHUD+EL.m
//  EasyLife365
//
//  Created by xiedong on 2017/4/21.
//  Copyright © 2017年 xiedong. All rights reserved.
//

#import "MBProgressHUD+EL.h"
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

static MBProgressHUD *hudAlertView;

@implementation MBProgressHUD (EL)
+ (void)showWaitingAlertViewInView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hudAlertView) {
            [hudAlertView removeFromSuperview];
            hudAlertView = nil;
        }
        hudAlertView = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hudAlertView.bezelView.backgroundColor = [UIColor blackColor];
        hudAlertView.activityIndicatorColor = [UIColor whiteColor];
    });
}
+ (void)showWaitingAlertViewWithText:(NSString *)text InView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hudAlertView) {
            [hudAlertView removeFromSuperview];
            hudAlertView = nil;
        }
        hudAlertView = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hudAlertView.bezelView.backgroundColor = [UIColor blackColor];
        hudAlertView.activityIndicatorColor = [UIColor whiteColor];
        hudAlertView.label.text = text;
        hudAlertView.label.textColor = [UIColor whiteColor];
        hudAlertView.label.font = [UIFont systemFontOfSize:14];
    });
}
+ (void)dismissWaitingAlertView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hudAlertView) {
            [hudAlertView hideAnimated:YES];
            [hudAlertView removeFromSuperview];
            hudAlertView = nil;
        }
    });
}
+ (void)showSuccessAlertViewWithText:(NSString *)text {
    [MBProgressHUD showAlertViewWithImage:@"Checkmark" withText:text];
}
+ (void)showFailureAlertViewWithText:(NSString *)text {
    [MBProgressHUD showAlertViewWithImage:@"failure" withText:text];
}
+ (void)showAlertViewWithImage:(NSString *)imageNamed withText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hudAlertView) {
            [hudAlertView removeFromSuperview];
            hudAlertView = nil;
        }
        UIView *windowView = [[[UIApplication sharedApplication] delegate] window];
        hudAlertView = [MBProgressHUD showHUDAddedTo:windowView animated:YES];
        hudAlertView.mode = MBProgressHUDModeCustomView;
        hudAlertView.bezelView.backgroundColor = [UIColor blackColor];
        UIImage *image = [[UIImage imageNamed:imageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hudAlertView.customView = [[UIImageView alloc] initWithImage:image];
        hudAlertView.square = YES;
        hudAlertView.label.text = text;
        hudAlertView.label.textColor = [UIColor whiteColor];
        hudAlertView.label.font = [UIFont systemFontOfSize:14];
        hudAlertView.label.numberOfLines = 0;
        [hudAlertView hideAnimated:YES afterDelay:1.0f];
    });
}

+ (void)showAlertViewWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *windowView = [[[UIApplication sharedApplication] delegate] window];
        if (hudAlertView) {
            [hudAlertView removeFromSuperview];
            hudAlertView = nil;
        }
        hudAlertView = [MBProgressHUD showHUDAddedTo:windowView animated:YES];
        hudAlertView.mode = MBProgressHUDModeText;
        hudAlertView.bezelView.backgroundColor = [UIColor blackColor];
        hudAlertView.label.text = text;
        hudAlertView.label.textColor = [UIColor whiteColor];
        hudAlertView.label.font = [UIFont systemFontOfSize:14];
        hudAlertView.label.numberOfLines = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hudAlertView) {
                [hudAlertView hideAnimated:YES afterDelay:1.0f];
            }
        });
    });
}
+ (void)showNoNetworkAlertView {
    [MBProgressHUD showAlertViewWithText:@"网络不可用，请稍后重试"];
}

+ (BOOL)connectedNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    if (defaultRouteReachability) {
        CFRelease(defaultRouteReachability);
    }
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
    
}
@end
