//
//  MZAlbumUserPhotosParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZAlbumUserPhotosParam.h"

@implementation MZAlbumUserPhotosParam

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
    if(self.page)
    {
        [dict setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
    }
    [dict setObject:[kAlbumUserPhotos base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kAlbumUserPhotos;
}

@end
