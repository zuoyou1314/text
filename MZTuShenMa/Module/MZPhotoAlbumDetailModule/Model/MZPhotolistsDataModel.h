//
//  MZPhotolistsDataModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/1.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZPhotolistsDataModel : NSObject
/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger comments;
/**
 *  照片地址
 */
@property (nonatomic, copy) NSString *user_img;

/**
 *  照片id
 */
@property (nonatomic, copy) NSString *photoId;
/**
 *  上传时间
 */
@property (nonatomic, copy) NSString *upload_time;
/**
 *  点赞数
 */
@property (nonatomic, assign) NSInteger goods;
/**
 *  删除数量
 */
@property (nonatomic, assign) NSInteger is_delete;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *uname;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *user_name;

@end
