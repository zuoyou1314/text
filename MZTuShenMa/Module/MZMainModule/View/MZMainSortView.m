//
//  MZMainSortView.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZMainSortView.h"

@interface MZMainSortView ()


@property (weak, nonatomic) IBOutlet UIView *customAlertView;

@property (weak, nonatomic) IBOutlet UIButton *creatPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *updatePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end


@implementation MZMainSortView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZMainSortView" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
   
   
    _creatPhotoButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    _creatPhotoButton.layer.borderWidth= 1.0f;
    _creatPhotoButton.layer.cornerRadius = 25;
    _creatPhotoButton.layer.masksToBounds = YES;
    

    
    _updatePhotoButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    _updatePhotoButton.layer.borderWidth= 1.0f;
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

- (IBAction)didClickCreatePhotoButtonAction:(id)sender {
    NSLog(@"按相册创建时间排序");
//    _creatPhotoButton.layer.borderColor = [[UIColor redColor]CGColor];
    if (_delegate  &&[_delegate respondsToSelector:@selector(clickCreatePhotoButtonEvent)]) {
        [self dismiss];
        [_delegate  clickCreatePhotoButtonEvent];
    }
}
- (IBAction)didTouchDownCreatePhotoButtonAction:(id)sender {
    _creatPhotoButton.layer.borderColor = [RGB(47, 193, 221) CGColor];
    [_creatPhotoButton setTitleColor:RGB(47, 193, 221) forState:UIControlStateNormal];
    
    _updatePhotoButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    [_updatePhotoButton setTitleColor:[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
}





- (IBAction)didClickUpdatePhotoButtonAction:(id)sender {
    NSLog(@"按相册更新时间排序");
    if (_delegate &&[_delegate respondsToSelector:@selector(clickUpdatePhotoButtonEvent)]) {
        [self dismiss];
        [_delegate clickUpdatePhotoButtonEvent];
    }
}

- (IBAction)didTouchDownUpdatePhotoButtonAction:(id)sender
{
    _updatePhotoButton.layer.borderColor = [RGB(47, 193, 221) CGColor];
    [_updatePhotoButton setTitleColor:RGB(47, 193, 221) forState:UIControlStateNormal];
    _creatPhotoButton.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    [_creatPhotoButton setTitleColor:[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
}



- (IBAction)didClickCancelButtonAction:(id)sender
{
      [self dismiss];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self dismiss];
}

@end
