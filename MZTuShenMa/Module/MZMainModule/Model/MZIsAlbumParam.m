//
//  MZIsAlbumParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/25.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZIsAlbumParam.h"

@implementation MZIsAlbumParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    
    [dict setObject:[kIsAlbum base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kIsAlbum;
}

@end
