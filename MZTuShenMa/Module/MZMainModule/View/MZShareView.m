//
//  MZShareView.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/14.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZShareView.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface MZShareView ()
@property (weak, nonatomic) IBOutlet UIView *customView;

@property (weak, nonatomic) IBOutlet UIButton *wechatButton;

@property (weak, nonatomic) IBOutlet UIButton *wechatFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end


@implementation MZShareView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZShareView" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    
//    _creatPhotoButton.layer.borderWidth= 1.0f;
//    _creatPhotoButton.layer.cornerRadius = 25;
//    _creatPhotoButton.layer.masksToBounds = YES;
//    
//    _updatePhotoButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
//    _updatePhotoButton.layer.borderWidth= 1.0f;
//    _updatePhotoButton.layer.cornerRadius = 25;
//    _updatePhotoButton.layer.masksToBounds = YES;
//    
//    _cancelButton.layer.cornerRadius = 25;
//    _cancelButton.layer.masksToBounds = YES;
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
     self.backgroundColor = RGBA(0, 0, 0, 0.1);
    [UIView animateWithDuration:0.5 animations:^{
         self.backgroundColor = RGBA(0, 0, 0, 0.4);
        _customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _customView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.1);
        _customView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _customView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


- (IBAction)didClickWeChatButtonAction:(id)sender {
    NSLog(@"微信分享");
    if (_delegate  &&[_delegate respondsToSelector:@selector(clickWechatButtonAction)]) {
        [self dismiss];
        [_delegate  clickWechatButtonAction];
       
    }

}
- (IBAction)didClickWeChatFriendButtonAction:(id)sender {
    NSLog(@"朋友圈分享");
    if (_delegate  &&[_delegate respondsToSelector:@selector(clickWechatFriendButtonAction)]) {
        [self dismiss];
        [_delegate  clickWechatFriendButtonAction];
    }

}
- (IBAction)didClickCancelButtonAction:(id)sender {
    NSLog(@"取消");
     [self dismiss];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

//找任意view所在控制器的方法
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
