//
//  MZBaseNavigationViewController.m
//  ZhiXuan
//
//  Created by Wangxin on 15/6/3.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseNavigationViewController.h"
#import "MZloginViewController.h"

@interface MZBaseNavigationViewController ()

@end

@implementation MZBaseNavigationViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if(self = [super initWithRootViewController:rootViewController])
    {
        // -- shadowImage 导航的阴影 不初始化会有一个小黑条
        self.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegate:self];
    self.interactivePopGestureRecognizer.enabled = YES;
    [self.interactivePopGestureRecognizer setDelegate:self];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([viewController isKindOfClass:[MZloginViewController class]])
        
        [self setNavigationBarHidden:YES animated:YES];
    else
        [self setNavigationBarHidden:NO animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([viewController isKindOfClass:[MZloginViewController class]])
        
        [self setNavigationBarHidden:YES animated:YES];
    else
        [self setNavigationBarHidden:NO animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Autorotate

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}


@end
