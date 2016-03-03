//
//  MZHttpServer.m
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZHttpServer.h"

@implementation MZHttpServer

- (id)init
{
    if(self = [super init])
    {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

+ (instancetype)servse
{
    return [[[self class] alloc] init];
}

- (AFHTTPRequestOperation *)requestByOperation:(AFHTTPRequestOperation *)aOperation
                                       success:(void (^)(AFHTTPRequestOperation *, id))success
                                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    AFHTTPRequestOperation *operation = aOperation;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
#if DEBUG
        NSLog(@"\nresponseObject : \n%@\n",responseObject);
#endif
        if(success)
        {
            success(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#if DEBUG
        NSLog(@"%@",error);
#endif
        if([error.domain isKindOfClass:[NSURLErrorDomain class]] && error.code == -999)
        {
#if DEBUG
            NSLog(@"The request cancel. \n %@",error);
#endif
        }
        
        if([error.domain isKindOfClass:[NSURLErrorDomain class]] && error.code == -1001)
        {
#if DEBUG
            NSLog(@"The request timed out.\n %@",error);
#endif
        }
        if(failure)
        {
            failure(operation,error);
        }
    }];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

@end
