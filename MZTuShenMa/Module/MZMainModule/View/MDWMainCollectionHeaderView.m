//
//  MDWMainCollectionHeaderView.m
//  MDW
//
//  Created by zuo on 15/3/21.
//  Copyright (c) 2015年 www.moko.cc. All rights reserved.
//

#import "MDWMainCollectionHeaderView.h"
//#import "MDWBannerModel.h"
//#import "MDWAppDelegate.h"
#import "MZWaterfallViewController.h"
#import "MZAdvertModel.h"
@implementation MDWMainCollectionHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{
    self.bounds=[[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect(0.0f, 0.0f,self.bounds.size.width,175.0f) imageURLStringsGroup:nil];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    _cycleScrollView.dotColor = RGB(48, 138, 252);
    _cycleScrollView.autoScrollTimeInterval = 3;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"main_bannerPlaceholder"];
    [self addSubview:_cycleScrollView];
}

- (void)setBannerArray:(NSMutableArray *)bannerArray
{
    _bannerArray = bannerArray;
    if (_bannerArray.count == 1) {
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.showPageControl = NO;
    }

    NSMutableArray *imageURLImage = [NSMutableArray arrayWithCapacity:_bannerArray.count];
    for (MZAdvertModel *advertModel in _bannerArray) {
        [imageURLImage addObject:advertModel.cover_img];
    }
//    //--- 模拟加载延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cycleScrollView.imageURLStringsGroup = imageURLImage;
//    });
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    MZAdvertModel *advertModel = [_bannerArray objectAtIndex:index];
    if (![advertModel.h5_url isEqualToString:@""]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",advertModel.h5_url]]];
    }else{
        MZWaterfallViewController *waterfallVC = [[MZWaterfallViewController alloc]init];
        waterfallVC.album_name = advertModel.album_name;
        waterfallVC.album_id = advertModel.album_id;
        [[self viewController].navigationController pushViewController:waterfallVC animated:YES];
    }
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
