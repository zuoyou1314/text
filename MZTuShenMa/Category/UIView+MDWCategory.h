//
//  UIView+MDWCategory.h
//  MM
//
//  Created by Justin Yuan on 15/1/25.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIViewDelegate <NSObject>
/**
 *  图片渐隐渐现效果出现后执行的操作
 *
 *  @param animationID 动画名字 @"SHOW_VIEW" @"HIDDEN_VIEW"
 *  @param finished    <#finished description#>
 *  @param context     <#context description#>
 */
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end

@interface UIView(MDWCategory)

- (CGPoint)centerPositionForSubview;
- (CGFloat)bottom;
- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)right;

- (CGFloat)width;
- (CGFloat)height;

- (void)placeNextTo:(UIView *)anchor offset:(CGPoint)offset;
- (void)setOrigin:(CGPoint)point;

- (void)changeWidth:(CGFloat)newWidth;
- (void)changeHeight:(CGFloat)newHeight;

- (void)ShowView:(UIView *)view During:(float)time delegate:(id)delegate;
- (void)HiddenView:(UIView *)view During:(float)time delegate:(id)delegate;

@property (nonatomic, assign) id<UIViewDelegate> imageviewDelegate;

@end

@interface UIImageView(MDWCategory)

- (void)circleShape;

@end