//
//  MZPhotoAlbumDetailsParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPhotoAlbumDetailsParam.h"

@implementation MZPhotoAlbumDetailsParam

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
    
    [dict setObject:[kAlbumDetails base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kAlbumDetails;
}

@end
