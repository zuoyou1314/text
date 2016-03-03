//
//  MZBaseRequestParam.m
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"
#import "AFNetworking.h"
static NSTimeInterval const kTimeoutInterval = 60;

@implementation MZBaseRequestParam
- (id)init
{
    if(self = [super init])
    {
        _host = kHost;
        
        _port = kPort;
        
        _path = [self bindRequestPath];
    }
    return self;
}

- (NSString *) bindRequestPath
{
    return nil;
}

- (NSMutableDictionary *) bindRequestParam
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    return dict;
}

- (AFHTTPRequestOperation *) bindRequestOperation
{
    AFHTTPRequestOperation *openation;
    
    NSString *url = [NSString stringWithFormat:@"%@:%@/%@",self.host,self.port,self.path];
//      NSString *url = [NSString stringWithFormat:@"%@/%@",self.host,self.path];
#if DEBUG
    NSLog(@"\nreuqestUrl is :\n%@\n",url);
#endif
    NSDictionary *dict = [self bindRequestParam];
#if DEBUG
    NSLog(@"\nrequestParam is :\n%@\n",dict);
#endif
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:dict error:nil];
    
    [request setTimeoutInterval:kTimeoutInterval];
    
    openation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //申明返回的结果是json类型
    openation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    openation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //如果报接受类型不一致请替换一致text/html或别的
//   openation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    
    return openation;
}

//- (AFHTTPRequestOperationManager *)bindRequestOperationManager
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    return manager;
//}

@end
