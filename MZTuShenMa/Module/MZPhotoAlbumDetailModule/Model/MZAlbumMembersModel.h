//
//  MZAlbumMembersModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZAlbumMembersModel : NSObject
//相册成员ID
@property (nonatomic, copy) NSString *uid;
//相册成员头像
@property (nonatomic, copy) NSString *user_img;
//相册成员名字
@property (nonatomic, copy) NSString *user_name;

@end
