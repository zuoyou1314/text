//
//  MZBaseRequestParam.h
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "NSString+Base64.h"

@interface MZBaseRequestParam : NSObject

@property (nonatomic,copy,readonly) NSString *host;

@property (nonatomic,copy,readonly) NSString *port;

//@property (nonatomic,copy,readonly) NSString *version;

@property (nonatomic,copy,readonly) NSString *path;

- (AFHTTPRequestOperation *) bindRequestOperation;

- (NSMutableDictionary *) bindRequestParam;

- (NSString *) bindRequestPath;

@end
