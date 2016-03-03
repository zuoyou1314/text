//
//  Macros.h
//
/**
 宏定义
 */


// 友盟相关
#define UMeng_AppKey        @"5486b683fd98c520870002e1"
#define kMobileNumberPattern @"^1(([3587][0-9])|(47)|(06)|(07))[0-9]{8}$"

#define appDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

#pragma mark - 颜色定义
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) /255.0f alpha:(a)]
#define RGB(r,g,b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) /255.0f alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0f green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0f blue:((float)(rgbValue & 0xFF)) /255.0f alpha:1.0]

#pragma mark - 设备定义
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen]currentMode].size):NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen]currentMode].size):NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(750, 1334),[[UIScreen mainScreen]currentMode].size):NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1242, 2208),[[UIScreen mainScreen]currentMode].size):NO)
#pragma mark - 系统版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define IOS5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IOS6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#pragma mark - 尺寸定义
#define NavigationBar_HEIGHT ((IOS7_OR_LATER && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?44.0f:64.f)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define StatusBar_HEIGHT ((IOS7_OR_LATER && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)
#define TabBar_HEIGHT (55.0)
#define HeightForiPhone5 (iPhone5?44:0)

#define SCALE_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width / 320)
#pragma mark - 日志

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#pragma mark - 弧度角度转换
#define degressToRadian(x) (M_PI*(x) / 180.0)
#define radianToDegress(radian) ((radian*180.0)/(M_PI))


//================================================//

/**
 * 定义Rect
 */
#define rect(x,y,w,h) CGRectMake(x,y,w,h)
/**
 * 定义point
 */
#define point(x,y) CGPointMake(x,y)
/**
 * 定义size
 */
#define size(w,h) CGSizeMake(w,h)
/**
 *  获取最大X,Y
 */
#define maxX(rect) CGRectGetMaxX(rect)
#define maxY(rect) CGRectGetMaxY(rect)
/**
 *  获取最小X,Y
 */
#define minX(rect) CGRectGetMinX(rect)
#define minY(rect) CGRectGetMinY(rect)
/**
 *  获取矩形宽,高
 */
#define rectW(rect) CGRectGetWidth(rect)
#define rectH(rect) CGRectGetHeight(rect)


//================================================//

#define userdefaultsDefine  [NSUserDefaults standardUserDefaults]

//友盟key  507fcab25270157b37000010  545866d3fd98c5ecc0002c40
#define UmengAppkey @"507fcab25270157b37000010"
//微信Key
//#define MOKOWXAppKey    @"wx996d61cfee46e347"
#define MOKOWXAppKey    @"wx088757952b8befc2"
//微信Secret
//#define MOKOWXAppSecret @"0d75edf076bcb69e051a394fd13c163c"
#define MOKOWXAppSecret @"7b941e7bdde64b86e45a9ef50cef0ff5"

//微信Key
//#define MOKOWXAppKey    @"wxd930ea5d5a258f4f"
//微信Secret
//#define MOKOWXAppSecret @"db426a9829e4b49a0dcac7b4162da6b6"

//分享URL
#define MOKOShareUrl     @"http://www.moko.cc"
//分享动态地址
#define MOKO_STATUS_PATH @"http://dwintf.moko.cc:8055/status/";
//分享下载地址
#define MOKO_DOWNLOAD    @"http://www.moko.cc"

//倒计时
#define TIMER 60

//百度统计的APPKey
//测试库
#define BaiDuDebugAppkey @"9d717b73ef"
//正式库
#define BaiDuReleaseAppkey @"89bdd6b452"

#define font(size) [UIFont systemFontOfSize:size]



