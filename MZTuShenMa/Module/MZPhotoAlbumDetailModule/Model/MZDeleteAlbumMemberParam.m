//
//  MZDeleteAlbumMemberParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDeleteAlbumMemberParam.h"

@implementation MZDeleteAlbumMemberParam

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
    
    if(self.del_id)
    {
        [dict setObject:self.del_id forKey:@"del_id"];
    }
    
    [dict setObject:[kDeleteAlbumMember base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kDeleteAlbumMember;
}

@end
