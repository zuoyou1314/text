//
//  MZHeadInfoCollectionViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZHeadInfoCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MZHeadInfoCollectionViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, self.frame.size.height-35.0f, self.frame.size.height-35.0f)];
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50.0f, 50.0f)];
        _headImage.image = [UIImage imageNamed:@"main_backImage"];
        _headImage.layer.cornerRadius = CGRectGetHeight([_headImage frame])/2;
        _headImage.layer.masksToBounds = YES;
        [self addSubview:_headImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,_headImage.frame.origin.y+_headImage.frame.size.width+5.0f, 50, 15.0f)];
        _nameLabel.text = @"小美妹妹啦啦啦";
//        _nameLabel.backgroundColor = [UIColor redColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_nameLabel];
        
       
    }
    return self;
}

- (void)setMembersModel:(MZAlbumMembersModel *)membersModel
{
    _membersModel = membersModel;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:membersModel.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
    _nameLabel.text = membersModel.user_name;
}

@end
