//
//  UserHelp.h
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHelp : NSObject
// -- MARK: 需要调用的
@property (nonatomic, copy) NSString * userName;

@property (nonatomic, copy) NSString * passWord;

@property (nonatomic, copy) NSString * msgCode;


// -- MARK: 用户实例

@property (nonatomic, copy) NSString * user_name;

@property (nonatomic, copy) NSString * user_img;

@property (nonatomic, copy) NSString * way;

@property (nonatomic, copy) NSString * sex;

@property (nonatomic, copy) NSString * userId;

+ (instancetype) sharedUserHelper;

@end
