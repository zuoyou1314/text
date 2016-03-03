//
//  UIButton+MZRepeatClickButton.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/29.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MZRepeatClickButton)

//  再次接受Event的间隔. 可以用这个给UIButton的重复点击加间隔.
@property (nonatomic, assign) NSTimeInterval uxy_acceptEventInterval;

@end
