//
//  MZPhotoDetailParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPhotoDetailParam.h"

@implementation MZPhotoDetailParam

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
    if(self.issue_id)
    {
        [dict setObject:self.issue_id forKey:@"issue_id"];
    }
   
    [dict setObject:[kPhotoDetails base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kPhotoDetails;
}

@end
