//
//  MZBaseResponse.m
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseResponse.h"

@implementation MZBaseResponse

- (id)initWithDictionary:(NSDictionary *)jsonDic bodyType:(Class)bodyType
{
    if(self = [super init])
    {
        _bodyType = bodyType;
        
        self.body = [NSMutableArray arrayWithCapacity:1];
        
        [self setValuesForKeysWithDictionary:jsonDic];
    }
    return self;
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"responseData"] && [value isKindOfClass:[NSArray class]])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (NSMutableDictionary *dic in value)
        {
            if(!self.bodyType) return;
            [array addObject:[[self.bodyType alloc] initWithDictionary:dic]];
        }
        self.body = array;
    }
    else if ([key isEqualToString:@"responseData"] && [value isKindOfClass:[NSDictionary class]])
    {
        [self.body addObject:[[self.bodyType alloc] initWithDictionary:value]];
    }
    else
        [super setValue:value forKey:key];
}

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"responseData" : @"responseData"
             };
}

@end
