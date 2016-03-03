//
//  MOKOShareManager.h
//  MOKODreamWork_iOS2
//
//  Created by zuo on 15/8/5.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "MOKOShareView.h"
//#import "MOKOComplainViewController.h"
@interface MOKOShareManager : NSObject

+ (MOKOShareManager *)shareSingleton;


/**
 *  注册友盟分享以及配置信息
 */
- (void)shareConfig;
/**
 *  设置分享内容
 *
 *  @param type       分享渠道
 *  @param shareVC    分享的控制器
 *  @param shareText  分享内嵌文字
 *  @param shareImage 分享内嵌图片,可以传入UIImage或者NSData类型
 *  @param shareUrl   分享消息url地址
 */
//- (void)shareType:(MOKOShareButtonType)type shareWithViewController:(UIViewController *)shareVC shareText:(NSString *)shareText shareImage:(id)shareImage shareUrl:(NSString *)shareUrl;
//
//- (void)shareType:(MOKOShareButtonType)type shareWithViewController:(UIViewController *)shareVC  complainType:(MOKOComplainType)complainType girlid:(NSString *)girlid indexid:(NSString *)indexid;

@end
