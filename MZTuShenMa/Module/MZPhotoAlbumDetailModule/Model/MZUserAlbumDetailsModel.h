//
//  MZUserAlbumDetailsModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZUserAlbumDetailsModel : NSObject
/**
 * 是否显示昵称   0.不显示  1.显示
 */
@property (nonatomic, copy) NSString *is_name;
/**
 * 用户id
 */
@property (nonatomic, copy) NSString *uid;
/**
 * 
 */
@property (nonatomic, copy) NSString *userAlbumDetailsId;
/**
 * 相册id
 */
@property (nonatomic, copy) NSString *aid;
/**
 * 相册名
 */
@property (nonatomic, copy) NSString *album_name;
/**
 * 相册描述
 */
@property (nonatomic, copy) NSString *album_des;
/**
 * 用户昵称
 */
@property (nonatomic, copy) NSString *uname;
/**
 *  相册最后一次打开时间
 */
@property (nonatomic, copy) NSString *open_time;
/**
 *  默认为0  表示推送消息
 */
@property (nonatomic, copy) NSString *push;

@end
