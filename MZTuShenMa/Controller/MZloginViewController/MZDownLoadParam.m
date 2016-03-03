//
//  MZDownLoadParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/11/4.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDownLoadParam.h"

@implementation MZDownLoadParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.photo_type)
    {
        [dict setObject:self.photo_type forKey:@"photo_type"];
    }
    
    [dict setObject:[kDownloadApi base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kDownloadApi;
}

@end
