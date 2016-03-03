//
//  MOKOPictureBrowsingViewController.h
//  MOKODreamWork_iOS2
//
//  Created by _SS on 15/7/22.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZPhotoListsModel.h"


// 用于标识是否需要是公关相册
typedef NS_ENUM(NSUInteger,MOKOPictureBrowsingViewControllerType) {
    MOKOPictureBrowsingViewControllerTypePublicAlbum,//公共相册动态详情
    MOKOPictureBrowsingViewControllerTypeNormal//普通相册动态详情
};

@protocol MOKOPictureBrowsingViewControllerDelegate <NSObject>

- (void)clickGoodButtonAction:(UIButton *)button;

- (void)clickCommentButtonAction:(UIButton *)button;

@end


@interface MOKOPictureBrowsingViewController : UIViewController


@property (nonatomic, assign) MOKOPictureBrowsingViewControllerType albumType;
/**
 *  存放model的数组
 */
@property (nonatomic, strong) NSArray *modelArray;
/**
 *  图片url集合
 */
@property (nonatomic, copy) NSArray *imgeurlArray;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray *imagesArray;
/**
 *  点击第几张图片推出来次浏览页面
 */
@property (nonatomic, assign) NSUInteger indexNumber;
/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;




@property (nonatomic,assign) id<MOKOPictureBrowsingViewControllerDelegate>delegate;

@property (nonatomic,assign) BOOL isHidden;

@property (nonatomic,strong) UIButton *goodButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIButton *shareButton;
@property (nonatomic,strong) UIButton *downloadButton;
@property (nonatomic,strong) UIButton *coverButton;

- (instancetype)initWithHidden:(BOOL)hidden;


@end
