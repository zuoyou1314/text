//
//  UIView+MDWCategory.m
//  MM
//
//  Created by Justin Yuan on 15/1/25.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import "UIView+MDWCategory.h"

@implementation UIView(MDWCategory)

- (CGFloat)bottom
{
    return self.frame.origin.y+self.frame.size.height;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x+self.frame.size.width;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGPoint)centerPositionForSubview
{
    return CGPointMake((self.frame.size.width/2.0f), (self.frame.size.height/2.0f));
}

- (void)setOrigin:(CGPoint)point
{
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (void)placeNextTo:(UIView *)anchor offset:(CGPoint)offset
{
    self.frame = CGRectMake(anchor.frame.origin.x+anchor.frame.size.width+offset.x, anchor.frame.origin.y+offset.y, self.frame.size.width, self.frame.size.height);
}

- (void)changeWidth:(CGFloat)newWidth
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
}

- (void)changeHeight:(CGFloat)newHeight
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
}
/**
 *  视图渐现动画
 *
 *  @param view     视图
 *  @param time     动画进行时间
 *  @param delegate 设置delegate动画结束后的操作
 */
- (void)ShowView:(UIView *)view During:(float)time delegate:(id)delegate{
    [UIView beginAnimations:@"SHOW_VIEW" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if(delegate !=nil &&[delegate respondsToSelector:@selector(onAnimationComplete:finished:context:)]){
        [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
        [UIView setAnimationDelegate:delegate];
    }
    view.hidden = NO;
    view.layer.opacity = 1.0;
    [UIView commitAnimations];
}

/**
 *  视图渐隐动画
 *
 *  @param view     视图
 *  @param time     动画进行的时间
 *  @param delegate 设置delegate动画结束后的操作
 */
- (void)HiddenView:(UIView *)view During:(float)time delegate:(id)delegate{
    [UIView beginAnimations:@"HIDDEN_VIEW" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if(delegate !=nil &&[delegate respondsToSelector:@selector(onAnimationComplete:finished:context:)]){
        [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
        [UIView setAnimationDelegate:delegate];
    }
    view.layer.opacity = 0.4;
    [UIView commitAnimations];
}

@end

@implementation UIImageView(MDWCategory)

- (void)circleShape
{
    self.layer.cornerRadius = self.frame.size.width/2.0f;
    self.layer.masksToBounds = YES;
}


@end