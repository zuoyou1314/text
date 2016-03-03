//
//  MZPhotoAlbumDetailViewController.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"

@interface MZPhotoAlbumDetailViewController : MZBaseViewController
/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;
///**
// *  用户ID
// */
//@property (nonatomic, copy) NSString *user_id;

//封面图片
@property (nonatomic, copy) NSString *cover_img;

@end
