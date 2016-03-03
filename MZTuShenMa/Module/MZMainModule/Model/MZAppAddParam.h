//
//  MZAppAddParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/11/16.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZAppAddParam : MZBaseRequestParam
/**
 *  相册id
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  用户id(可选)
 */
@property (nonatomic, copy) NSString *user_id;
@end
