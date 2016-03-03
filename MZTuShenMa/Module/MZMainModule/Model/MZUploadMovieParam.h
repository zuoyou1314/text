//
//  MZUploadMovieParam.h
//  MZTuShenMa
//
//  Created by zuo on 16/1/17.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZUploadMovieParam : MZBaseRequestParam
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *user_id;
//相册id
@property (nonatomic,copy) NSString *album_id;

///**
// *  照片id
// */
//@property (nonatomic, copy) NSString *photo_id;

/**
 *  当在公共相册内上传照片的时候带上此参数，参数值为common，普通相册上传时不带
 */
@property (nonatomic, copy) NSString *upload_type;





/**
 *  类型(1.照片 2.录音,3.视频)
 */
@property (nonatomic, copy) NSString *type;

@end
