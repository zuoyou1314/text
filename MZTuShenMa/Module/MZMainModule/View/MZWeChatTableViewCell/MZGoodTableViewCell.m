//
//  MZGoodTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZGoodTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface MZGoodTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *publishImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOfHeight;


@end

@implementation MZGoodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lineOfHeight.constant = 0.5;
    
    _borderView.layer.borderColor = [[UIColor colorWithRed:193.0f/255.0f green:194.0f/255.0f blue:194.0f/255.0f alpha:1.0f]CGColor];
    _borderView.layer.borderWidth= 0.5f;
}

- (void)setGroupListModel:(MZGroupListModel *)groupListModel
{
    _groupListModel = groupListModel;
    _nameLabel.text = [NSString stringWithFormat:@"%@赞了您的照片:",groupListModel.name];
    [_publishImageView sd_setImageWithURL:[NSURL URLWithString:groupListModel.img] placeholderImage:[UIImage imageNamed:@"main_dynamicPlaceholder"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
