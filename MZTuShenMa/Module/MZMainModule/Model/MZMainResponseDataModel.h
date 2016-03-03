//
//  MZMainResponseDataModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/31.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZMainResponseDataModel : NSObject

/**
 *  是否推送
 */
@property (nonatomic, copy) NSString *push;
/**
 *  更新时间
 */
@property (nonatomic, copy) NSString *update_time;
/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  相册描述
 */
@property (nonatomic, copy) NSString *album_des;
/**
 *  相册封面
 */
@property (nonatomic, copy) NSString *cover_img;
/**
 *  相册成员数
 */
@property (nonatomic, copy) NSString *members;
/**
 *  相册最后一次打开时间（测试用）
 */
@property (nonatomic, copy) NSString *open_time;
/**
 *  相册名
 */
@property (nonatomic, copy) NSString *album_name;
/**
 *  相册更新照片数
 */
@property (nonatomic, assign) NSInteger update_photos;
/**
 *  相册照片数
 */
@property (nonatomic, copy) NSString *photos;
/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  相册状态  0 正常 1 删除
 */
@property (nonatomic, copy) NSString *status;
/**
 *  头像
 */
@property (nonatomic, copy) NSString *my_imgPath;


@end
