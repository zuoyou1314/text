//
//  MZUploadSoundModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/12/14.
//  Copyright © 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZUploadSoundModel : NSObject
/**
 *  相册id
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  当在公共相册内上传照片的时候带上此参数，参数值为common，普通相册上传时不带
 */
@property (nonatomic, copy) NSString *upload_type;
/**
 *  照片资源
 */
@property (nonatomic, strong)NSMutableArray * assets;
/**
 *  坐标资源
 */
@property (nonatomic, strong)NSDictionary *photoDic;
/**
 *  录音资源
 */
@property (nonatomic, strong)NSDictionary *recordDic;
/**
 *  录音时间
 */
@property (nonatomic, strong)NSDictionary *timeDic;
/**
 *  类型(1.照片 2.录音,3.视频)
 */
@property (nonatomic,copy) NSString *type;


@end
