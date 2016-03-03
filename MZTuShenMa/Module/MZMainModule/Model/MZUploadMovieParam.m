//
//  MZUploadMovieParam.m
//  MZTuShenMa
//
//  Created by zuo on 16/1/17.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZUploadMovieParam.h"

@implementation MZUploadMovieParam

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
    
    if(self.upload_type)
    {
        [dict setObject:self.upload_type forKey:@"upload_type"];
    }
    
    if (self.type) {
        [dict setObject:self.type forKey:@"type"];
    }
    
    [dict setObject:[kMp4Api base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kMp4Api;
}

@end
