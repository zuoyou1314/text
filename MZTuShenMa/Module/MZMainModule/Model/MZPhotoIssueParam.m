//
//  MZPhotoIssueParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/10.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPhotoIssueParam.h"

@implementation MZPhotoIssueParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    if(self.album_id)
    {
        [dict setObject:self.album_id forKey:@"album_id"];
    }
    
    [dict setObject:[kPhotosIssue base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kPhotosIssue;
}

@end
