//
//  MZReplyGroupParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZReplyGroupParam.h"

@implementation MZReplyGroupParam

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
    
    if(self.group_id)
    {
        [dict setObject:self.group_id forKey:@"group_id"];
    }
    
    [dict setObject:[kReplyGroup base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kReplyGroup;
}

@end
