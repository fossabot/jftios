//
//  SHClearCacheTool.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHClearCacheTool.h"

@implementation SHClearCacheTool

#pragma mark - 获取path路径文件夹大小
+ (NSInteger)getCacheSizeWithFilePath:(NSString *)path
{
    //获取path文件夹下的所有文件--返回数组类型
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    //文件路径
    NSString *filePath = nil;
    //大小
    NSInteger totalSize = 0;
    
    for (NSString *subPath in subPathArr) {
        //1.拼接每一个文件的全路径
        filePath = [path stringByAppendingPathComponent:subPath];
        //2.是否是文件夹，默认不是
        BOOL isDirectory = NO;
        //3.判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        //4.以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) {
            //过滤：1.文件夹不存在，过滤文件夹 3.隐藏文件
            continue;
        }
        
        //5.指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        /**
         *  attributesOfItemAtPath:文件路径
         *  该方法只能获取文件的属性，无法获取文件夹属性，所以也是需要遍历文件夹的每一个文件的原因
         */
        
        //6.获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        //7.计算总大小
        totalSize += size;
    }
    
    //8.将文件夹大小转换为M/KB/B
//    NSString *totleStr = nil;
//
//    if (totalSize > 1000 * 1000) {
//        totleStr = [NSString stringWithFormat:@"%.2fM", totalSize / 1000.00f / 1000.00f];
//    } else if (totalSize > 1000) {
//        totleStr = [NSString stringWithFormat:@"%.2fKB", totalSize / 1000.00f];
//    } else {
//        totleStr = [NSString stringWithFormat:@"%.2fB", totalSize / 1.00f];
//    }
    return totalSize;
}

#pragma mark - 清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path
{
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
        
    }
    
    return YES;
}






@end
