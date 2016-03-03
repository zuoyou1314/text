//
//  MZOneMoreView.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/28.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZOneMoreView.h"

@interface MZOneMoreView ()

@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation MZOneMoreView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZOneMoreView" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
//    _cancelButton.layer.cornerRadius = 25;
//    _cancelButton.layer.masksToBounds = YES;
    
    //    _removeButton.hidden = YES;
    //    _removeLabel.hidden = YES;
    _oneButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    _oneButton.layer.borderWidth= 1.0f;
    _oneButton.layer.cornerRadius = 25;
    _oneButton.layer.masksToBounds = YES;
    
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



- (IBAction)didClickOneButtonAction:(id)sender {
    NSLog(@"OneMoreView");
    if (_delegate  &&[_delegate respondsToSelector:@selector(clickOneButtonAction:)]) {
        [self dismiss];
        [_delegate  clickOneButtonAction:(UIButton *)sender];
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




@end
