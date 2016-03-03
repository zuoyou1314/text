//
//  MZGoodsCommentsParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/25.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZGoodsCommentsParam.h"

@implementation MZGoodsCommentsParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.issue_id)
    {
        [dict setObject:self.issue_id forKey:@"issue_id"];
    }
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    
    [dict setObject:[kGoodsComments base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kGoodsComments;
}

@end
