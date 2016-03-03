//
//  MZJoinAlbumTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZJoinAlbumTableViewCell.h"

@interface MZJoinAlbumTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *discussLabel;


@end


@implementation MZJoinAlbumTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setGroupListModel:(MZGroupListModel *)groupListModel
{
    _groupListModel = groupListModel;
    _discussLabel.text = groupListModel.discuss;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
