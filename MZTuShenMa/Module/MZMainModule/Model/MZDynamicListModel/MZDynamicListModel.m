//
//  MZDynamicListModel.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/1.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDynamicListModel.h"
#import "MZListsModel.h"
@implementation MZDynamicListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"issue_id":@"id"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"lists":[MZListsModel class]};
}

@end
