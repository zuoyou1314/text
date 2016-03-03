//
//  MZNewlistsParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/6.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZNewlistsParam.h"

@implementation MZNewlistsParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    if(self.code)
    {
        [dict setObject:self.code forKey:@"code"];
//        [dict setObject:[NSString stringWithFormat:@"%ld",self.code] forKey:@"code"];
    }
    
    [dict setObject:[kNewlists base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kNewlists;
}

@end
