//
//  MZForgetPasswordParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/11.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZForgetPasswordParam.h"

@implementation MZForgetPasswordParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.phone)
    {
        [dict setObject:self.phone forKey:@"phone"];
    }
    if(self.pass)
    {
        [dict setObject:[self.pass md5] forKey:@"pass"];
    }
    
    if (self.reset) {
        [dict setObject:self.reset forKey:@"reset"];
    }
    
    if(self.device_id)
    {
        [dict setObject:self.device_id forKey:@"device_id"];
    }
    
    
    [dict setObject:@"1" forKey:@"way"];
    
    [dict setObject:[kRegisterPhone base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kRegisterPhone;
}


@end
