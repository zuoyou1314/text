//
//  MZUploadSpeechParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/12/14.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZUploadSpeechParam.h"

@implementation MZUploadSpeechParam


- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.photo_id)
    {
        [dict setObject:self.photo_id forKey:@"photo_id"];
    }
    
//    if(self.photo_num)
//    {
//        [dict setObject:self.photo_num forKey:@"photo_num"];
//    }
    
    if(self.coords_x)
    {
        [dict setObject:self.coords_x forKey:@"coords_x"];
    }
    
    if(self.coords_y)
    {
        [dict setObject:self.coords_y forKey:@"coords_y"];
    }
    
    
    if (self.track) {
        [dict setObject:self.track forKey:@"track"];
    }
    
    
    [dict setObject:[kUploadSpeech base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kUploadSpeech;
}


@end
