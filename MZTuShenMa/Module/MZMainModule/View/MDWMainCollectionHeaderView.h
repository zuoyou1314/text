//
//  MDWMainCollectionHeaderView.h
//  MDW
//
//  Created by zuo on 15/3/21.
//  Copyright (c) 2015年 www.moko.cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface MDWMainCollectionHeaderView : UICollectionReusableView<UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_cycleScrollView;
}

@property (nonatomic,strong)NSMutableArray *bannerArray;

@end
