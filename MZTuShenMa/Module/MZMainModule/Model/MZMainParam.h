//
//  MZMainParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/31.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"

@interface MZMainParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//排序方式 (create_time 创建时间 update_time更新时间 )
@property (nonatomic,copy) NSString *type;

@property (nonatomic,assign) NSInteger page;

@end
