//
//  MZBaseViewController.h
//  ZhiXuan
//
//  Created by Wangxin on 15/6/4.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIButton+Create.h"
#import "MZRequestManger+User.h"
#import "MJExtension.h"
#import "MJChiBaoZiHeader.h"
#import "UserHelp.h"
#import "NSString+Pass.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BaiduMobStat.h"
#import "MRGuideViewController.h"
#import "Masonry.h"
#import "UINavigationBar+Awesome.h"
#import "MDWMediaCenter.h"
#import "MZLaunchManager.h"
static NSString * const kKeyboardTimeDuration = @"keyboardTimeDuration";

static NSString * const kKeyboardRect = @"keyboardRect";

static NSString * const kHidesBottomBarWhenPushed = @"HidesBottomBarWhenPushedNotificationName";

@interface MZBaseViewController : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *progressHUD;
    UIImageView *holdImageView;
}



//-- 控制导航下线是否出现
@property (nonatomic, assign) BOOL isHiddenNavigationline;
//-- 导航下线图片
@property (nonatomic, strong) UIImageView *lineImageView;

-(void)setLeftBarButton;

- (id)initWithTitle:(NSString *)title;

- (void)setNavigationBarColor:(UIColor *)aColor;

- (void)setNavigationBarImage:(UIImage *)aImage;

- (void) setNavigationBtnTitle:(NSString *)title WithBtnImgName:(NSString *)imgName;

- (void) setBackGroundImageWithImageName:(NSString *)imageName;

- (void) setUserInfoBackColor;

- (void) setNavigationTitle:(NSString *)title;

- (void) setNavigationDefaultLeftBarButton;

//帝加
-(void)setLeftBackButtonItem:(NSString*)leftName;

//首页导航条的右边栏的按钮
-(void)setNaviRightBackButtonItem:(NSString*)rightName;

- (void)setNavigationLeftBarButtonWithImage:(UIImage *)image;

- (void) setNavigationRightBarButtonWithImage:(UIImage *)rightBarButtonImage;

- (void) setNavigationRightBarButtonWithTitle:(NSString *)rightBarButtonTitle;

- (void) setNavigationRightBarButtonWithImage:(UIImage *)rightBarButtonImage title:(NSString *)title;

- (void) navigationDefaultLeftBarButtonTouchUpInside:(id)sender;

- (void) rightBarButtonTouchUpInside:(id)sender;

- (void) leftBarButtonTouchUpInside:(id)sender;

- (void) NavBtnClikck:(UIButton *)btn;
//-- 通知键盘回调

- (NSMutableDictionary *) keyboardWillShowNotification:(NSNotification *)notification;

- (NSMutableDictionary *) keyboardWillHideNotification:(NSNotification *)notification;

- (NSMutableDictionary *) keyboardWillChangeNotification:(NSNotification *)notification;
//-- HUD
- (void)showHUD;

- (void)hideHUD;

- (void)showHUDWithText:(NSString *)message;

- (void)showHUDWithText:(NSString *)message completionBlock:(void (^)(void))completionBlock;
//-- Alert
- (void) showAlertWihtText:(NSString *)text;

- (void) showHoldView;

//打印
-(void)logInfoSuccessStatusCode:(NSInteger)statusCode responseObject:(id)responseObject responseString:(NSString*)responseString;

/**
 *  压缩图片
 *
 *  @param asset 图片资源
 *  @param size  压缩比例
 *
 *  @return 压缩后的图片
 */
- (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size;
/**
 *  创建导航栏上面的Item
 */
- (void)createBarButtonItemWithLeftBar:(NSString *)leftBar addBar:(NSString *)addBar rightBar:(NSString *)rightBar;


//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
