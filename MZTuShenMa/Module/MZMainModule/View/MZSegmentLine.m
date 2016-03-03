//
//  MZSegmentLine.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/25.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZSegmentLine.h"

@interface MZSegmentLine ()
{
    UIView *_centerLineView;
    UIView *_leftLineView;
    UIView *_rightLineView;
}
@end


@implementation MZSegmentLine

#pragma mark -- Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        CGFloat segmentLineOfWidth = SCREEN_WIDTH-16.0f;
          CGFloat segmentLineOfWidth = SCREEN_WIDTH-30.0f;
        
        _centerLineView = [[UILabel alloc]initWithFrame:CGRectMake(segmentLineOfWidth/2, 0.0f, 1.0f, 30.0f)];
        _centerLineView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        
        [self addSubview:_centerLineView];
        
        _leftLineView = [[UILabel alloc]initWithFrame:CGRectMake(segmentLineOfWidth/4, 0.0f, 1.0f, 30.0f)];
        _leftLineView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        [self addSubview:_leftLineView];
        
        
        _rightLineView = [[UILabel alloc]initWithFrame:CGRectMake(segmentLineOfWidth/2+segmentLineOfWidth/4, 0.0f, 1.0f, 30.0f)];
        _rightLineView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        [self addSubview:_rightLineView];
        
        
    }
    return self;
}



#pragma mark -- Event Response



#pragma mark -- Private Method



#pragma mark -- Getter and Setter


@end
