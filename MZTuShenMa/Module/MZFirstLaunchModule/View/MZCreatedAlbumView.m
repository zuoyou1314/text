//
//  MZCreatedAlbumView.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZCreatedAlbumView.h"

@implementation MZCreatedAlbumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZCreatedAlbumView" owner:self options:nil] lastObject];
        self.backgroundColor = RGBA(0, 0, 0, 0.7);
    }
    return self;
}


- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}



@end
