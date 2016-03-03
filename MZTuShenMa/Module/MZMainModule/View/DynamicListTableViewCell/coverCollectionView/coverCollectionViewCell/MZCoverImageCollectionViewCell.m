//
//  MZCoverImageCollectionViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/12.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZCoverImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MZCoverImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _playButton.hidden = YES;
    _speechMarkImage.hidden = YES;
}

//- (void)setGoodListsModel:(MZMainGoodListsModel *)goodListsModel
//{
//    _goodListsModel = goodListsModel;
//    [_headImage sd_setImageWithURL:[NSURL URLWithString:goodListsModel.user_img] placeholderImage:[UIImage imageNamed:@"main_head"]];
//}

//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//    self.coverImage.image = nil;
//    [self.coverImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"main_dynamicPlaceholder"]];
//}

@end
