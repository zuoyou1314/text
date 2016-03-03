//
//  UIButton+MZRepeatClickButton.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/29.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "UIButton+MZRepeatClickButton.h"
#import <objc/runtime.h>

@implementation UIButton (MZRepeatClickButton)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

- (NSTimeInterval)uxy_acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setUxy_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(uxy_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__uxy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}



- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    //取当前时间的秒数 -
    if (NSDate.date.timeIntervalSince1970 - self.uxy_acceptEventInterval < self.uxy_acceptEventInterval){
        
        return;
    }
    
    if (self.uxy_acceptEventInterval > 0)
    {
        self.uxy_acceptEventInterval = NSDate.date.timeIntervalSince1970;
    }
    
    [self __uxy_sendAction:action to:target forEvent:event];
}





@end
