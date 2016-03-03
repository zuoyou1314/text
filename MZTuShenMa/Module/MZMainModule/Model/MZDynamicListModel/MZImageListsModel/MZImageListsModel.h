//
//  MZImageListsModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/12.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZImageListsModel : NSObject

@property (nonatomic, copy) NSString *album_id;

@property (nonatomic, copy) NSString *is_del;

//@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *upload_time;


@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *issue_id;


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
