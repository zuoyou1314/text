/*
 CTAssetsPageViewController.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "CTAssetsPageViewController.h"
#import "CTAssetItemViewController.h"
#import "CTAssetScrollView.h"





@interface CTAssetsPageViewController ()
<UIPageViewControllerDataSource, UIPageViewControllerDelegate, CTAssetItemViewControllerDataSource>
{
    UILabel *_titleLabel;
}

@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, assign, getter = isStatusBarHidden) BOOL statusBarHidden;

@end





@implementation CTAssetsPageViewController

- (id)initWithAssets:(NSArray *)assets
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@30.f}];
    if (self)
    {
        self.assets                 = assets;
        self.dataSource             = self;
        self.delegate               = self;
        self.view.backgroundColor   = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self addNotificationObserver];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = rect(10, 20, 44, 44);
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"publish_back@2x"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(0xed7790) forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [cancelButton addTarget:self action:@selector(didClickCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    _titleLabel = [[UILabel alloc]initWithFrame:rect(0, 20, SCREEN_WIDTH, 44)];
//    lineLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%ld of %ld", @"CTAssetsPickerController", nil), index, count];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:rect(0, 64, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:194/255.0f green:195/255.0f blue:196/255.0f alpha:1.0f];
    [self.view addSubview:lineLabel];
    
}

//- (void)dealloc
//{
//    [self removeNotificationObserver];
//}

- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarHidden;
}


- (void)didClickCancelButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Update Title

- (void)setTitleIndex:(NSInteger)index
{
    NSInteger count = self.assets.count;
    
    _titleLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%ld/%ld", @"CTAssetsPickerController", nil), index, count];
//    self.title      = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%ld of %ld", @"CTAssetsPickerController", nil), index, count];
}


#pragma mark - Page Index

- (NSInteger)pageIndex
{
    return ((CTAssetItemViewController *)self.viewControllers[0]).pageIndex;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    NSInteger count = self.assets.count;
    
    if (pageIndex >= 0 && pageIndex < count)
    {
        CTAssetItemViewController *page = [CTAssetItemViewController assetItemViewControllerForPageIndex:pageIndex];
        page.dataSource = self;
        
        [self setViewControllers:@[page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
        
        [self setTitleIndex:pageIndex + 1];
        
        
     
        
        
    }
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((CTAssetItemViewController *)viewController).pageIndex;
    
    if (index > 0)
    {
        CTAssetItemViewController *page = [CTAssetItemViewController assetItemViewControllerForPageIndex:(index - 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger count = self.assets.count;
    NSInteger index = ((CTAssetItemViewController *)viewController).pageIndex;
    
    if (index < count - 1)
    {
        CTAssetItemViewController *page = [CTAssetItemViewController assetItemViewControllerForPageIndex:(index + 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        CTAssetItemViewController *vc   = (CTAssetItemViewController *)pageViewController.viewControllers[0];
        NSInteger index                 = vc.pageIndex + 1;
        
        [self setTitleIndex:index];
    }
}


#pragma mark - Notification Observer

//- (void)addNotificationObserver
//{
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    
//    [center addObserver:self
//               selector:@selector(scrollViewTapped:)
//                   name:CTAssetScrollViewTappedNotification
//                 object:nil];
//}

//- (void)removeNotificationObserver
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CTAssetScrollViewTappedNotification object:nil];
//}
//
//
//#pragma mark - Tap Gesture
//
//- (void)scrollViewTapped:(NSNotification *)notification
//{
//    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)notification.object;
//    
//    if (gesture.numberOfTapsRequired == 1)
//        [self toogleNavigationBar:gesture];
//    
//}
//
//
//#pragma mark - Fade in / away navigation bar
//
//- (void)toogleNavigationBar:(id)sender
//{
//	if (self.isStatusBarHidden)
//		[self fadeNavigationBarIn];
//    else
//		[self fadeNavigationBarAway];
//}
//
//- (void)fadeNavigationBarAway
//{
//    self.statusBarHidden = YES;
//    
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         [self setNeedsStatusBarAppearanceUpdate];
//                         [self.navigationController.navigationBar setAlpha:0.0f];
//                         [self.navigationController setNavigationBarHidden:YES];
//                         self.view.backgroundColor = [UIColor blackColor];
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
//}
//
//- (void)fadeNavigationBarIn
//{
//    self.statusBarHidden = NO;
//    [self.navigationController setNavigationBarHidden:NO];
//    
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         [self setNeedsStatusBarAppearanceUpdate];
//                         [self.navigationController.navigationBar setAlpha:1.0f];
//                         self.view.backgroundColor = [UIColor whiteColor];
//                     }];
//}



#pragma mark - CTAssetItemViewControllerDataSource

- (ALAsset *)assetAtIndex:(NSUInteger)index;
{
    return [self.assets objectAtIndex:index];
}

@end
