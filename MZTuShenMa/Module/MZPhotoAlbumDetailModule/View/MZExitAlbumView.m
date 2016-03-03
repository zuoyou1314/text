//
//  MZExitAlbumView.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZExitAlbumView.h"


@interface MZExitAlbumView ()

@property (weak, nonatomic) IBOutlet UIView *customAlertView;
@property (weak, nonatomic) IBOutlet UIButton *updatePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end

@implementation MZExitAlbumView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZExitAlbumView" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    
    _lineHeight.constant= 0.5f;
    
    _updatePhotoButton.layer.cornerRadius = 25;
    _updatePhotoButton.layer.masksToBounds = YES;
    
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


- (IBAction)didClickUpdatePhotoButtonAction:(id)sender {
 
    if (_delegate &&[_delegate respondsToSelector:@selector(clickExitAlbumButtonEvent)]) {
        [self dismiss];
        NSLog(@"确定");
        [_delegate clickExitAlbumButtonEvent];
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
