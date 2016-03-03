//
//  MZOneMoreView.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/28.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZOneMoreViewDelegate <NSObject>

- (void)clickOneButtonAction:(UIButton *)button;

@end

@interface MZOneMoreView : UIView


@property (nonatomic,assign) id<MZOneMoreViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;


- (void)show;

@end
