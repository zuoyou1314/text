


//
//  MZNoDeleteFriendView.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZNoDeleteFriendView.h"

@interface MZNoDeleteFriendView ()

@property (weak, nonatomic) IBOutlet UIView *customAlertView;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@end


@implementation MZNoDeleteFriendView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZNoDeleteFriendView" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{

    
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
