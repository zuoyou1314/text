//
//  MZFeedbackParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/7.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZFeedbackParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//反馈信息
@property (nonatomic,copy) NSString *fank;
//联系方式
@property (nonatomic,copy) NSString *contact;

@end
