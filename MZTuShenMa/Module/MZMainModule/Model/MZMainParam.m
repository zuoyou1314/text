//
//  MZMainParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/31.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZMainParam.h"

@implementation MZMainParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    if(self.type)
    {
        [dict setObject:self.type forKey:@"type"];
    }
    
    if(self.page)
    {
        [dict setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
    }

    [dict setObject:[kAlbumlists base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kAlbumlists;
}


@end
