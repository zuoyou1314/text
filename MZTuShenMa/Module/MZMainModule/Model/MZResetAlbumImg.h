//
//  MZResetAlbumImg.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/15.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZResetAlbumImg : MZBaseRequestParam
////照片id
//@property (nonatomic,copy) NSString *img_id;
//相册id
@property (nonatomic,copy) NSString *album_id;
////第几张照片
//@property (nonatomic,copy) NSString *num;
//照片url
@property (nonatomic,copy) NSString *img_url;
//用户id
@property (nonatomic,copy) NSString *user_id;


@end
