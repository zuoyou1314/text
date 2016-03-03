//
//  MZReportUserParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/17.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZReportUserParam.h"

@implementation MZReportUserParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    if(self.album_memId)
    {
        [dict setObject:self.album_memId forKey:@"album_memId"];
    }
    if(self.album_id)
    {
        [dict setObject:self.album_id forKey:@"album_id"];
    }

    [dict setObject:[kReportUser base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kReportUser;
}

@end
