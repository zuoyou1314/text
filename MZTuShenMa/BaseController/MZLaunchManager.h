//
//  MZLaunchManager.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/8.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLaunchManager : NSObject

+ (instancetype)manager;

//- (void)launch;
//登录
- (void)logoutScreen;
//退出登录
- (BOOL)logout;
//进入主页
- (void)startApplication;
//进入临时相册缺省主页
- (void)tempMainViewController;



@end
