//
//  MZAlbumQRCodeView.m
//  MZTuShenMa
//
//  Created by zuo on 15/11/16.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZAlbumQRCodeView.h"

@interface MZAlbumQRCodeView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineOfHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;

@end

@implementation MZAlbumQRCodeView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZAlbumQRCodeView" owner:self options:nil] lastObject];
        [self setFrame:frame];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    _topLineOfHeight.constant = 0;
    _bottomLineHeight.constant = 0;
}

@end
