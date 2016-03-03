//
//  MZMainPhotoDetailModel.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZMainPhotoDetailModel.h"
#import "MZListsModel.h"
@implementation MZMainPhotoDetailModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"issue_id" : @"id"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"lists":[MZListsModel class]};
}

@end
