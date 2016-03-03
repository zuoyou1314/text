
//
//  MZDrawerTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDrawerTableViewCell.h"

@interface MZDrawerTableViewCell ()

@end


@implementation MZDrawerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _headImage.layer.cornerRadius = CGRectGetHeight(_headImage.bounds)/2;
    _headImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
