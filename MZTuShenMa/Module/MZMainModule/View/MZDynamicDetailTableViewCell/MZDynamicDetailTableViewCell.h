//
//  MZDynamicDetailTableViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/20.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZModel.h"
#import "MZMainPhotoDetailModel.h"
#import "MZSegmentLine.h"
#import "MZCoverCollectionView.h"
@protocol MZDynamicDetailTableViewCellDelegate <NSObject>

- (void)didClickPhotoDetailButtonWithTag:(NSInteger)tag photoId:(NSString *)photoId userId:(NSString *)userId detailPhotoModel:(MZModel *)detailPhotoModel row:(NSUInteger)row path_img:(NSString *)path_img ;

@end


// 用于标识是否需要是公关相册
typedef NS_ENUM(NSUInteger,MZDynamicDetailTableViewCellType) {
    MZDynamicDetailTableViewCellTypePublicAlbum,//公共相册动态详情
    MZDynamicDetailTableViewCellTypeNormal//普通相册动态详情
};

@interface MZDynamicDetailTableViewCell : UITableViewCell<MZCoverCollectionViewDelegate>

@property (nonatomic, assign) MZDynamicDetailTableViewCellType albumType;


@property (nonatomic, assign) id<MZDynamicDetailTableViewCellDelegate>delegate;

@property (nonatomic, strong) MZMainPhotoDetailModel *detailModel;

@property (nonatomic,strong) MZModel *detailPhotoModel;

@property (nonatomic,assign) NSUInteger row;

@property (nonatomic,strong) MZCoverCollectionView *coverCollectionView;

//相册id
@property (nonatomic,copy) NSString *album_id;
/**
 *  相册名
 */
@property (nonatomic, copy) NSString *album_name;




@end
