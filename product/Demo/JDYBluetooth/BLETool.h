//
//  MMPosTool.h
//  MmposService
//
//  Created by zqf on 16/2/15.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLETool : NSObject
//将16进制字符串转化成data
+ (NSData *)dataWithHexString:(NSString *)hexString;
//将data转化成16进制字符串
+ (NSString *)hexStringWithData:(NSData *)data;
//将数字转化成两个字节的16进制字符串
+ (NSString *)doubleHexStringWithNumber:(NSInteger)aNumber;
//将数字转化成一个字节的16进制字符串
+ (NSString *)singleHexStringWithNumber:(NSInteger)aNumber;
@end
