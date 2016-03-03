//
//  MRGuideViewController.h
//  MannerBar
//
//  Created by M.Ray on 13-7-18.
//  Copyright (c) 2013年 user. All rights reserved.
//


#import <UIKit/UIKit.h>
/*
 引导界面
 */
@interface MRGuideViewController : UIViewController <UIScrollViewDelegate>
{
    BOOL _animating;
    
    NSMutableArray *imageNameArray;
    UIScrollView *_pageScroll;
    
    CGFloat _beginFloat;
    BOOL _willHide;
    
    UIPageControl *_pageControl;
}

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) UIScrollView *pageScroll;

+ (MRGuideViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end

