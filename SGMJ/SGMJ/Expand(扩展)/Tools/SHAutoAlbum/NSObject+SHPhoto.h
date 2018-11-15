//
//  NSObject+SHPhoto.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHSelfImage.h"
@interface NSObject (SHPhoto) <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/**
 *  打开相机
 */
- (void)showCamera;
@end
