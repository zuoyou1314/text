//
//  MZBaseModel.h
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZBaseModel : NSObject<NSCoding>

- (id)initWithDictionary:(NSDictionary*)jsonDic;

@end
