//
//  MZMainResponseDataModel.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/31.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZMainResponseDataModel.h"

@implementation MZMainResponseDataModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"album_id" : @"id"};
}
@end
