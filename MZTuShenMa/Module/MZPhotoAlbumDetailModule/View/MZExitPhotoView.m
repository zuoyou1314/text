//
//  MZExitPhotoView.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZExitPhotoView.h"

@implementation MZExitPhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZExitPhotoView" owner:self options:nil] lastObject];
        [self setFrame:frame];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
//    _exitButton.layer.cornerRadius = 25;
//    _exitButton.layer.masksToBounds = YES;
}
- (IBAction)didClickExitButtonAction:(id)sender {
    NSLog(@"退出相册");
    if (_delegate && [_delegate respondsToSelector:@selector(clickExitButtonAction)]) {
        [_delegate clickExitButtonAction];
    }
}

@end
