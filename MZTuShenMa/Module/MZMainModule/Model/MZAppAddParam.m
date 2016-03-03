//
//  MZAppAddParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/11/16.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZAppAddParam.h"

@implementation MZAppAddParam

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
    
    [dict setObject:[kAppAdd base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kAppAdd;
}

@end
