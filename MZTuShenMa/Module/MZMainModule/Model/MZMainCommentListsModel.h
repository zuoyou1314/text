//
//  MZMainCommentListsModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZMainCommentListsModel : NSObject
/**
 *  这条评论的用户id
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  这条评论的id
 */
@property (nonatomic, copy) NSString *common_id;
/**
 *  这条评论的群聊id
 */
@property (nonatomic, copy) NSString *group_id;
/**
 *  照片id
 */
@property (nonatomic, copy) NSString *photo_id;
/**
 *  头像
 */
@property (nonatomic, copy) NSString *user_img;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *discuss;
/**
 *  前面评论人或者回复人名字
 */
@property (nonatomic, copy) NSString *uname;
/**
 *  时间
 */
@property (nonatomic, copy) NSString *dis_time;
/**
 *  type 等于0的情况下表示此条信息是评论  1  表示回复
 */
@property (nonatomic, assign) NSInteger type;
/**
 *  回复给谁的名字
 */
@property (nonatomic, copy) NSString *cname;







@end
