//
//  DynamicListTableViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZSegmentLine.h"
#import "MZDynamicListModel.h"
#import "MZMainPhotoDetailModel.h"
#import "MZModel.h"
#import "MZCoverCollectionView.h"
//#import "UIButton+MZRepeatClickButton.h"
@protocol MZDynamicListDelegate <NSObject>

- (void)didClickButtonWithTag:(NSInteger)tag photoId:(NSString *)photoId  dynamicListModel:(MZDynamicListModel *)dynamicListModel row:(NSUInteger)row;

@end

@interface DynamicListTableViewCell : UITableViewCell<MZCoverCollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate>

@property (nonatomic, assign) id<MZDynamicListDelegate>delegate;

@property (nonatomic, strong) MZDynamicListModel *model;

@property (nonatomic, strong) MZMainPhotoDetailModel *detailModel;

@property (nonatomic,strong) MZModel *detailPhotoModel;

@property (nonatomic,assign) NSUInteger row;

//相册id
@property (nonatomic,copy) NSString *album_id;
/**
 *  相册名
 */
@property (nonatomic, copy) NSString *album_name;

@property (nonatomic,strong) MZCoverCollectionView *coverCollectionView;




@end
