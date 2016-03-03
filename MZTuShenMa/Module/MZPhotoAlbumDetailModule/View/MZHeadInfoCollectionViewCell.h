//
//  MZHeadInfoCollectionViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseCollectionViewCell.h"
#import "MZAlbumMembersModel.h"
@interface MZHeadInfoCollectionViewCell : MZBaseCollectionViewCell

@property (nonatomic,strong)  MZAlbumMembersModel *membersModel;

@property (nonatomic,strong)  UIImageView *headImage;
@property (nonatomic,strong)  UILabel *nameLabel;

@end
