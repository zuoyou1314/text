//
//  AppDelegate.h
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@protocol WechatLoginDelegate <NSObject>

@optional
-(void)wechatLoginSuccessWithDic:(NSDictionary *)dic;

-(void)wechatLoginFailure;

-(void)wechatLoginCancel;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>


@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,strong) UIView *lunchView;

@property(nonatomic,assign) id<WechatLoginDelegate> wechatLoginDelegate;



@end

