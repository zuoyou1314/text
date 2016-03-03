//
//  MZForgetPasswordParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/11.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZForgetPasswordParam : MZBaseRequestParam

//手机号
@property (nonatomic,copy) NSString *phone;
//密码
@property (nonatomic,copy) NSString *pass;
//注册方式    1.手机号 2.qq号 3.微信号  4.微博号
@property (nonatomic,copy) NSString *way;
//密码重置参数    (1.重置密码)可选参数
@property (nonatomic,copy) NSString *reset;

@property (nonatomic, copy) NSString *device_id;


@end
