//
//  MZPhoneDelParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/15.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZPhoneDelParam : MZBaseRequestParam

//发布id
@property (nonatomic,copy) NSString *issue_id;
//用户id
@property (nonatomic,copy) NSString *user_id;

@end
