//
//  MDWPageView.m
//  MDW
//
//  Created by zuo on 15/3/24.
//  Copyright (c) 2015年 www.moko.cc. All rights reserved.
//

#import "MDWPageView.h"

//#import "MDWMediaCenter.h"
#define changeratio  1
#define IOS7_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@interface MDWPageView ()

@property (nonatomic, strong) NSMutableArray *menus;
//@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UISegmentedControl *segmentedC;

@property (assign) BOOL pageControlUsed;
@property (assign) NSUInteger page;
@property (assign) BOOL rotating;
- (void)loadScrollViewWithPage:(int)page;

@end

@implementation MDWPageView

- (NSMutableArray *)menus {
    if (!_menus) {
        _menus = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _menus;
}

- (void) setNavigationDefaultLeftBarButton
{
    
    UIView *customView = [[UIView alloc]initWithFrame:rect(0, 0, 22, 22)];
    
//    customView.backgroundColor = [UIColor redColor];
    
    UIButton *lefrBarButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    lefrBarButtonTmp.backgroundColor = [UIColor orangeColor];
    
    [lefrBarButtonTmp setBackgroundImage:[UIImage imageNamed:@"login_backHighlighted_temp"] forState:UIControlStateNormal];
    
    [lefrBarButtonTmp addTarget:self action:@selector(navigationDefaultLeftBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [lefrBarButtonTmp setFrame:CGRectMake(0, 0, 22, 22)];
    
    [customView addSubview:lefrBarButtonTmp];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
//    UIImage *backButtonImage = [[UIImage imageNamed:@"login_backHighlighted_temp"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0,0)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    //将返回按钮的文字position设置不在屏幕上显示
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];

}

- (void) navigationDefaultLeftBarButtonTouchUpInside:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationDefaultLeftBarButton];
    if(IOS7_OR_LATER){
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    CGRect rect = CGRectZero;
    if (IOS7_OR_LATER) {
        rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    }else{
        rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    _pageControl.backgroundColor = [UIColor clearColor];
    
    _pageControl.hidden = YES;
    
    [self.view addSubview:_pageControl];
    
    rect.origin.y+=44;
    rect.size.height -=40*2;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.scrollsToTop = NO;
    _scrollView.bounces = NO;
    
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    
    [self.view addSubview:_scrollView];
    
    
    
    _lineLabel = [[UILabel alloc]initWithFrame:rect(0, 64+40, SCREEN_WIDTH, 0.5)];
    _lineLabel.backgroundColor = [UIColor colorWithRed:194/255.0f green:195/255.0f blue:196/255.0f alpha:1.0f];
    [self.view addSubview:_lineLabel];
    
    
    
    NSArray * array = @[@"照片",@"群聊"];
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:array];
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15.f * changeratio],NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName,nil];
    _segmentedControl.titleTextAttributes = attributesNormal;

    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
#ifdef HOMETHREE
    _segmentedControl.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
#else
    _segmentedControl.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
#endif
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorHeight = 2.0f;
    _segmentedControl.selectionIndicatorColor = UIColorFromRGB(0x308afc);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(-100.0f, 0.0f, 0.0f, 0.0f);
    __block MDWPageView * bObject = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Selected index %ld (via block)", (long)index);
        [bObject changeToPage:(int)index];
    }];

    [self.view addSubview:_segmentedControl];
    
//    _segmentedC = [[UISegmentedControl alloc]initWithItems:array];
//    _segmentedC.frame = rect(30,69,SCREEN_WIDTH-60,30);
//    _segmentedC.layer.borderColor = [[UIColor blueColor]CGColor];
//    _segmentedC.layer.borderWidth= 1.0f;
//    _segmentedC.selectedSegmentIndex = 0;
//    _segmentedC.layer.cornerRadius = 15;
//    _segmentedC.layer.masksToBounds = YES;
//    [_segmentedC addTarget:self action:@selector(didClickSegmentControlAction:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_segmentedC];
    
    
    
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    _rotating = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [viewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [self.childViewControllers count], _scrollView.frame.size.height );
    NSUInteger page = 0;
    for (viewController in self.childViewControllers) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        viewController.view.frame = frame;
        page++;
    }
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * _page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:NO];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _rotating = NO;
    UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _segmentedControl.hidden = NO;

    for (int i =0; i < [self.childViewControllers count]; i++) {
        [self loadScrollViewWithPage:i];
    }
    
    self.pageControl.currentPage = 0;
    _page = 0;
    [self.pageControl setNumberOfPages:[self.childViewControllers count]];
    
    UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    if (viewController.view.superview != nil) {
//        [viewController viewWillAppear:animated];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [self.childViewControllers count], _scrollView.frame.size.height );
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.childViewControllers count]) {
        UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
        if (viewController.view.superview != nil) {
            [viewController viewDidAppear:animated];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    _segmentedControl.hidden = YES;

    if ([self.childViewControllers count]) {
        UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
        if (viewController.view.superview != nil) {
            [viewController viewWillDisappear:animated];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    if (viewController.view.superview != nil) {
        [viewController viewDidDisappear:animated];
    }
    [super viewDidDisappear:animated];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0)
        return;
    if (page >= [self.childViewControllers count])
        return;
    
    // replace the placeholder if necessary
    UIViewController *controller = [self.childViewControllers objectAtIndex:page];
    if (controller == nil) {
        return;
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
        NSLog(@"controller.view.frame:%@",NSStringFromCGRect(controller.view.frame));
//        NSLog(@”controller.view frame:%@”, NSStringFromCGRect(controller.view.frame));
    }
}

- (void)previousPage {
    if (_page - 1 > 0) {
        
        // update the scroll view to the appropriate page
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * (_page - 1);
        frame.origin.y = 0;
        
        UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
        UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page - 1];
        [oldViewController viewWillDisappear:YES];
        [newViewController viewWillAppear:YES];
        
        [self.scrollView scrollRectToVisible:frame animated:NO];
        
        self.pageControl.currentPage = _page - 1;
        // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
        _pageControlUsed = YES;
    }
}

- (void)nextPage {
    if (_page + 1 > self.pageControl.numberOfPages) {
        
        // update the scroll view to the appropriate page
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * (_page + 1);
        frame.origin.y = 0;
        
        UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
        UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page + 1];
        [oldViewController viewWillDisappear:YES];
        [newViewController viewWillAppear:YES];
        
        [self.scrollView scrollRectToVisible:frame animated:NO];
        
        self.pageControl.currentPage = _page + 1;
        // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
        _pageControlUsed = YES;
    }
}

- (void)changePage:(id)sender {
    int page = (int)((UIPageControl *)sender).currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [oldViewController viewWillDisappear:YES];
    [newViewController viewWillAppear:YES];
    
    [self.scrollView scrollRectToVisible:frame animated:NO];
    
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

- (void)didClickSegmentControlAction:(UISegmentedControl *)seg
{
    int page = seg.selectedSegmentIndex;
    [_segmentedControl setSelectedSegmentIndex:page animated:YES];
    [_segmentedC setSelectedSegmentIndex:page];
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
    [oldViewController viewWillDisappear:YES];
    [newViewController viewWillAppear:YES];
    
    [self.scrollView scrollRectToVisible:frame animated:NO];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;

}


- (void)changeToPage:(int)tag;
{
    int page = tag;
    [_segmentedControl setSelectedSegmentIndex:page animated:YES];
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
    [oldViewController viewWillDisappear:YES];
    [newViewController viewWillAppear:YES];
    
    [self.scrollView scrollRectToVisible:frame animated:NO];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [oldViewController viewDidDisappear:YES];
    [newViewController viewDidAppear:YES];
    
    _page = self.pageControl.currentPage;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed || _rotating) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage != page) {
        UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
        UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
        [oldViewController viewWillDisappear:YES];
        [newViewController viewWillAppear:YES];
        self.pageControl.currentPage = page;
        [oldViewController viewDidDisappear:YES];
        [newViewController viewDidAppear:YES];
        _page = page;
        //        if ([self.delegate respondsToSelector:@selector(gotoPageByindex:)]){
        //            [self.delegate gotoPageByindex:_page];
        //        }
    }

}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
    
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    int currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    
    [_segmentedControl setSelectedSegmentIndex:currentPage animated:YES];
    
    [_segmentedC setSelectedSegmentIndex:currentPage];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
}

+ (UIFont *)customFont:(NSString *)fontName size:(CGFloat)fontSize
{
    return [UIFont fontWithName:fontName size:fontSize];
}

+(UIFont*)customFontsize:(CGFloat)fontSize
{
    UIFont*font =  [MDWPageView customFont:@"FZLanTingHei-L-GBK-M" size:fontSize];
    //    UIFont*font =  [UIUtil customFont:@"FZXiYuan-M01" size:fontSize];
    //    UIFont*font =  [UIUtil customFont:@"FZBeiWeiKaiShu-S19S" size:fontSize];
    //    UIFont*font =  [UIUtil customFont:@"Heiti TC" size:fontSize];
    
    
    return font;
}

+(UIImage*)ImageString:(NSString*)path
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
