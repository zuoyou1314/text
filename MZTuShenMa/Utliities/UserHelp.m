//
//  UserHelp.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "UserHelp.h"
#import <objc/runtime.h>

@implementation UserHelp

+ (instancetype)sharedUserHelper
{
    static UserHelp *sharedUserHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserHelper = [[UserHelp alloc] init];
    });
    return sharedUserHelper;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        [self setValue:value forKey:@"userId"];
    }
//    else{
//        [super setValue:value forKey:key];
//    }
    
}
@end
