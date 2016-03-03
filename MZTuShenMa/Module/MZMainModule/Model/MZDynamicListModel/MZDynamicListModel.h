//
//  MZDynamicListModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/1.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZDynamicListModel : NSObject
/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger comments;
/**
 *  照片地址
 */
@property (nonatomic, copy) NSString *user_img;
///**
// *  上传时间
// */
//@property (nonatomic, copy) NSString *upload_time;
/**
 *  上传时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  点赞数
 */
@property (nonatomic, assign) NSInteger goods;
/**
 *  是否点赞  0 没有  1.有
 */
@property (nonatomic, assign) NSInteger is_good;

/**
 *  是否有权力删除照片 1.有  0 没有
 */
@property (nonatomic, assign) NSInteger is_bos;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *uname;
/**
 *  发布者id
 */
@property (nonatomic, copy) NSString *user_id;
///**
// *  封面图片
// */
//@property (nonatomic, strong) NSMutableArray *img_lists;
/**
 *  封面图片
 */
@property (nonatomic, strong) NSMutableArray *lists;
/**
 *  存放语音标签的数组
 */
@property (nonatomic, strong) NSMutableArray *have_speech;
/**
 *  发布id
 */
@property (nonatomic, copy) NSString *issue_id;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *user_name;
/**
 *  下载用的原始图片
 */
@property (nonatomic, copy) NSString *path_img;
/**
 *  封面图片
 */
@property (nonatomic, copy) NSString *thumb_img;
///**
// *  照片id
// */
//@property (nonatomic, copy) NSString *photoId;

@end
