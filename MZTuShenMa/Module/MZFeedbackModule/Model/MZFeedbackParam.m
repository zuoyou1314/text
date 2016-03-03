//
//  MZFeedbackParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/7.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZFeedbackParam.h"

@implementation MZFeedbackParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    
    if(self.fank)
    {
        [dict setObject:self.fank forKey:@"fank"];
    }
    
    if(self.contact)
    {
        [dict setObject:self.contact forKey:@"contact"];
    }
    
    [dict setObject:[kFank base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kFank;
}


@end
