//
//  SHClearCacheTool.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHClearCacheTool : NSObject

/*
 *  获取path路径下文件夹的大小
 *  @param path 要获取的文件夹 路径
 *  @return 返回path路径下文件夹的大小
 */
+ (NSInteger)getCacheSizeWithFilePath:(NSString *)path;

/*
 *  清除path路径下文件夹的缓存
 *  @param path 要清除缓存的文件夹路径
 *  @return 是否清除成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;




@end
