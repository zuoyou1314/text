//
//  MZIssueListsModel.m
//  MZTuShenMa
//
//  Created by zuo on 16/1/14.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZIssueListsModel.h"
#import "MZPhotoListsModel.h"
@implementation MZIssueListsModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"photoId":@"id"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"photoLists":[MZPhotoListsModel class]};
}


@end
