//
//  MRGuideViewController.m
//  MannerBar
//
//  Created by M.Ray on 13-7-18.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MRGuideViewController.h"
#import "MZLaunchManager.h"
@interface MRGuideViewController ()

@end

@implementation MRGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (CGRect)onscreenFrame
{
//	return [UIScreen mainScreen].applicationFrame;
    return [UIScreen mainScreen].bounds;
    
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
    
//	switch ([UIApplication sharedApplication].statusBarOrientation)
//    {
//		case UIInterfaceOrientationPortrait:
//			frame.origin.y = frame.size.height;
//			break;
//		case UIInterfaceOrientationPortraitUpsideDown:
//			frame.origin.y = -frame.size.height;
//			break;
//		case UIInterfaceOrientationLandscapeLeft:
//			frame.origin.x = frame.size.width;
//			break;
//		case UIInterfaceOrientationLandscapeRight:
//			frame.origin.x = -frame.size.width;
//			break;
//	}
    if(_willHide){
        frame.origin.x = -frame.size.width;
    }
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
        _willHide = NO;
		[MRGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[MRGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
        [MRGuideViewController sharedGuide].view.hidden = NO;
		[MRGuideViewController sharedGuide].view.frame = [self onscreenFrame];
        NSLog(@"show frame = %@", NSStringFromCGRect([MRGuideViewController sharedGuide].view.frame));
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
        _willHide = YES;
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
//        [MRGuideViewController sharedGuide].view.hidden = YES;
		[MRGuideViewController sharedGuide].view.frame = [self offscreenFrame];
        NSLog(@"hide frame = %@", NSStringFromCGRect([MRGuideViewController sharedGuide].view.frame));
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[MRGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[MRGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[MRGuideViewController sharedGuide] showGuide];
    
}

+ (void)hide
{
	[[MRGuideViewController sharedGuide] hideGuide];
}

#pragma mark -

+ (MRGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static MRGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLuanch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     [[MZLaunchManager manager] startApplication];
    
    
}

#pragma mark init

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //隐藏导航栏
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    //去掉导航栏底下的分割线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    
    if (iPhone5) {
          imageNameArray = [NSMutableArray arrayWithObjects:@"iPhone5sOne", @"iPhone5sTwo",nil];
    }else if (iPhone6){
          imageNameArray = [NSMutableArray arrayWithObjects:@"iPhone6One", @"iPhone6Two",nil];
    }else{
          imageNameArray = [NSMutableArray arrayWithObjects:@"iPhone6plusOne", @"iPhone6PlusTwo",nil];
    }
  
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.pageScroll.pagingEnabled = YES;
    _pageScroll.delegate = self;
    _pageScroll.bounces = NO;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
    [self.view addSubview:self.pageScroll];
    
    
    
    
    
    
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {
            
//#if(0)  //引导页-->点击进入主页
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
//            [enterButton setCenter:CGPointMake(self.view.center.x-85, 415.f)];
//            if (IS_IPHONE_5) {
//                [enterButton setCenter:CGPointMake(self.view.center.x-85, 440.f)];
//            }
            
            if (iPhone5) {
                enterButton.frame = rect(97, SCREEN_HEIGHT-114-40, SCREEN_WIDTH -194,40.0f);
                [enterButton setBackgroundImage:[UIImage imageNamed:@"guide_btn1"] forState:UIControlStateNormal];
            }else if (iPhone6){
                enterButton.frame = rect(SCREEN_WIDTH/2-147.5/2, SCREEN_HEIGHT-114-40-40, 147.5,47.0f);
                [enterButton setBackgroundImage:[UIImage imageNamed:@"guide_btn2"] forState:UIControlStateNormal];
            }else{
                enterButton.frame = rect(SCREEN_WIDTH/2-489/3/2, SCREEN_HEIGHT-114-40-80, 489/3,156/3);
                [enterButton setBackgroundImage:[UIImage imageNamed:@"guide_btn3"] forState:UIControlStateNormal];
            }
        
            
//            [enterButton setBackgroundImage:[UIImage imageNamed:@"guide_btn_preesed1"] forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
//#endif
        }
    }
    
    
//    if (iPhone5) {
//        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(_pageScroll.center.x-15, SCREEN_HEIGHT-40, 30, 30)];
//    }else if (iPhone6){
//        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(_pageScroll.center.x-15, SCREEN_HEIGHT-40, 30, 30)];
//    }else{
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(_pageScroll.center.x-15, SCREEN_HEIGHT-40, 30, 30)];
//    }

    [_pageControl setCurrentPage:0];
//    _pageControl.pageIndicatorTintColor=RGBA(132, 104, 77, 1);
    _pageControl.pageIndicatorTintColor=RGBA(255, 255, 255, 0.1);
    //
//    _pageControl.currentPageIndicatorTintColor=RGBA(195, 179, 163, 1);
    _pageControl.currentPageIndicatorTintColor=RGBA(255, 255, 255, 1.0);
    _pageControl.numberOfPages = imageNameArray.count;//指定页面个数
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    [_pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
}

#pragma mark UIScrollViewDelegate

//引导页-->滑动进入主页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat beginX = CGRectGetWidth(self.view.frame) * (imageNameArray.count - 1);
    if(scrollView.contentOffset.x - beginX > 50){
        
//        [self hideGuide];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLuanch"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
       
        
    }
    
    int page = _pageScroll.contentOffset.x / SCREEN_WIDTH;//通过滚动的偏移量来判断目前页面所对应的小白点
    NSLog(@"page == %d",page);
    _pageControl.currentPage = page;//pagecontroll响应值的变化
}

- (void)changePage:(id)sender {
    NSInteger page = _pageControl.currentPage;//获取当前pagecontroll的值
    [_pageScroll setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}



@end
