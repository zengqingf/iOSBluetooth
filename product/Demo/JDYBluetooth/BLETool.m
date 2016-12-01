//
//  MMPosTool.m
//  MmposService
//
//  Created by zqf on 16/2/15.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "BLETool.h"

@implementation BLETool
+ (NSData *)dataWithHexString:(NSString *)hexString {
    NSInteger len = [hexString length];
    char *myBuffer = (char *)malloc(len / 2 + 1);
    bzero(myBuffer, len / 2 + 1);
    for (int i = 0; i < len - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [NSScanner scannerWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSData *hexData = [[NSData alloc] initWithBytes:myBuffer length:len/2];
    free(myBuffer);
    return hexData;
}

+ (NSString*)hexStringWithData:(NSData *)data {
    static const char hexdigits[] = "0123456789ABCDEF";
    if (data.length == 0) {
        return @"";
    }
    NSUInteger numBytes = [data length];
    const unsigned char* bytes = [data bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; i++){
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    free(strbuf);
    return (hexBytes);
}

+ (NSString *)doubleHexStringWithNumber:(NSInteger)aNumber {
    NSString *aStr = [NSString stringWithFormat:@"%lx",(long)aNumber];
    NSString *aString = [@"0000" stringByAppendingString:aStr];
    NSUInteger sl = [aString length];
    NSString *targetStr = [aString substringWithRange:NSMakeRange(sl-4, 4)];
    return targetStr;
}

+ (NSString *)singleHexStringWithNumber:(NSInteger)aNumber {
    NSString *aStr = [NSString stringWithFormat:@"%lx",(long)aNumber];
    NSString *aString = [@"00" stringByAppendingString:aStr];
    NSUInteger sl = [aString length];
    NSString *targetStr = [aString substringWithRange:NSMakeRange(sl-2, 2)];
    return targetStr;
}

@end
