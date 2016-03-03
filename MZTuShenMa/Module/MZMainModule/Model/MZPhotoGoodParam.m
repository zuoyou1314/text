//
//  MZPhotoGoodParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/1.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPhotoGoodParam.h"

@implementation MZPhotoGoodParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.issue_id)
    {
        [dict setObject:self.issue_id forKey:@"issue_id"];
    }
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    if(self.issue_user_id)
    {
        [dict setObject:self.issue_user_id forKey:@"issue_user_id"];
    }
    if(self.album_id)
    {
        [dict setObject:self.album_id forKey:@"album_id"];
    }
    [dict setObject:[kPhotoGood base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kPhotoGood;
}

@end
