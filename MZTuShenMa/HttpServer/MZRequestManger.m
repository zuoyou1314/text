//
//  MZRequestManger.m
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZRequestManger.h"

@implementation MZRequestManger

+ (NSString *)showMsgWithError:(NSError *)error
{
    if (error)
    {
        NSString *string = nil;
        
        if(error.domain == NSURLErrorDomain && error.code == -1004)
        {
            string = @"网络异常，请检查网络后重试";
        }
        
        if (error.code == -1009)
        {
            string = @"网络异常，请检查网络后重试";
        }
        
        if (error.domain == NSURLErrorDomain && error.code == -1001)
        {
            string = @"网络连接超时";
        }
        
        if (error.code == -1011)
        {
            string = @"服务器开小差了，请稍后重试";
        }
        if (error.domain == NSCocoaErrorDomain && error.code == 3840)
        {
            string = @"服务器开小差了，请重试";
        }
        
        if (string != nil)
        {
            
        }
        return string;
    }
    return nil;
}

+ (BOOL)isSuccessCode:(MZBaseResponse *)response
{
    if ([response.errCode integerValue] == 0)
    {
        return YES;
    }
    return NO;
}

+ (NSString *)showMsgWithErrorCode:(NSString *)errCode errMsg:(NSString *)errMsg
{
    NSString *aString = nil;
    
    if([errCode integerValue] == 10000)
    {
        aString = @"暂无数据";
    }
    else
        return errMsg;
    
    return aString;
}
@end
