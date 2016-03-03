//
//  NSString+Base64.m
//  ZhiXuan
//
//  Created by Wangxin on 15/6/11.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "NSString+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Base64)

- (NSString *)base64Encode
{
    NSData* originData = [self dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return encodeResult;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
