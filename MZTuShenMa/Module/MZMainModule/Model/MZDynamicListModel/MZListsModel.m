//
//  MZListsModel.m
//  MZTuShenMa
//
//  Created by zuo on 16/1/14.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZListsModel.h"
#import "MZSpeechListsModel.h"
@implementation MZListsModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"photoId" : @"id"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"speechLists" : [MZSpeechListsModel class]};
}


@end



