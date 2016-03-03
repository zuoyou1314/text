//
//  MZGroupListParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZGroupListParam : MZBaseRequestParam
//相册id
@property (nonatomic,copy) NSString *album_id;
//用户id
@property (nonatomic,copy) NSString *user_id;
//（page 默认是第1页）
@property (nonatomic,assign) NSInteger page;


@end
