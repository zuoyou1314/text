//
//  MZResetAlbumImg.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/15.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZResetAlbumImg.h"

@implementation MZResetAlbumImg

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
//    if(self.img_id)
//    {
//        [dict setObject:self.img_id forKey:@"img_id"];
//    }
    if(self.album_id)
    {
        [dict setObject:self.album_id forKey:@"album_id"];
    }
    
//    if(self.num)
//    {
//        [dict setObject:self.num forKey:@"num"];
//    }
    
    if(self.img_url)
    {
        [dict setObject:self.img_url forKey:@"img_url"];
    }
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }

    
    
    [dict setObject:[kResetAlbumImg base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kResetAlbumImg;
}


@end
