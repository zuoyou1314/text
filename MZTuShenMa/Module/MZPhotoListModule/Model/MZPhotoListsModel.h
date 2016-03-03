//
//  MZPhotoListsModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/17.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZPhotoListsModel : NSObject

@property (nonatomic, copy) NSString *issue_id;

@property (nonatomic, copy) NSString *path_img;

@property (nonatomic, copy) NSString *path_video;
//照片id
@property (nonatomic, copy) NSString *photo_id;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, strong) NSArray *speechLists;

@property (nonatomic, copy) NSString *type;
//点赞数
@property (nonatomic, assign) NSInteger goods;
//评论数
@property (nonatomic, assign) NSInteger comments;




////相册id
//@property (nonatomic, copy) NSString *album_id;
///**
// *  照片
// */
//@property (nonatomic, copy) NSString *path_img;
//
//@property (nonatomic, copy) NSString *user_id;


@end
