//
//  MZListsModel.h
//  MZTuShenMa
//
//  Created by zuo on 16/1/14.
//  Copyright © 2016年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZListsModel;
@interface MZListsModel : NSObject
//照片id
@property (nonatomic, copy) NSString *photoId;

@property (nonatomic, copy) NSString *issue_id;

@property (nonatomic, copy) NSString *path_img;

@property (nonatomic, copy) NSString *path_img_self;

@property (nonatomic, copy) NSString *path_video;

@property (nonatomic, copy) NSString *path_video_self;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, strong)NSMutableArray *speechLists;

// type 1 图片 2音屏 3声音
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *width;

@property (nonatomic, copy) NSString *rbg;

@property (nonatomic, copy) NSString *height;

@end

