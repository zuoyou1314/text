//
//  MZEditAlbumParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZEditAlbumParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//相册id
@property (nonatomic,copy) NSString *album_id;
//相册名
@property (nonatomic,copy) NSString *album_name;
//用户昵称
@property (nonatomic,copy) NSString *uname;
//是否推送消息    0.推送 1.不推送
@property (nonatomic,copy) NSString *push;
//相册描述
@property (nonatomic,copy) NSString *album_des;

@end
