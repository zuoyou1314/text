//
//  MZBaseModel.m
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseModel.h"

@implementation MZBaseModel

- (id)initWithDictionary:(NSDictionary*)jsonDic
{
    if(self = [super init])
    {
        if([jsonDic isKindOfClass:[NSDictionary class]])
            [self setValuesForKeysWithDictionary:jsonDic];
    }
    return self;
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Undefined Key:%@ in %@",key,[self class]);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        
    }
    return self;
}
@end
