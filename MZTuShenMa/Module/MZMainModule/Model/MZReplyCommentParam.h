//
//  MZReplyCommentParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/8.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZReplyCommentParam : MZBaseRequestParam
//相册id
@property (nonatomic,copy) NSString *album_id;
//照片id
@property (nonatomic,copy) NSString *issue_id;
//自己的id
@property (nonatomic,copy) NSString *user_id;
//回复id
@property (nonatomic,copy) NSString *comment_id;
//群聊id
@property (nonatomic,copy) NSString *group_id;
//评论人id
@property (nonatomic,copy) NSString *comment_user_id;
//回复内容
@property (nonatomic,copy) NSString *discuss;


@end
