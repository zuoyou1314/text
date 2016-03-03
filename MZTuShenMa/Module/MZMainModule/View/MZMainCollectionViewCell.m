//
//  MZMainCollectionViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZMainCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MZMainCollectionViewCell ()
/**
 *  背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *photoNumberImageV;
/**
 *  照片数量
 */
@property (weak, nonatomic) IBOutlet UIButton *photoNumberButton;
@property (weak, nonatomic) IBOutlet UIImageView *numberOfPeopleImageV;
/**
 *  成员数量
 */
@property (weak, nonatomic) IBOutlet UIButton *numberOfPeopleButton;
/**
 *  标题Lable
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIView *updateView;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;



#pragma mark ---- Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoNumberButtonHeight;


@end

@implementation MZMainCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _backImage.layer.cornerRadius = 0;
    _backImage.layer.masksToBounds = YES;
    _backImage.layer.borderColor = [[UIColor clearColor]CGColor];
    _backImage.contentMode = UIViewContentModeScaleAspectFill;
    
    _photoNumberImageV.layer.cornerRadius = _photoNumberButtonHeight.constant/2;
    _photoNumberImageV.layer.masksToBounds = YES;
    
    _numberOfPeopleImageV.layer.cornerRadius = _photoNumberButtonHeight.constant/2;
    _numberOfPeopleImageV.layer.masksToBounds = YES;
    
    
    UIBezierPath *maskPathButton = [UIBezierPath bezierPathWithRoundedRect:_updateButton.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(15.0,30.0)];
    CAShapeLayer *maskLayerButton = [[CAShapeLayer alloc] init];
    maskLayerButton.frame = _updateButton.bounds;
    maskLayerButton.path = maskPathButton.CGPath;
    _updateButton.layer.mask = maskLayerButton;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_updateView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(15.0,30.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _updateView.bounds;
    maskLayer.path = maskPath.CGPath;
    _updateView.layer.mask = maskLayer;
    
 
    
    
    
}

- (void)setModel:(MZMainResponseDataModel *)model
{
    _model = model;
    [_backImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"main_coverPlaceholder"]];
    [_photoNumberButton setTitle:[NSString stringWithFormat:@"  %@",model.photos] forState:UIControlStateNormal];
    [_numberOfPeopleButton setTitle:[NSString stringWithFormat:@"  %@",model.members] forState:UIControlStateNormal];
    _titleLabel.text = model.album_name;
    _desLabel.text = model.album_des;
    if ([MZMainCollectionViewCell getDiscussHeightWith:model]>14.0f) {
        _labelHeight.constant=[self getDiscussHeightWith:model];
    }else{
        _labelHeight.constant = 14.0f;
    }
    
    NSLog(@" ddd =+%ld",model.update_photos);
    if (model.update_photos > 0) {
        _updateView.hidden = NO;
        _updateButton.hidden = NO;
        [_updateButton setTitle:[NSString stringWithFormat:@" +%ld",(long)model.update_photos] forState:UIControlStateNormal];
    }else{
        _updateView.hidden = YES;
        _updateButton.hidden = YES;
    }

    
    
    NSTimeInterval time=[model.create_time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    NSLog(@"currentDateStr=%@",currentDateStr);
    _timeLabel.text = currentDateStr;
}

+(CGFloat)getDiscussHeightWith:(MZMainResponseDataModel *)model
{
    NSDictionary * discussAttribute = @{NSFontAttributeName:font(11.5f)};
    CGRect discussRect = [model.album_des boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 75), 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:discussAttribute context:nil];
    return discussRect.size.height;
}

-(CGFloat)getDiscussHeightWith:(MZMainResponseDataModel *)model
{
    NSDictionary * discussAttribute = @{NSFontAttributeName:font(11.5f)};
    CGRect discussRect = [model.album_des boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 75), 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:discussAttribute context:nil];
    return discussRect.size.height;
}

@end
