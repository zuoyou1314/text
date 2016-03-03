//
//  MZDeleteAlbumMemberParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZDeleteAlbumMemberParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//相册id
@property (nonatomic,copy) NSString *album_id;
//被删除人id（如果是用户退出相册，user_id与del_id应该一样）
@property (nonatomic,copy) NSString *del_id;
@end
