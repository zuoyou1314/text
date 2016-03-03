//
//  MZNewMessageButton.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/9/15.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZNewMessageButton.h"
#import <SDWebImage/UIImage+GIF.h>

@implementation MZNewMessageButton

- (instancetype)init
{
    if(self = [super init])
    {
//        [self setFrame:CGRectMake(SCREEN_WIDTH - 56 - 20, 64 , 56, 56)];
        [self setFrame:CGRectMake(SCREEN_WIDTH - 56 - 20, 20 , 56, 56)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void) show
{
    [self setImage:[UIImage sd_animatedGIFNamed:@"Mail"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setImage:[UIImage imageNamed:@"newMessage"]];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        createRedPointImage(self);
    });
//    [appDelegate.window addSubview:self];

}

- (void) dismiss
{
    [self  removeFromSuperview];
}

void createRedPointImage(UIView *superView)
{
    CALayer *redPointLayer = [CALayer layer];
    [redPointLayer setFrame:CGRectMake(40, 7.5, 10, 10)];
    [redPointLayer setBackgroundColor:[UIColor redColor].CGColor];
    [redPointLayer setCornerRadius:5.0f];
    [superView.layer addSublayer:redPointLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(newMessageButtonTouchUpInside:)])
    {
        [self removeFromSuperview];
        [self.delegate newMessageButtonTouchUpInside:self];
    }
}
@end
