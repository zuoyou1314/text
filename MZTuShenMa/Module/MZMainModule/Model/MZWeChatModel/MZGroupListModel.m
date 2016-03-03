//
//  MZGroupListModel.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZGroupListModel.h"
#import "MZGroupReplyModel.h"
@implementation MZGroupListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"groupListId":@"id"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"reply":[MZGroupReplyModel class]};
}


@end
