//
//  MZPhotoAlbumDetailsParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZPhotoAlbumDetailsParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//相册id
@property (nonatomic,copy) NSString *album_id;


@end
