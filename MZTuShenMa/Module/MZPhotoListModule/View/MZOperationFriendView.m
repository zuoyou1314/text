//
//  MZOperationFriendView.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZOperationFriendView.h"

@interface MZOperationFriendView ()

@property (weak, nonatomic) IBOutlet UIView *customAlertView;



@property (weak, nonatomic) IBOutlet UIButton *removeFriendButton;

@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@end


@implementation MZOperationFriendView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZOperationFriendView" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    
    _removeFriendButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    _removeFriendButton.layer.borderWidth= 1.0f;
    _removeFriendButton.layer.cornerRadius = 25;
    _removeFriendButton.layer.masksToBounds = YES;
    
//    _joinblacklistButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
//    _joinblacklistButton.layer.borderWidth= 1.0f;
//    _joinblacklistButton.layer.cornerRadius = 25;
//    _joinblacklistButton.layer.masksToBounds = YES;
    
    
    _reportButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    _reportButton.layer.borderWidth= 1.0f;
    _reportButton.layer.cornerRadius = 25;
    _reportButton.layer.masksToBounds = YES;
    
    _cancelButton.layer.cornerRadius = 25;
    _cancelButton.layer.masksToBounds = YES;
    
}


- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
     self.backgroundColor = RGBA(0, 0, 0, 0.1);
    [UIView animateWithDuration:0.5 animations:^{
         self.backgroundColor = RGBA(0, 0, 0, 0.4);
        _customAlertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _customAlertView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
         self.backgroundColor = RGBA(0, 0, 0, 0.1);
        _customAlertView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _customAlertView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}



- (IBAction)didClickRemoveFriendButtonAction:(id)sender {
      NSLog(@"移除该成员");
    if (_delegate  &&[_delegate respondsToSelector:@selector(clickRemoveFriendButtonAction)]) {
        [self dismiss];
        [_delegate  clickRemoveFriendButtonAction];
    }
}
- (IBAction)didClickJoinBlacklistButtonAction:(id)sender {
      NSLog(@"加入黑名单");
}
- (IBAction)didClickReportButtonAction:(id)sender {
      NSLog(@"举报");
    if (_delegate  &&[_delegate respondsToSelector:@selector(clickReportButtonAction)]) {
        [self dismiss];
        [_delegate  clickReportButtonAction];
    }
}
- (IBAction)didClickCancelButtonAction:(id)sender {
    [self dismiss];
}





- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}


@end
