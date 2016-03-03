//
//  UIButton+Create.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)

+ (UIButton *)createButtonWithNormalImage:(NSString *)normal
                           highlitedImage:(NSString *)highlited
                                   target:(id)target
                                   action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normal.length > 0) {
        UIImage *normalImage = [self imageWithName:normal];
        [button setImage:normalImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, normalImage.size.width/2, normalImage.size.height/2);
    }
    if (highlited.length > 0) {
        UIImage *highlightImage = [self imageWithName:highlited];
        [button setImage:highlightImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//根据文件名获取图片
+ (UIImage *)imageWithName:(NSString *)name
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:NSLocalizedString(name,@"适配") ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}


@end
