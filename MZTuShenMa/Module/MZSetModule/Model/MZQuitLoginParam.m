//
//  MZQuitLoginParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/11/10.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZQuitLoginParam.h"

@implementation MZQuitLoginParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    
    [dict setObject:[kQuitLogin base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kQuitLogin;
}

@end
