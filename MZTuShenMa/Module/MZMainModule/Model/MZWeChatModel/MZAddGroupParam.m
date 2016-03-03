//
//  MZAddGroupParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZAddGroupParam.h"

@implementation MZAddGroupParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.album_id)
    {
        [dict setObject:self.album_id forKey:@"album_id"];
    }
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    if(self.discuss)
    {
        [dict setObject:self.discuss forKey:@"discuss"];
    }
    
    [dict setObject:[kAddGroup base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kAddGroup;
}


@end
