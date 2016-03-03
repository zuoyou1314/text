//
//  MZBaseResponse.h
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseModel.h"

@interface MZBaseResponse : MZBaseModel

@property (nonatomic,strong) id bodyType;

@property (nonatomic, strong) NSMutableArray *body;

@property (nonatomic, copy) NSString * errMsg;

@property (nonatomic, copy) NSString * errCode;



- (id)initWithDictionary:(NSDictionary *)jsonDic bodyType:(Class)bodyType;

@end
