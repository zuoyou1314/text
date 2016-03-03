//
//  MZPhoneValidateParam.h
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZPhoneValidateParam : MZBaseRequestParam
// -- 手机号
@property (nonatomic, copy) NSString * phone;

//密码重置参数    (1.重置密码)可选参数
@property (nonatomic,copy) NSString *reset;

@end
