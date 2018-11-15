//
//  SG_HttpsTool.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SG_HttpsTool.h"
#import "SG_HttpResponse.h"
#import "SHLoginViewController.h"
#import "SHTokenManager.h"
#import "ImageUtil.h"


@interface SG_HttpsTool()
/**
 *  AF Http Object
 */
@property (nonatomic, strong) AFHTTPSessionManager *afSessionManager;

@end


@implementation SG_HttpsTool
SingletonM(SG_HttpsTool)
/**
 *  懒加载
 */
- (AFHTTPSessionManager *)afSessionManager
{
    if (!_afSessionManager) {
        _afSessionManager = [AFHTTPSessionManager manager];
        _afSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _afSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _afSessionManager.requestSerializer.timeoutInterval = 10.0f;
        _afSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/javascript",nil];
    }
    return _afSessionManager;
}

- (NSString *)getNeedUrl:(NSString *)url
{
   
    NSString *tempUrl = [NSString stringWithFormat:@"%@%@", baseUrlString, url];
    SHLog(@"%@", tempUrl);
    return tempUrl;
}

/**
 *  get方法
 */
- (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSString *token = SH_AppDelegate.tokenMap.token;
    //SHLog(@"%@", token)
    //请求头添加token，前面是传的值，后面是传的参数
    //这个地方不要用_afSessionManager，用self.afSessionManager可以调用afSessionManager的Ge方法
    [self.afSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [self.afSessionManager GET:[self getNeedUrl:url] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success == nil) return;
        SG_HttpResponse *response = [[SG_HttpResponse sharedSG_HttpResponse] returnHttpResponse:responseObject];
        
        if (response.baseCode == 700) {
            SHLog(@"%d", response.baseCode)
            [self showAlert:@"温馨提示" message:@"token错误"];
        } else if (response.baseCode == 500) {
            [self showAlert:@"温馨提示" message:@"服务器发生错误"];
        } else if (response.baseCode == 100) {
            [self showAlert:@"温馨提示" message:@"继续操作"];
        } else if (response.baseCode == 0) {
            success(response.data, response.baseCode, response.baseMsg);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure == nil) return;
        failure(error);
        SHLog(@"error===:%@", error)
    }];
    
}

#pragma mark - 登录
- (void)goToLogin
{
    SHLog(@"跳转页面没有走")
    SHLoginViewController *vc = [[SHLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:nav animated:YES completion:nil];
}


#pragma mark - 弹框
//显示alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *registerAler = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:registerAler];
    [self.viewContrller presentViewController:alert animated:true completion:nil];
}
/**
 *  post方法
 */
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{

    NSString *token = SH_AppDelegate.tokenMap.token;
    
    //请求头添加token，前面是传的值，后面是传的参数
    //这个地方不要用_afSessionManager，用self.afSessionManager可以调用afSessionManager的Get方法
    if (token) {
        [self.afSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    } else {
        [self.afSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%@", token] forHTTPHeaderField:@"Authorization"];
    }

    [self.afSessionManager POST:[self getNeedUrl:url] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success == nil) return;
        SG_HttpResponse *response = [[SG_HttpResponse sharedSG_HttpResponse] returnHttpResponse:responseObject];
        
        if (response.baseCode == 700) {
            SHLog(@"token获取失败了")
            SH_AppDelegate.tokenMap.token = nil;
            [SH_AppDelegate userLogin];
        } else if (response.baseCode == 500) {
            success(response.data, response.baseCode, response.baseMsg);
        } else if (response.baseCode == 100) {
            [self showAlert:@"温馨提示" message:@"继续操作"];
            success(response.data, response.baseCode, response.baseMsg);
        } else if (response.baseCode == 0) {
            success(response.data, response.baseCode, response.baseMsg);
        }
        //        success(response.data, response.baseCode, response.baseMsg);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure == nil) return;
        failure(error);
        SHLog(@"url -- %@  ---- 请求失败")
        SHLog(@"error:%@", error)
    }];
    
    
}

- (void)downloadImage:(NSString *)url place:(NSString *)place imageView:(UIImageView *)imageView
{
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrlString,url]] placeholderImage:[UIImage resizeImage:place] options:SDWebImageRetryFailed|SDWebImageLowPriority];
}


/**
 *  上传图片
 */
+(void)uploadImageWithURL:(NSString *)url image:(UIImage *)image success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSData *imageData = UIImagePNGRepresentation(image);
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image.png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject != nil) {
            NSData *receiveData = responseObject;
            NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
//            SHLog(@"%@", receiveString)
            NSData *jsonData = [receiveString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                SHLog(@"json解析失败:%@", err)
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(dic,0,@"上传成功");
                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SHLog(@"Error:%@", error)
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
    
}


/**
 *  上传单张图片
 */
+ (void)uploadImageWithPath:(NSString *)path image:(UIImage *)image params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSArray *array = [NSArray arrayWithObject:image];
    [self uploadImageWithPath:path photos:array params:params success:success failure:failure];
}

/**
 *  上传多张图片
 */
+ (void)uploadImageWithPath:(NSString *)path photos:(NSArray *)photos params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < photos.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            UIImage *image = photos[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d", i+1] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SHLog(@"%@", responseObject)
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure == nil) return;
        failure(error);
    }];
    
}









@end

