//
//  MZDoUploadParam.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/14.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseRequestParam.h"
#import "MZLoginParam.h"
@interface MZDoUploadParam : MZBaseRequestParam

//用户id
@property (nonatomic,copy) NSString *user_id;
//相册id
@property (nonatomic,copy) NSString *album_id;
//类型(1.照片 2.录音)
@property (nonatomic,copy) NSString *type;
////登录方式
//@property (nonatomic, assign) loginWay way;
//发布标识  （0.不生成新的发布数据   1.生成一条新的发布数据） 更新为（1.生成一条新的发布数据 2.不生成新的发布数据 ）
@property (nonatomic,copy) NSString *code;
// 照片地理位子
@property (nonatomic,copy) NSString *position;
//发布id 可选参数：【第一次请求接口的时候可以不带或者设为0】
@property (nonatomic,copy) NSString *issue_id;
/**
 *  当在公共相册内上传照片的时候带上此参数，参数值为common，普通相册上传时不带
 */
@property (nonatomic, copy) NSString *upload_type;

@end
