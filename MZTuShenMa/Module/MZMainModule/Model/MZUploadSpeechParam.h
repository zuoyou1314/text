//
//  MZUploadSpeechParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/12/14.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZUploadSpeechParam : MZBaseRequestParam
///**
// *  发布id
// */
//@property (nonatomic, copy) NSString *issue_id;
/**
 *  照片id
 */
@property (nonatomic, copy) NSString *photo_id;
///**
// *  照片标识（例：path_img，path_img_2...）
// */
//@property (nonatomic, copy) NSString *photo_num;
/**
 *  横坐标
 */
@property (nonatomic, copy) NSString *coords_x;
/**
 *  纵坐标
 */
@property (nonatomic, copy) NSString *coords_y;
/**
 *  录音时长
 */
@property (nonatomic, copy) NSString *track;
@end
