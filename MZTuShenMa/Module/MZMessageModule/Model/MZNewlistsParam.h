//
//  MZNewlistsParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/6.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZNewlistsParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//分辨你是查新消息还是历史消息  0：新消息  1：历史消息
@property (nonatomic,copy) NSString *code;


@end
