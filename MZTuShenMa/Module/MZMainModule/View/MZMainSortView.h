//
//  MZMainSortView.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZMainSortViewDelegate <NSObject>


- (void)clickCreatePhotoButtonEvent;

- (void)clickUpdatePhotoButtonEvent;

@end


@interface MZMainSortView : UIView

@property (nonatomic,assign) id<MZMainSortViewDelegate>delegate;

- (void)show;

@end
