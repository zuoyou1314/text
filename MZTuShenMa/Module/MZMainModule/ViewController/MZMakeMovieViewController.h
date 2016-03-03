//
//  MZMakeMovieViewController.h
//  MZTuShenMa
//
//  Created by zuo on 16/1/12.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZBaseViewController.h"

// 用于标识是否需要是公关相册
typedef NS_ENUM(NSUInteger,MZMakeMovieViewControllerType) {
    MZMakeMovieViewControllerTypePublicAlbum,//公共相册动态详情
    MZMakeMovieViewControllerTypeNormal//普通相册动态详情
};

@interface MZMakeMovieViewController : MZBaseViewController

@property (nonatomic, copy) NSString *album_id;

@property (nonatomic, assign) MZMakeMovieViewControllerType albumType;





@end
