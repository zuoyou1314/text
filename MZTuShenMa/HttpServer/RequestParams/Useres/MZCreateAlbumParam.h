//
//  MZCreateAlbumParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/31.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZCreateAlbumParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//相册名
@property (nonatomic,copy) NSString *album_name;
//相册描述
@property (nonatomic,copy) NSString *album_des;


@end
