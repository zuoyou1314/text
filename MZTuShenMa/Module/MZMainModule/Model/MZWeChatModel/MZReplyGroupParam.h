//
//  MZReplyGroupParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZReplyGroupParam : MZBaseRequestParam

//相册id
@property (nonatomic,copy) NSString *album_id;
//用户id
@property (nonatomic,copy) NSString *user_id;
//发送内容
@property (nonatomic,copy) NSString *discuss;
//群聊id
@property (nonatomic,copy) NSString *group_id;

@end
