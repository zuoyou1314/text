//
//  MZUploadHeadImgParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/6.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZUploadHeadImgParam.h"

@implementation MZUploadHeadImgParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    
    if(self.way)
    {
          [dict setObject:[NSString stringWithFormat:@"%ld",self.way] forKey:@"way"];
    }
    
    [dict setObject:[kUploadHeadimg base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kUploadHeadimg;
}

@end
