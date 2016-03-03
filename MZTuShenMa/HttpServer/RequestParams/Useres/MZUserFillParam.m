//
//  MZUserFillParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/13.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZUserFillParam.h"

@implementation MZUserFillParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    if(self.way)
    {
        [dict setObject:[NSString stringWithFormat:@"%ld",self.way] forKey:@"way"];
    }
    
    
    if(self.user_name)
    {
        [dict setObject:self.user_name forKey:@"user_name"];
    }
    if(self.sex)
    {
        [dict setObject:self.sex forKey:@"sex"];
    }
    
    [dict setObject:[kUserFill base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kUserFill;
}

@end
