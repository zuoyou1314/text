//
//  MZAlbumUserPhotosParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZAlbumUserPhotosParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//相册成员id
@property (nonatomic,copy) NSString *album_memId;
//相册id
@property (nonatomic,copy) NSString *album_id;
//
@property (nonatomic,assign) NSInteger page;

@end
