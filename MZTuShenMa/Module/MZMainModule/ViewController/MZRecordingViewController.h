//
//  MZRecordingViewController.h
//  MZTuShenMa
//
//  Created by zuo on 15/11/30.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"

// 用于标识是否需要是公关相册
typedef NS_ENUM(NSUInteger,MZRecordingViewControllerType) {
    MZRecordingViewControllerTypePublicAlbum,//公共相册动态详情
    MZRecordingViewControllerTypeNormal//普通相册动态详情
};

@interface MZRecordingViewController : MZBaseViewController

@property (nonatomic, assign) MZRecordingViewControllerType albumType;

/**
 *  照片资源
 */
@property (nonatomic,strong)NSMutableArray * assets;
/**
 *  保存选中的图片
 */
@property (nonatomic , strong) NSMutableArray *selectAssets;

/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;

@end
