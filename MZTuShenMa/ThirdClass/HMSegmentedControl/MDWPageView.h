//
//  MDWPageView.h
//  MDW
//
//  Created by zuo on 15/3/24.
//  Copyright (c) 2015年 www.moko.cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
@interface MDWPageView : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void)changePage:(id)sender;

- (void)previousPage;
- (void)nextPage;
- (void)changeToPage:(int)tag;

@end
