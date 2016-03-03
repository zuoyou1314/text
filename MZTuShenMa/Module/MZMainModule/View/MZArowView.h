//
//  MZArowView.h
//  MZTuShenMa
//
//  Created by zuo on 15/12/4.
//  Copyright © 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKAudioPlayer.h"

typedef void(^arowViewBeganBlock)(void);

typedef void(^arowViewOverBlock)(void);

// 用于标识是否需要是公关相册
typedef NS_ENUM(NSUInteger,MZArowViewType) {
    MZArowViewTypePublicAlbum,//动态详情播放
    MZArowViewTypeNormal//普通播放
};

@interface MZArowView : UIView

@property (nonatomic, copy) arowViewBeganBlock arowViewBeganBlocks;

@property (nonatomic, copy) arowViewOverBlock arowViewOverBlocks;

@property (nonatomic, assign) MZArowViewType type;

@property (nonatomic , strong) UIImageView *lightImageView;
@property (nonatomic , strong) UIButton *leftArrowButton;
@property (nonatomic , strong) UIButton *rightArrowButton;

@property (nonatomic, strong) NSURL *speechPathUrl;


- (void)stopPlay;


@end
