//
//  MZNewlistsModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/6.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZNewlistsModel : NSObject

//点赞的消息
@property (nonatomic, copy) NSString *user_img;

@property (nonatomic, copy) NSString *gid;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *path_img;



//评论的消息
@property (nonatomic, copy) NSString *discuss;

@property (nonatomic, copy) NSString *cid;


//@property (nonatomic, copy) NSString *cname;

//相册ID
@property (nonatomic, copy) NSString *album_id;
//照片id
@property (nonatomic, copy) NSString *photo_id;


//回复的消息
@property (nonatomic, copy) NSString *c_img;

//@property (nonatomic, copy) NSString *r_img;

//@property (nonatomic, copy) NSString *rname;

//@property (nonatomic, copy) NSString *pid;



@property (nonatomic, copy) NSString *rid;

//@property (nonatomic, copy) NSString *rep_time;



@end
