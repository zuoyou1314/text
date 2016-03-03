//
//  MZAboutMeReplyTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZAboutMeReplyTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface MZAboutMeReplyTableViewCell ()
//边框
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *publishImageView;
@property (weak, nonatomic) IBOutlet UILabel *discussLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOfHeight;


@end

@implementation MZAboutMeReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lineOfHeight.constant = 0.5;
    
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    _borderView.layer.borderColor = [[UIColor colorWithRed:193.0f/255.0f green:194.0f/255.0f blue:194.0f/255.0f alpha:1.0f]CGColor];
    _borderView.layer.borderWidth= 0.5f;
    
}

- (void)setGroupListModel:(MZGroupListModel *)groupListModel
{
    _groupListModel = groupListModel;
    if ([groupListModel.desc isEqualToString:@"回复"]) {
         _nameLabel.text = [NSString stringWithFormat:@"%@%@了您的评论:",groupListModel.name,groupListModel.desc];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@%@了您的照片:",groupListModel.name,groupListModel.desc];
    }
    [_publishImageView sd_setImageWithURL:[NSURL URLWithString:groupListModel.img] placeholderImage:[UIImage imageNamed:@"main_dynamicPlaceholder"]];
//    _discussLabel.backgroundColor = [UIColor redColor];
//    _discussHeight.constant = [self getDiscussHeightWith:groupListModel];
    _discussLabel.text = groupListModel.discuss;
    
}


//+(CGFloat)getDiscussHeightWith:(MZGroupListModel *)groupListModel
//{
//    NSDictionary * discussAttribute = @{NSFontAttributeName:font(16.0f)};
//    //@"这篇文章是我和我们团队最近对 UITableViewCell 利用 AutoLayout 自动高度计算和 UITableView 滑动优化的一个总结。我们也在维护一个开源的扩展，UITableView+FDTemplateLayoutCell，让高度计算这个事情变的前所未有的简单，也受到了很多星星的支持，github链接请戳我";
//    CGRect discussRect = [groupListModel.discuss boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 75), 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:discussAttribute context:nil];
//    return discussRect.size.height;
//}
//
//-(CGFloat)getDiscussHeightWith:(MZGroupListModel *)groupListModel
//{
//    NSDictionary * discussAttribute = @{NSFontAttributeName:font(16.0f)};
//    //@"这篇文章是我和我们团队最近对 UITableViewCell 利用 AutoLayout 自动高度计算和 UITableView 滑动优化的一个总结。我们也在维护一个开源的扩展，UITableView+FDTemplateLayoutCell，让高度计算这个事情变的前所未有的简单，也受到了很多星星的支持，github链接请戳我";
//    CGRect discussRect = [groupListModel.discuss boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 75), 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:discussAttribute context:nil];
//    return discussRect.size.height;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
