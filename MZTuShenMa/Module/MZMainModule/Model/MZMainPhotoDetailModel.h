//
//  MZMainPhotoDetailModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZMainPhotoDetailModel : NSObject
/**
 *  相册id
 */
@property (nonatomic, copy) NSString *album_id;
///**
// *  照片id
// */
//@property (nonatomic, copy) NSString *photoDetailId;
/**
 *  发布id
 */
@property (nonatomic, copy) NSString *issue_id;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *uname;
/**
 *  上传时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  发布者id
 */
@property (nonatomic, copy) NSString *issue_user_id;
///**
// *  照片地址
// */
//@property (nonatomic, copy) NSString *path_img;
/**
 *  用户图像
 */
@property (nonatomic,copy) NSString *user_img;
/**
 *  封面图片
 */
@property (nonatomic, strong) NSMutableArray *lists;
/**
 *  存放语音标签的数组
 */
@property (nonatomic, strong) NSMutableArray *have_speech;





//@property (nonatomic, copy) NSString *is_del;
//
@property (nonatomic, copy) NSString *thumb_img;
//
//@property (nonatomic, assign) NSInteger weight;
//
//@property (nonatomic, assign) NSInteger height;




@end
