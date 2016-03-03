//
//  MZPushNotificationView.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPushNotificationView.h"

@interface MZPushNotificationView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineOfHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineOfHeight;


@end


@implementation MZPushNotificationView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZPushNotificationView" owner:self options:nil] lastObject];
        [self setFrame:frame];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    _topLineOfHeight.constant = 0.5;
    _bottomLineOfHeight.constant = 0.5;
}
- (IBAction)didClickPushSwitchAction:(id)sender {
    NSLog(@"退出相册");
    UISwitch *pushSwitch = (UISwitch *)sender;
    if (_delegate && [_delegate respondsToSelector:@selector(clickPushSkitch:)]) {
        [_delegate clickPushSkitch:pushSwitch];
    }
}

@end
