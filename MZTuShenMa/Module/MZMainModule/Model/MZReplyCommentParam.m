//
//  MZReplyCommentParam.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/8.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZReplyCommentParam.h"

@implementation MZReplyCommentParam

- (NSMutableDictionary *)bindRequestParam
{
    NSMutableDictionary *dict = [super bindRequestParam];
    
    if(self.user_id)
    {
        [dict setObject:self.user_id forKey:@"user_id"];
    }
    if(self.comment_id)
    {
        [dict setObject:self.comment_id forKey:@"comment_id"];
    }
    
    if(self.issue_id)
    {
        [dict setObject:self.issue_id forKey:@"issue_id"];
    }
    
    if(self.discuss)
    {
        [dict setObject:self.discuss forKey:@"discuss"];
    }
    
    if(self.group_id)
    {
        [dict setObject:self.group_id forKey:@"group_id"];
    }
    
    if(self.comment_user_id)
    {
        [dict setObject:self.comment_user_id forKey:@"comment_user_id"];
    }
    
    if(self.album_id)
    {
        [dict setObject:self.album_id forKey:@"album_id"];
    }
   
    
    [dict setObject:[kReplyComment base64Encode] forKey:AUTHCODE];
    
    return dict;
}

- (NSString *)bindRequestPath
{
    return kReplyComment;
}

@end
