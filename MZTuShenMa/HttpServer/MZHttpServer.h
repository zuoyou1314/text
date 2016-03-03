//
//  MZHttpServer.h
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface MZHttpServer : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

+ (instancetype) servse;
// 发起请求
- (AFHTTPRequestOperation *)requestByOperation:(AFHTTPRequestOperation *)aOperation
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
