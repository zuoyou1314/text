//
//  MZIssueListsModel.h
//  MZTuShenMa
//
//  Created by zuo on 16/1/14.
//  Copyright © 2016年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZIssueListsModel : NSObject

//发布id（照片id）
@property (nonatomic, copy) NSString *photoId;
//发布时间
@property (nonatomic, copy) NSString *time;
//发布者用户id
@property (nonatomic, copy) NSString *issue_user_id;
//发布的图片
@property (nonatomic, strong) NSMutableArray *photoLists;

@end
