//
//  MZGroupReplyModel.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZGroupReplyModel.h"

@implementation MZGroupReplyModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"replyId":@"id"};
}
@end
