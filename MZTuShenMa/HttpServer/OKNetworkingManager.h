//
//  OKNetworkingManager.h
//  OKLinkWallet
//
//  Created by chenzs on 15/5/9.
//  Copyright (c) 2015年 OKLink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, OKNetworkStatus) {
    OKNetworkStatusUnknown = -1,
    OKNetworkStatusNotReachable = 0,
    OKNetworkStatusViaWWAN = 1,
    OKNetworkStatusViaWiFi = 2
};

@interface OKNetworkingManager : NSObject
{
    BOOL _isShowAlert;
}
@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
@property ( nonatomic, assign) OKNetworkStatus netStatus;
@property (readonly, nonatomic, copy)   NSString *userAgent;
+(OKNetworkingManager*)sharedInstance;
-(void)start;
-(void)suspend;
-(void)resume;
-(void)stop;
/*
-(NSArray*)cookiesForUrl:(NSURL*)url;
-(void)setCookies:(NSArray*)cookies forUrL:(NSURL*)url;
*/
@end
