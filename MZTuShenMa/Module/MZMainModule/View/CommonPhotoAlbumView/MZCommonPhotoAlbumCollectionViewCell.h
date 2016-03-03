//
//  MZCommonPhotoAlbumCollectionViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 16/1/11.
//  Copyright © 2016年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDynamicListModel.h"
@interface MZCommonPhotoAlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) MZDynamicListModel *model;

+(CGSize)getItemSize:(MZDynamicListModel *)model;

@end
