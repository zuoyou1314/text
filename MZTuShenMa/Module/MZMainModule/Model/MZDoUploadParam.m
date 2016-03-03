//
//  MZDoUploadParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/14.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDoUploadParam.h"

@implementation MZDoUploadParam

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
    
    if (self.type) {
        [dict setObject:self.type forKey:@"type"];
    }
    
    if (self.upload_type) {
        [dict setObject:self.upload_type forKey:@"upload_type"];
    }
    
    
//    [dict setObject:[NSString stringWithFormat:@"%ld",self.way] forKey:@"way"];
    
    
    if(self.code)
    {
        [dict setObject:self.code forKey:@"code"];
    }
    
    if(self.position)
    {
        [dict setObject:self.position forKey:@"position"];
    }
    
    if(self.issue_id)
    {
        [dict setObject:self.issue_id forKey:@"issue_id"];
    }
    
    [dict setObject:[kDoUpload base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kDoUpload;
}

@end
