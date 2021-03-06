//
//  MZRequestManger.h
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZBaseResponse.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

@interface MZRequestManger : NSObject<UIAlertViewDelegate>
// -- MARK: http error
+ (NSString *)showMsgWithError:(NSError *)error;
// -- MARK: 自己服务器errCode
+ (NSString *)showMsgWithErrorCode:(NSString *)errCode errMsg:(NSString *)errMsg;

+ (BOOL)isSuccessCode:(MZBaseResponse *)response;

@end
