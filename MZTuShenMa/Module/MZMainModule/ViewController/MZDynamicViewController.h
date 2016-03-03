//
//  MZDynamicViewController.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/20.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MDWPageView.h"

@interface MZDynamicViewController : MDWPageView
/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;
///**
// *  用户ID
// */
//@property (nonatomic, copy) NSString *uid;
/**
 *  相册名
 */
@property (nonatomic, copy) NSString *album_name;
/**
 *  封面图片
 */
@property (nonatomic, copy) NSString *cover_img;

- (instancetype)initWithAlbum_id:(NSString *)album_id album_name:(NSString *)album_name;
@end
