//
//  MZAddCommentParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/8.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZAddCommentParam.h"

@implementation MZAddCommentParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    if(self.issue_id)
    {
        [dict setObject:self.issue_id forKey:@"issue_id"];
    }
    
    if(self.discuss)
    {
        [dict setObject:self.discuss forKey:@"discuss"];
    }
    
    if(self.issue_user_id)
    {
        [dict setObject:self.issue_user_id forKey:@"issue_user_id"];
    }
    if(self.album_id)
    {
        [dict setObject:self.album_id forKey:@"album_id"];
    }
    
    [dict setObject:[kAddComment base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kAddComment;
}

@end
