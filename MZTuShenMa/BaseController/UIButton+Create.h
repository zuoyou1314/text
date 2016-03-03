//
//  UIButton+Create.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)

/**
 *  创建UIButton
 *
 *  @param normal    图片名字
 *  @param highlited 高亮的图片名字
 *  @param target    目标
 *  @param action    button响应方法
 *
 *  @return 返回一个button
 */

+ (UIButton *)createButtonWithNormalImage:(NSString *)normal
                           highlitedImage:(NSString *)highlited
                                   target:(id)target
                                   action:(SEL)action;

@end
