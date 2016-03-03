//
//  MZMessageTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/29.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZMessageTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MZMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MZMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _headImage.layer.cornerRadius = CGRectGetHeight(_headImage.bounds)/2;
    _headImage.layer.masksToBounds = YES;
    
}

- (void)setModel:(MZNewlistsModel *)model
{
    _model = model;
    if (model.gid) {
        NSLog(@"点赞");
        [_headImage sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
//        _contentLabel.text = @"点赞";
        _contentLabel.text = model.discuss;
    }
    
    if (model.cid) {
        NSLog(@"评论");
        [_headImage sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
        _contentLabel.text = model.discuss;
    }
    
    NSTimeInterval time=[model.time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    _timeLabel.text = currentDateStr;
    
    
    if (model.rid) {
        NSLog(@"回复");
        [_headImage sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
        
        if (model.discuss) {
            _contentLabel.text = model.discuss;
        }else{
            _contentLabel.text = @"回复";
        }
        
        NSTimeInterval time=[model.time doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        _timeLabel.text = currentDateStr;
    }
    
    
    _nameLabel.text = model.user_name;
    
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:model.path_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
   

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
