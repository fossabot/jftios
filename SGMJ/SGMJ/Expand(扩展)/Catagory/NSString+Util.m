//
//  NSString+Util.m
//  demo
//
//  Created by xiedong on 2017/3/29.
//  Copyright © 2017年 xiedong. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"

#define kOK_PhoneNumber  @"^[1]([3|4|5|7|8][0-9]{1})[0-9]{8}$"
#define kOK_Email        @"^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$"

@implementation NSString (Util)

+ (BOOL)isEmpty:(NSString *)str {
    if (str == nil) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSString *tempStr = [NSString onlyString:str];
    if ([@"" isEqualToString:tempStr] || [@"null" isEqualToString:tempStr]) {
        return YES;
    }
    return NO;
}

+ (NSString *)onlyString:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)md5String {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return  [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0],result[1],result[2],result[3],
             result[4],result[5],result[6],result[7],
             result[8],result[9],result[10],result[11],
             result[12],result[13],result[14],result[15]] lowercaseString];
}

+ (NSString *)html2Text:(NSString *)html
{
    static NSString *regEx_script = @"<[\\s]*?script[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?script[\\s]*?>";
    static NSString *regEx_style = @"<[\\s]*?style[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?style[\\s]*?>";
    static NSString *regEx_html = @"<[^>]+>";
    static NSString *regEx_html1 = @"<[^>]+";
    
    NSMutableString *mutableHtml = [NSMutableString stringWithString:html];
    [mutableHtml replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [mutableHtml length])];
    [mutableHtml replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [mutableHtml length])];
    [mutableHtml replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [mutableHtml length])];
    [mutableHtml replaceOccurrencesOfString:@"|" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [mutableHtml length])];
    
    NSRegularExpression *m_script = [NSRegularExpression regularExpressionWithPattern:regEx_script options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSRegularExpression *m_style = [NSRegularExpression regularExpressionWithPattern:regEx_style options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSRegularExpression *m_html = [NSRegularExpression regularExpressionWithPattern:regEx_html options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSRegularExpression *m_html1 = [NSRegularExpression regularExpressionWithPattern:regEx_html1 options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    [m_script replaceMatchesInString:mutableHtml options:NSMatchingReportCompletion range:NSMakeRange(0, [mutableHtml length]) withTemplate:@""];
    [m_style replaceMatchesInString:mutableHtml options:NSMatchingReportCompletion range:NSMakeRange(0, [mutableHtml length]) withTemplate:@""];
    [m_html replaceMatchesInString:mutableHtml options:NSMatchingReportCompletion range:NSMakeRange(0, [mutableHtml length]) withTemplate:@""];
    [m_html1 replaceMatchesInString:mutableHtml options:NSMatchingReportCompletion range:NSMakeRange(0, [mutableHtml length]) withTemplate:@""];
    
    return mutableHtml;
}

//生成DBID
+ (NSString *)createDbId
{
    // Create universally unique identifier (object)
    NSMutableArray *zh= [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil] ;
    //        CGLog(@"LENGTH=%d",[zh count]);
    int i=0;
    NSMutableString *s=[[NSMutableString alloc]init] ;
    while (i<32) {
        [s appendString:[zh objectAtIndex:arc4random()%62]];
        i++;
        //CGLog(@"%d",arc4random()%36);
    }
    // CGLog(@"id==%@",s);
    return s;
}

/**
 * 获取文本绘制空间大小
 */
+(CGSize) contentSizeOfStr:(NSString *) str withFont:(UIFont*)font constrainedToSize:(CGSize) size {
    CGSize contentSize = CGSizeMake(0, 0);
    if (!str || str.length == 0) {
        return contentSize;
    }
    // 获取该段attributedString的属性字典
    NSDictionary *attribute = @{NSFontAttributeName:font};
    // 计算文本的大小
    contentSize = [str boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return contentSize;
}

+ (NSString *)uuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (BOOL)isOKPhoneNumber:(NSString *)phoneNumber {
    if ([phoneNumber isMatchedByRegex:kOK_PhoneNumber])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isOKEmail:(NSString *)email {
    if ([email isMatchedByRegex:kOK_Email])
    {
        return YES;
    }
    return NO;
}
+ (void)call:(NSString *)phoneNumber {
    if ([NSString isOKPhoneNumber:phoneNumber])
    {
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@", phoneNumber];
        telUrl = [telUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}
+ (BOOL)isChinese:(NSString *)string {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}
+ (BOOL)isCludeChinese:(NSString *)string {
    for (int i = 0; i < [string length]; i++) {
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}


/**
 
 *  验证身份证号码是否正确的方法
 
 *
 
 *  @param IDNumber 传进身份证号码字符串
 
 *
 
 *  @return 返回YES或NO表示该身份证号码是否符合国家标准
 
 */

+ (BOOL)isCorrectIDNumber:(NSString *)value

{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
                //4：检测ID的校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }

    
}



@end
