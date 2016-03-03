//
//  MZAddCommentParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/8.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZAddCommentParam : MZBaseRequestParam
//相册id
@property (nonatomic,copy) NSString *album_id;
//发布id
@property (nonatomic,copy) NSString *issue_id;
//用户id
@property (nonatomic,copy) NSString *user_id;
//发布者id
@property (nonatomic,copy) NSString *issue_user_id;
//评论
@property (nonatomic,copy) NSString *discuss;



@end
