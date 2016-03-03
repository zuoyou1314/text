//
//  MZPhotoDetailParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/2.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZPhotoDetailParam : MZBaseRequestParam

//相册id
@property (nonatomic,copy) NSString *album_id;
//发布id
@property (nonatomic,copy) NSString *issue_id;
//用户id
@property (nonatomic,copy) NSString *user_id;
////照片id
//@property (nonatomic,copy) NSString *photo_id;



@end
