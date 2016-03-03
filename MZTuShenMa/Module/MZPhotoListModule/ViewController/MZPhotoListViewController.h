//
//  MZPhotoListViewController.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"

// 用于标识是否需要是公关相册
typedef NS_ENUM(NSUInteger,MZPhotoListViewControllerType) {
    MZPhotoListViewControllerTypePublicAlbum,//公共相册动态详情
    MZPhotoListViewControllerTypeNormal//普通相册动态详情
};

@interface MZPhotoListViewController : MZBaseViewController

@property (nonatomic, assign) MZPhotoListViewControllerType albumType;

//相册成员id
@property (nonatomic,copy) NSString *album_memId;

/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  相册名
 */
@property (nonatomic, copy) NSString *album_name;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *uname;



@end
