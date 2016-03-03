//
//  MZAdvertParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/29.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZAdvertParam.h"

@implementation MZAdvertParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    [dict setObject:[kPublicAlbum base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kPublicAlbum;
}

@end
