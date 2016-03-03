//
//  MZUserEditParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZUserEditParam.h"

@implementation MZUserEditParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];

    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    [dict setObject:[NSString stringWithFormat:@"%ld",self.way] forKey:@"way"];
    
    [dict setObject:[kUserEdit base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kUserEdit;
}

@end
