//
//  MZPhotoAlbumUserNameView.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPhotoAlbumUserNameView.h"

@interface MZPhotoAlbumUserNameView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineOfHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOfHeight;


@end




@implementation MZPhotoAlbumUserNameView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZPhotoAlbumUserNameView" owner:self options:nil] lastObject];
        [self setFrame:frame];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    _topLineOfHeight.constant = 0.5;
    _bottomOfHeight.constant = 0.5;
}

@end
