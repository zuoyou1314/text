//
//  MZUserEditParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"
#import "MZLoginParam.h"
@interface MZUserEditParam : MZBaseRequestParam
//用户id
@property (nonatomic,copy) NSString *user_id;

@property (nonatomic, assign) loginWay way;

@end
