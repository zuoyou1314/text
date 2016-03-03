//
//  MZBlacklistTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/30.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBlacklistTableViewCell.h"

@interface MZBlacklistTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;


@end


@implementation MZBlacklistTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _headImage.layer.cornerRadius = CGRectGetHeight(_headImage.bounds)/2;
    _headImage.layer.masksToBounds = YES;
    
    _removeButton.layer.cornerRadius = 12;
    _removeButton.layer.masksToBounds = YES;
    
    
    
    
}
- (IBAction)didClickRemoveButtonAction:(id)sender {
    NSLog(@"移除黑名单");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    // Configure the view for the selected state
}

@end
