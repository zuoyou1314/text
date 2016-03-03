//
//  MZRegisterPhoneParam.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZRegisterPhoneParam.h"
#import "UserHelp.h"

@implementation MZRegisterPhoneParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if([[UserHelp sharedUserHelper] userName])
    {
        [dict setObject:[[UserHelp sharedUserHelper] userName] forKey:@"phone"];
    }
    if([[UserHelp sharedUserHelper] passWord])
    {
        [dict setObject:[[[UserHelp sharedUserHelper] passWord] md5] forKey:@"pass"];
    }
    
    [userdefaultsDefine setObject:@"1" forKey:@"way"];
    
    [dict setObject:@"1" forKey:@"way"];
    
    if ([userdefaultsDefine objectForKey:@"JPushRegisterId"]) {
         [dict setObject:[userdefaultsDefine objectForKey:@"JPushRegisterId"] forKey:@"device_id"];
    }
    
    if([[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey])
    {
        [dict setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] forKey:@"ios"];
    }
    
    
    [dict setObject:[kRegisterPhone base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kRegisterPhone;
}

@end
