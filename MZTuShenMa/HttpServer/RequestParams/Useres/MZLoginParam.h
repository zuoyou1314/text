//
//  MZLoginParam.h
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

typedef NS_ENUM(NSInteger, loginWay)
{
    phoneNumType = 1,
    qqType,
    wxType,
    sinaType,
};

@interface MZLoginParam : MZBaseRequestParam
// -- MARK: 手机号 第三方登录固定值
@property (nonatomic, copy) NSString *account;

@property (nonatomic, assign) loginWay way;

@property (nonatomic, copy) NSString *pass;
//用户设备号
@property (nonatomic, copy) NSString *device_id;

//第三方获取到的图片地址
@property (nonatomic, copy) NSString *user_img;
//第三方获取到的用户性别
@property (nonatomic, copy) NSString *sex;
//第三方获取到的用户名称
@property (nonatomic, copy) NSString *user_name;
//ios版本号
@property (nonatomic, copy) NSString *ios;


@end
