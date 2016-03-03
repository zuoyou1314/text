//
//  MZShareParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZShareParam : MZBaseRequestParam
/**
 *  发布id
 */
@property (nonatomic, copy) NSString *issue_id;
/**
 *  相册id
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  参数
 */
@property (nonatomic, copy) NSString *code;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *user_id;

@end
