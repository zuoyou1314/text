//
//  MZShareParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZShareParam.h"

@implementation MZShareParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.issue_id)
    {
        [dict setObject:self.issue_id forKey:@"issue_id"];
    }
    
    if(self.album_id)
    {
        [dict setObject:self.album_id forKey:@"album_id"];
    }
    
    if(self.code)
    {
        [dict setObject:self.code forKey:@"code"];
    }
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    [dict setObject:[kShare base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kShare;
}


@end
