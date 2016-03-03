//
//  MZWeChatViewController.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/20.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"

@interface MZWeChatViewController : MZBaseViewController
/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  相册名
 */
@property (nonatomic, copy) NSString *album_name;
//群聊id
@property (nonatomic,copy) NSString *group_id;

@property (nonatomic, strong) NSString *tonick;


- (instancetype)initWithAlbum_id:(NSString *)album_id album_name:(NSString *)album_name;

@end
