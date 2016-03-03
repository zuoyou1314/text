//
//  MZPhotolistsParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/1.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZPhotolistsParam : MZBaseRequestParam

//相册id
@property (nonatomic,copy) NSString *album_id;
//用户id    //用来判读用户是否有删除照片的权力
@property (nonatomic,copy) NSString *user_id;


@end
