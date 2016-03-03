//
//  MZPraisePersonCollectionViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/28.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPraisePersonCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MZPraisePersonCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _headImage.layer.cornerRadius =CGRectGetHeight([_headImage bounds])/2;
    _headImage.layer.masksToBounds = YES;
    
}

- (void)setGoodListsModel:(MZMainGoodListsModel *)goodListsModel
{
    _goodListsModel = goodListsModel;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:goodListsModel.user_img] placeholderImage:[UIImage imageNamed:@"main_head"]];
}

@end
