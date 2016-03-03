//
//  MZBaseViewController.m
//  ZhiXuan
//
//  Created by Wangxin on 15/6/4.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"
#import <SDWebImage/UIImage+GIF.h>
#import <ImageIO/ImageIO.h>
@interface MZBaseViewController ()

@end

@implementation MZBaseViewController

- (id)initWithTitle:(NSString *)title
{
    if(self = [super init])
    {
        [self setNavigationTitle:title];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //-- 选个比较安全的tag值放置导航的线条 导航下边黑线
    if(self.isHiddenNavigationline == NO)
    {
        if (![[self.navigationController.navigationBar viewWithTag:3579] isKindOfClass:[UIImageView class]])
        {
            self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 1)];
            self.lineImageView.image = [UIImage imageNamed:@"Navline"];
            self.lineImageView.tag   = 3579;
            [self.navigationController.navigationBar addSubview:self.lineImageView];
        }
    }
    else
    {
        UIView *view = [self.navigationController.navigationBar viewWithTag:3579];
        
        if (view && [view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (void)loadView
{
    [super loadView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    
    [self setBackGroundImageWithImageName:nil];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
    
    
   
//        self.navigationItem.hidesBackButton = YES;
//    
//        UIBarButtonItem *spacingItem=[[UIBarButtonItem alloc]
//                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        spacingItem.width=-8;
//        self.navigationItem.hidesBackButton = NO;
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:[UIButton createButtonWithNormalImage:@"main_back" highlitedImage:nil target:self action:@selector(backButtonPressed:)]];
//        self.navigationItem.leftBarButtonItems = @[spacingItem,backButton];
}

#pragma mark Custom Events

//-(void)backButtonPressed:(id) sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}



- (void) setBackGroundImageWithImageName:(NSString *)imageName
{
    if(!imageName)
    {
//        [self.view setBackgroundColor:[UIColor colorWithRed:38/255.0f green:28/255.0f blue:63/255.0f alpha:1.0f]];
//          self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = RGB(244, 244, 244);
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:imageName]]];
    }
}

- (void) setUserInfoBackColor
{
    [self.view setBackgroundColor:RGB(72, 105, 228)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark - keyboardNotification

- (NSMutableDictionary *) keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    NSString *timeDuration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] stringValue];
    
    NSValue *keyboardRect = [dict objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    
    [tmpDict setObject:timeDuration forKey:kKeyboardTimeDuration];
    
    [tmpDict setObject:keyboardRect forKey:kKeyboardRect];
    
    return tmpDict;
}
- (NSMutableDictionary *) keyboardWillHideNotification:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    NSString *timeDuration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] stringValue];
    
    NSValue *keyboardRect = [dict objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    
    [tmpDict setObject:timeDuration forKey:kKeyboardTimeDuration];
    
    [tmpDict setObject:keyboardRect forKey:kKeyboardRect];
    
    return tmpDict;
    
}
- (NSMutableDictionary *) keyboardWillChangeNotification:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    NSString *timeDuration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] stringValue];
    
    NSValue *keyboardRect = [dict objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    
    [tmpDict setObject:timeDuration forKey:kKeyboardTimeDuration];
    
    [tmpDict setObject:keyboardRect forKey:kKeyboardRect];
    
    return tmpDict;
}
#pragma mark - NavigationSetting

- (UIView *)navigationTitleView:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,44)];
    label.text                      = title;
    label.font                      = [UIFont systemFontOfSize:17];
    label.textAlignment             = NSTextAlignmentCenter;
    label.textColor                 = [UIColor whiteColor];
    label.backgroundColor           = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}
- (void)setNavigationBarColor:(UIColor *)aColor
{
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        [self.navigationController.navigationBar setBarTintColor:aColor];
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:aColor];
    }
}

- (void)setNavigationBarImage:(UIImage *)aImage
{
    [self.navigationController.navigationBar setBackgroundImage:aImage forBarMetrics:UIBarMetricsDefault];
}

- (void) setNavigationTitle:(NSString *)title
{
    UIView *titleView = [self navigationTitleView:title];
    
    [self.navigationItem setTitleView:titleView];
}

- (void) setNavigationBtnTitle:(NSString *)title WithBtnImgName:(NSString *)imgName
{
    UIView *titileView = [self navigationBtnTitleView:title WithImgName:imgName];
    
    [self.navigationItem setTitleView:titileView];
}

- (UIView *)navigationBtnTitleView:(NSString *)title WithImgName:(NSString *)imgName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setFrame:CGRectMake(0, 0, 150, 44)];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor colorWithRed:81/255.0f green:78/255.0f blue:78/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [btn addTarget:self action:@selector(NavBtnClikck:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 130, 0, 0)];
    
    return btn;
}

- (void) NavBtnClikck:(UIButton *)btn
{
    
}

//帝加
-(void)setLeftBackButtonItem:(NSString*)leftName
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 75, 15);
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (leftName!=nil) {
        [leftButton setTitleColor:UIColorFromRGB(0xf1f1f1) forState:UIControlStateNormal];
        [leftButton setTitle:[NSString stringWithFormat:@" %@",leftName] forState:UIControlStateNormal];
        [leftButton setTitleColor:UIColorFromRGB(0x727285) forState:UIControlStateHighlighted];
        [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    }
    [leftButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    //[leftButton setImage:[UIImage imageNamed:@"backButtonL.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigationDefaultLeftBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    negativeSpacer1.width = -10;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer1,menu, nil]];
    negativeSpacer1 = nil;
    menu = nil;
}


- (void) setNavigationDefaultLeftBarButton
{
    UIButton *lefrBarButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // login_back main_back
    [lefrBarButtonTmp setBackgroundImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    
    [lefrBarButtonTmp addTarget:self action:@selector(navigationDefaultLeftBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [lefrBarButtonTmp setFrame:CGRectMake(0, 0, 25, 25)];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:lefrBarButtonTmp];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
- (void)setNavigationLeftBarButtonWithImage:(UIImage *)image
{
    UIButton *lefrBarButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [lefrBarButtonTmp setFrame:CGRectMake(0, 0, 20, 20)];
    
    [lefrBarButtonTmp setBackgroundImage:image forState:UIControlStateNormal];
    
    [lefrBarButtonTmp addTarget:self action:@selector(leftBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:lefrBarButtonTmp];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void) setNavigationRightBarButtonWithImage:(UIImage *)rightBarButtonImage
{
    UIButton *rightBarButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButtonTmp setFrame:CGRectMake(0, 0, 20, 20)];
    
    [rightBarButtonTmp addTarget:self action:@selector(rightBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBarButtonTmp setBackgroundImage:rightBarButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonTmp];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

//首页导航条的右边栏的按钮
-(void)setNaviRightBackButtonItem:(NSString*)rightName
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 150, 30);
    rightButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (rightName!=nil) {
        [rightButton setTitleColor:UIColorFromRGB(0xf1f1f1) forState:UIControlStateNormal];
        [rightButton setTitle:[NSString stringWithFormat:@"%@",rightName] forState:UIControlStateNormal];
        CGRect aSize = [rightName boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
        [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 40 - CGRectGetWidth(aSize), 0, 0)];
        [rightButton setTitleColor:UIColorFromRGB(0x727285) forState:UIControlStateHighlighted];
        [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    }
    [rightButton setImage:[UIImage imageNamed:@"userPic"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    [rightButton addTarget:self action:@selector(rightBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    negativeSpacer1.width = -10;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:menu,negativeSpacer1, nil]];
    negativeSpacer1 = nil;
    menu = nil;
}

- (void) setNavigationRightBarButtonWithImage:(UIImage *)rightBarButtonImage title:(NSString *)title
{
    UIButton *rightBarButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButtonTmp setFrame:CGRectMake(0, 0, 20, 20)];
    
    [rightBarButtonTmp setTitle:title forState:UIControlStateNormal];
    
    [rightBarButtonTmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightBarButtonTmp.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    
    [rightBarButtonTmp setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    
    [rightBarButtonTmp addTarget:self action:@selector(rightBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBarButtonTmp setImage:rightBarButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonTmp];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void) setNavigationRightBarButtonWithTitle:(NSString *)rightBarButtonTitle
{
    UIButton *rightBarButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButtonTmp setFrame:CGRectMake(0, 0, 40, 20)];
    
    [rightBarButtonTmp addTarget:self action:@selector(rightBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBarButtonTmp setTitle:rightBarButtonTitle forState:UIControlStateNormal];
    [rightBarButtonTmp.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonTmp];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed
{
    [super setHidesBottomBarWhenPushed:hidesBottomBarWhenPushed];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHidesBottomBarWhenPushed object:@(hidesBottomBarWhenPushed)];
}

- (void) navigationDefaultLeftBarButtonTouchUpInside:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBarButtonTouchUpInside:(id)sender
{
    
}
- (void) leftBarButtonTouchUpInside:(id)sender
{
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)setLeftBarButton
{
    
    UIView *customView = [[UIView alloc]initWithFrame:rect(0, 0, 22, 22)];
    
    UIButton *lefrBarButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [lefrBarButtonTmp setBackgroundImage:[UIImage imageNamed:@"login_backHighlighted_temp"] forState:UIControlStateNormal];
    
    [lefrBarButtonTmp addTarget:self action:@selector(navigationDefaultLeftBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [lefrBarButtonTmp setFrame:rect(0, 0, 22, 22)];
    
    [customView addSubview:lefrBarButtonTmp];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
}


#pragma mark - HUD & MBProgressHUDDelegate

- (void) showHoldView
{
    [self showHUD];
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [tmpView setBackgroundColor:RGBA(0, 0, 0, .2)];
    holdImageView = [[UIImageView alloc] init];
    [holdImageView setFrame:CGRectMake(0, 0, 80, 80)];
    [holdImageView setCenter:CGPointMake(CGRectGetWidth(progressHUD.frame)/2, CGRectGetHeight(progressHUD.frame)/2)];
    [holdImageView.layer setCornerRadius:5.0f];
    [holdImageView setClipsToBounds:YES];
    [holdImageView setImage:[UIImage sd_animatedGIFNamed:@"holdViewGif"]];
    [tmpView addSubview:holdImageView];
    [progressHUD addSubview:tmpView];
}

- (void)showHUD
{
//    progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
//    [self.view.window addSubview:progressHUD];
    progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.dimBackground = NO;
    progressHUD.delegate = self;
//    [progressHUD show:YES];
}

- (void)hideHUD
{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        });
    });
    
//   [holdImageView removeFromSuperview];
//    holdImageView = nil;
    [progressHUD hide:YES];

}




- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [progressHUD removeFromSuperview];
    progressHUD = nil;
}

- (void)showHUDWithText:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setDetailsLabelText:message];
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    hud.completionBlock = ^()
    {
        
    };
}
- (void)showHUDWithText:(NSString *)message completionBlock:(void (^)(void))completionBlock
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setDetailsLabelText:message];
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    hud.completionBlock = completionBlock;
}
- (void) showAlertWihtText:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alert show];
}

-(void)logInfoSuccessStatusCode:(NSInteger)statusCode responseObject:(id)responseObject responseString:(NSString*)responseString{
    NSLog(@"请求状态: %@",@"success");
    NSLog(@"状态码: %ld",(long)statusCode);
    NSLog(@"请求响应结果: %@",responseObject);
    NSLog(@"请求响应结果: %@",responseString);
}


#pragma mark ---- 压缩图片
static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count) {
    ALAssetRepresentation *rep = (__bridge id)info;
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        NSLog(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }
    return countRead;
}
static void releaseAssetCallback(void *info) {
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}
- (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size
{
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    CGDataProviderDirectCallbacks callbacks =
    {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)
                                                              @{   (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                   (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:size],
                                                                   (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                   });
    CFRelease(source);
    CFRelease(provider);
    if (!imageRef) {
        return nil;
    }
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return toReturn;
}

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


#pragma end ---- 压缩图片

/**
 *  创建导航栏上面的Item
 */
- (void)createBarButtonItemWithLeftBar:(NSString *)leftBar addBar:(NSString *)addBar rightBar:(NSString *)rightBar
{
    UIButton *leftButton = [UIButton createButtonWithNormalImage:leftBar highlitedImage:nil target:self action:@selector(didClickLeftBarAction)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    UIButton *addButton = [UIButton createButtonWithNormalImage:rightBar highlitedImage:nil target:self action:@selector(didClickRightButton)];
    UIBarButtonItem *addBarItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    
    UIButton *placeholderButton = [UIButton createButtonWithNormalImage:nil highlitedImage:nil target:self action:nil];
    UIBarButtonItem *placeholderBarItem = [[UIBarButtonItem alloc]initWithCustomView:placeholderButton];
    
    UIButton *spaceButton = [UIButton createButtonWithNormalImage:nil highlitedImage:nil target:self action:nil];
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc]initWithCustomView:spaceButton];
    
    
    UIButton *rightButton = [UIButton createButtonWithNormalImage:addBar highlitedImage:nil target:self action:@selector(didClickAddButton:)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    NSArray *actionButtonItems = @[addBarItem,placeholderBarItem,spaceBarItem,rightBarItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}








@end
