//
//  MZNewIsHaveParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/6.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZNewIsHaveParam.h"

@implementation MZNewIsHaveParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    [dict setObject:[kNewIsHave base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kNewIsHave;
}

@end
