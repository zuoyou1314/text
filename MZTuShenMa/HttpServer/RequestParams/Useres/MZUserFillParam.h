//
//  MZUserFillParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/13.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"
#import "MZLoginParam.h"
@interface MZUserFillParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//登录方式    1.手机号 2.qq号 3.微信号  4.微博号
@property (nonatomic, assign) loginWay way;
//用户名
@property (nonatomic,copy) NSString *user_name;
//性别   （1.男  2.女）
@property (nonatomic,copy) NSString *sex;


@end
