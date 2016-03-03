
//
//  MZReplyListsModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/17.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZReplyListsModel : NSObject
//回复人头像
@property (nonatomic, copy) NSString *user_img;

@property (nonatomic, copy) NSString *replyListsId;
//是否有权力删除这条回复  0.没有  1.有
@property (nonatomic, copy) NSString *is_look;

@property (nonatomic, strong) NSArray *children;

@property (nonatomic, copy) NSString *photo_id;
//回复内容
@property (nonatomic, copy) NSString *discuss;
//回复人id
@property (nonatomic, copy) NSString *user_id;
//回复人
@property (nonatomic, copy) NSString *uname;
//回复时间
@property (nonatomic, copy) NSString *dis_time;
//被回复人
@property (nonatomic, copy) NSString *cname;
//被回复人id
@property (nonatomic, copy) NSString *pid;

@end
