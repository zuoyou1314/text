//
//  MZEditAlbumParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZEditAlbumParam.h"

@implementation MZEditAlbumParam

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
    
    if(self.album_name)
    {
        [dict setObject:self.album_name forKey:@"album_name"];
    }
    if(self.uname)
    {
        [dict setObject:self.uname forKey:@"uname"];
    }
    
    if(self.push)
    {
        [dict setObject:self.push forKey:@"push"];
    }
    
    if(self.album_des)
    {
        [dict setObject:self.album_des forKey:@"album_des"];
    }
    
    [dict setObject:[kEditAlbum base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kEditAlbum;
}

@end
