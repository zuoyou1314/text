//
//  MZHomeFootAnimationButton.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZHomeFootAnimationButton.h"

NS_ENUM(NSInteger, footButtonTag)
{
    addButtonTag = 100,
    phoneButtonTag,
    AssetsButtonTag,
};

@implementation MZHomeFootAnimationButton

- (instancetype)init
{
    if(self = [super init])
    {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self setBackgroundColor:RGBA(0, 0, 0, 0)];
        [UIView animateWithDuration:.5 animations:^{
            [self setBackgroundColor:RGBA(0, 0, 0, .7)];
        }];
        [self setAnimationButton];
    }
    return self;
}

+ (void) showWithDelegate:(id<MZHomeFootAnimationButtonDelegate>)delegate
{
    MZHomeFootAnimationButton *buttonView = [[MZHomeFootAnimationButton alloc] init];
    [buttonView setDelegate:delegate];
    [appDelegate.window addSubview:buttonView];
    
    [buttonView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if(obj && [obj isKindOfClass:[UIButton class]])
       {
           UIButton *addButton = (UIButton *) obj;
           addButton.selected = NO;
           [buttonView addButtonTouchUpInside:addButton];
           *stop = YES;
       }
    }];
}

+ (void) hide
{
    [appDelegate.window.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if(obj && [obj isKindOfClass:[MZHomeFootAnimationButton class]])
       {
           MZHomeFootAnimationButton *tmpView = (MZHomeFootAnimationButton *) obj;
           [UIView animateWithDuration:.5 animations:^{
                [tmpView setBackgroundColor:RGBA(0, 0, 0, 0)];
           }];
           [tmpView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
               if(obj && [obj isKindOfClass:[UIButton class]])
               {
                   UIButton *addButton = (UIButton *) obj;
                   addButton.selected = YES;
                   [tmpView addButtonTouchUpInside:addButton];
                   *stop = YES;
               }
           }];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [tmpView removeFromSuperview];
               [tmpView setDelegate:nil];
           });
       }
    }];
}

- (void) setAnimationButton
{
    for(NSInteger i = 0; i < 3; i++)
    {
        @autoreleasepool {
            UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *tmpImage = [UIImage imageNamed:@"footAdd"];
            [footButton setBounds:CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height)];
            [footButton setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 20 - tmpImage.size.height/2)];
            [footButton setImage:tmpImage forState:UIControlStateNormal];
            [footButton setTag:i + 100];
            if(footButton.tag != phoneButtonTag && footButton.tag != AssetsButtonTag)
            {
                [footButton addTarget:self action:@selector(addButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                [footButton addTarget:self action:@selector(addButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
            }
            if(footButton.tag == phoneButtonTag)
            {
                [footButton setImage:[UIImage imageNamed:@"footMovie"] forState:UIControlStateNormal];
                [footButton setAlpha:0.0f];
                [footButton addTarget:self action:@selector(phoneButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (footButton.tag == AssetsButtonTag)
            {
                [footButton setImage:[UIImage imageNamed:@"footPhone"] forState:UIControlStateNormal];
                [footButton setAlpha:0.0f];
                [footButton addTarget:self action:@selector(assetsButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:footButton];
        }
    }
}

- (void) addButtonTouchDown:(id) sender
{
    UIButton *addButton = (UIButton *)sender;
    [UIView animateWithDuration:.3 animations:^{
        addButton.transform = CGAffineTransformScale(addButton.transform, .9, .9);
    }];
}

- (void) addButtonTouchUpInside:(id)sender
{
    if(sender && [sender isKindOfClass:[UIButton class]])
    {
        UIButton *addButton = (UIButton *)sender;
        if(addButton.selected == NO)
        {
            [UIView animateWithDuration:.3 animations:^{
                addButton.transform = CGAffineTransformMakeRotation(M_PI_4);
                addButton.transform = CGAffineTransformScale(addButton.transform, 1.0, 1.0);
            }];
            [self showButtons];
        }
        if (addButton.selected == YES)
        {
            [UIView animateWithDuration:.3 animations:^{
                addButton.transform = CGAffineTransformMakeRotation(0);
                addButton.transform = CGAffineTransformScale(addButton.transform, 1.0, 1.0);
            }];
            [self hideButtons];
        }
        [addButton setSelected:!addButton.selected];
    }
}

- (void) showButtons
{
    NSArray * arr = [self findButtonArray];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[(UIButton *)obj layer] removeAllAnimations];
    }];
    UIButton *phoneButton = arr[0];
    UIButton *phoneButton2 = arr[1];
    
    [UIView animateWithDuration:.3f animations:^{
        [phoneButton setAlpha:1.0f];
        phoneButton.transform = CGAffineTransformMakeTranslation(-80, -80);
        [phoneButton.layer addAnimation:[self setupAnimationGroup] forKey:@"tmp"];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3f animations:^{
            [phoneButton2 setAlpha:1.0f];
            phoneButton2.transform = CGAffineTransformMakeTranslation(80, -80);
            [phoneButton2.layer addAnimation:[self setupAnimationGroup] forKey:@"tmp0"];
        }];
    });
}

- (CAAnimationGroup *)setupAnimationGroup {
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.5;
    animationGroup.repeatCount = 1;
    animationGroup.removedOnCompletion = YES;
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 4.0];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    NSArray *animations = @[/*xAnimation, yAnimation,*/ rotationAnimation];
    animationGroup.animations = animations;
    
    return animationGroup;
}


- (void) hideButtons
{
    NSArray * arr = [self findButtonArray];
    UIButton *phoneButton = arr[0];
    UIButton *phoneButton2 = arr[1];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[(UIButton *)obj layer] removeAllAnimations];
    }];
    
    [UIView animateWithDuration:.3f animations:^{
        [phoneButton2 setAlpha:0.0f];
        phoneButton2.transform = CGAffineTransformMakeTranslation(0, 0);
        [phoneButton2.layer addAnimation:[self setupAnimationGroup] forKey:@"tmp"];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3f animations:^{
            [phoneButton setAlpha:0.0f];
            phoneButton.transform = CGAffineTransformMakeTranslation(0, 0);
            [phoneButton.layer addAnimation:[self setupAnimationGroup] forKey:@"tmp0"];
        }];
    });
    [appDelegate.window.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj && [obj isKindOfClass:[MZHomeFootAnimationButton class]])
        {
            MZHomeFootAnimationButton *tmpView = (MZHomeFootAnimationButton *) obj;
            [UIView animateWithDuration:.5 animations:^{
                [tmpView setBackgroundColor:RGBA(0, 0, 0, 0)];
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tmpView removeFromSuperview];
                [tmpView setDelegate:nil];
            });
        }
    }];
}

- (NSMutableArray *) findButtonArray
{
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj && [obj isKindOfClass:[UIButton class]])
        {
            if([(UIButton *)obj tag] == phoneButtonTag || [(UIButton *)obj tag] == AssetsButtonTag)
            {
                [tmpArr addObject:obj];
            }
        }
    }];
    return tmpArr;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self class] hide];
}

- (void) phoneButtonTouchUpInside:(UIButton *)button
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(phoneButtonTouchUpInside:)])
    {
        [self.delegate phoneButtonTouchUpInside:button];
    }
}

- (void) assetsButtonTouchUpInside:(UIButton *)button
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(assetsButtonTouchUpInside:)])
    {
        [self.delegate assetsButtonTouchUpInside:button];
    }
}
@end
