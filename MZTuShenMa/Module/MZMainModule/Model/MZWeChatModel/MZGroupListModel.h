//
//  MZGroupListModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZGroupListModel : NSObject
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *user_img;
/**
 *  发布照片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  群聊id
 */
@property (nonatomic, copy) NSString *groupListId;
/**
 *  发布id（照片id）
 */
@property (nonatomic, copy) NSString *issue_id;
/**
 *  内容
 */
@property (nonatomic, copy) NSString *discuss;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  回复评论的内容
 */
@property (nonatomic, strong) NSArray *reply;
/**
 *  数据类型（ 1.群聊  2.点赞  3.发布回复评论  4.加入相册）
 */
@property (nonatomic, copy) NSString *type;
/**
 *  数据类型判断提示
 */
@property (nonatomic, copy) NSString *desc;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *name;

@end
