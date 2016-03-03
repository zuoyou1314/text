//
//  MZCoverCollectionView.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/12.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDynamicListModel.h"
#import "MZMainPhotoDetailModel.h"
#import "ZLPhotoPickerBrowserViewController.h"
@protocol MZCoverCollectionViewDelegate <NSObject>

//点击封面浏览图片
- (void)didClickItemActionWithIndex:(NSUInteger)index photos:(NSMutableArray *)photos;


////点击封面浏览图片
//- (void)didClickItemActionWithIndex:(NSUInteger)index photos:(NSMutableArray *)photos;

//点击封面浏览图片
//- (void)didClickItemActionWithIndex:(NSUInteger)index sourceImageView:(UIImageView *)sourceImageView;
//- (void)didClickItemActionWithIndex:(NSUInteger)index sourceImageView:(UIImageView *)sourceImageView;
@end



@interface MZCoverCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZLPhotoPickerBrowserViewControllerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic, strong) MZDynamicListModel *model;

@property (nonatomic, strong) MZMainPhotoDetailModel *detailModel;

@property (nonatomic, weak) id<MZCoverCollectionViewDelegate>delegate;

//@property (nonatomic , strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *imageArray;

//@property (nonatomic, strong)

@end
