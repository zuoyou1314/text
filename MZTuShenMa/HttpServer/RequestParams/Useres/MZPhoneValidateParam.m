//
//  MZPhoneValidateParam.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPhoneValidateParam.h"

@implementation MZPhoneValidateParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.phone)
    {
        [dict setObject:self.phone forKey:@"phone"];
    }
    
    if (self.reset) {
        [dict setObject:self.reset forKey:@"reset"];
    }
    
    [dict setObject:[kPhoneValidate base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kPhoneValidate;
}
@end
