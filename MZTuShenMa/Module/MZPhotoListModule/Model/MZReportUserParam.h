//
//  MZReportUserParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/17.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZReportUserParam : MZBaseRequestParam
//举报人id
@property (nonatomic,copy) NSString *user_id;
//被举报人id
@property (nonatomic,copy) NSString *album_memId;
//相册id
@property (nonatomic,copy) NSString *album_id;
@end
