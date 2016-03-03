//
//  MZLoginParam.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZLoginParam.h"

@implementation MZLoginParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.account)
    {
        [dict setObject:self.account forKey:@"account"];
    }
    if(self.pass)
    {
        [dict setObject:[self.pass md5] forKey:@"pass"];
    }
    
    if(self.device_id)
    {
        [dict setObject:self.device_id forKey:@"device_id"];
    }
    
    
    if(self.user_img)
    {
        [dict setObject:self.user_img forKey:@"user_img"];
    }
    if(self.sex)
    {
        [dict setObject:self.sex  forKey:@"sex"];
    }
    
    if(self.user_name)
    {
        [dict setObject:self.user_name forKey:@"user_name"];
    }
    
    if(self.ios)
    {
        [dict setObject:self.ios forKey:@"ios"];
    }
    
    
    [dict setObject:[NSString stringWithFormat:@"%ld",self.way] forKey:@"way"];
    
    [dict setObject:[kLogin base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kLogin;
}
@end
