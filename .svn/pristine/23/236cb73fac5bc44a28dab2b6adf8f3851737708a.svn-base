//
//  MZHomeFootAnimationButton.h
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZHomeFootAnimationButtonDelegate <NSObject>

- (void) assetsButtonTouchUpInside:(UIButton *)button;

- (void) phoneButtonTouchUpInside:(UIButton *)button;

@end

@interface MZHomeFootAnimationButton : UIView

@property (nonatomic, assign) id <MZHomeFootAnimationButtonDelegate> delegate;

+ (void) showWithDelegate:(id<MZHomeFootAnimationButtonDelegate>)delegate;

+ (void) hide;

@end
