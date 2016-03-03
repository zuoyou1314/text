//
//  MZYearView.m
//  MZTuShenMa
//
//  Created by zuo on 16/1/4.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZYearView.h"
#import "Masonry.h"

@implementation MZYearView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    self.backgroundColor = RGBA(0, 0, 0, 0.4);
    _yearLabel = [[UILabel alloc]init];
    _yearLabel.text = @"2016";
    _yearLabel.textColor = [UIColor whiteColor];
    [self addSubview:_yearLabel];
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
}

@end
