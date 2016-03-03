//
//  MZReplyTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/22.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZReplyTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MZGroupReplyModel.h"
#import "MZPhotoListViewController.h"
@interface MZReplyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *discussLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOfHeight;



@property (weak, nonatomic) IBOutlet UILabel *replyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyDiscussLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;


@end
@implementation MZReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _lineOfHeight.constant = 0.5;
    
    _headImage.layer.cornerRadius = CGRectGetHeight([_headImage bounds])/2;
    _headImage.layer.masksToBounds = YES;
    
    
    _headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHeadImageAction:)];
    [_headImage addGestureRecognizer:tap];
}

- (void)setGroupListModel:(MZGroupListModel *)groupListModel
{
    _groupListModel = groupListModel;
    
    
    
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:groupListModel.user_img] placeholderImage:[UIImage imageNamed:@"main_dynamicPlaceholder"]];
    _nameLabel.text = groupListModel.name;
    NSTimeInterval time=[groupListModel.time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    _timelabel.text = currentDateStr;
    _discussHeight.constant = [self getDiscussHeightWith:groupListModel];
    _discussLabel.text = groupListModel.discuss;
    if ([MZReplyTableViewCell getDiscussHeightWith:groupListModel]>14.31) {
        _lineHeight.constant=132.0f+([self getDiscussHeightWith:groupListModel]-14.31);
    }else{
        _lineHeight.constant =132.0f;
    }
    
    MZGroupReplyModel *replyModel = [groupListModel.reply objectAtIndex:0];
    NSTimeInterval replyTime=[replyModel.time doubleValue];
    NSDate *replyDetaildate=[NSDate dateWithTimeIntervalSince1970:replyTime];
    NSDateFormatter *replyDateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [replyDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *replyCurrentDateStr = [replyDateFormatter stringFromDate:replyDetaildate];
    _replyNameLabel.text = [NSString stringWithFormat:@"%@  发布于 %@",replyModel.name,replyCurrentDateStr];
    _replyDiscussLabel.text = replyModel.discuss;
    
}

- (IBAction)didClickReplyButtonAction:(id)sender {
    
    if ([_groupListModel.user_id isEqualToString:[userdefaultsDefine objectForKey:@"user_id"]]) {
        return;
    }else{
        if (_delegate  &&[_delegate respondsToSelector:@selector(clickReplyButtonAction:group_id:nickname:)]) {
            UIButton *replyButton = (UIButton *)sender;
            [_delegate  clickReplyButtonAction:replyButton group_id:_groupListModel.groupListId nickname:_groupListModel.name];
        }
    }
}

- (void)didClickHeadImageAction:(UITapGestureRecognizer *)tap
{
    MZPhotoListViewController *photoListVC = [[MZPhotoListViewController alloc]init];
    photoListVC.album_memId = _groupListModel.user_id;
    photoListVC.album_id = _album_id;
    photoListVC.album_name = _album_name;
    photoListVC.uname = _groupListModel.name;
    photoListVC.albumType = MZPhotoListViewControllerTypeNormal;
    [[self viewController].navigationController pushViewController:photoListVC animated:YES];
    
}

//找任意view所在控制器的方法
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


+(CGFloat)getDiscussHeightWith:(MZGroupListModel *)groupListModel
{
    NSDictionary * discussAttribute = @{NSFontAttributeName:font(12.0f)};
    //@"这篇文章是我和我们团队最近对 UITableViewCell 利用 AutoLayout 自动高度计算和 UITableView 滑动优化的一个总结。我们也在维护一个开源的扩展，UITableView+FDTemplateLayoutCell，让高度计算这个事情变的前所未有的简单，也受到了很多星星的支持，github链接请戳我";
    CGRect discussRect = [groupListModel.discuss boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 75), 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:discussAttribute context:nil];
    return discussRect.size.height+15;
}

-(CGFloat)getDiscussHeightWith:(MZGroupListModel *)groupListModel
{
    NSDictionary * discussAttribute = @{NSFontAttributeName:font(12.0f)};
    //@"这篇文章是我和我们团队最近对 UITableViewCell 利用 AutoLayout 自动高度计算和 UITableView 滑动优化的一个总结。我们也在维护一个开源的扩展，UITableView+FDTemplateLayoutCell，让高度计算这个事情变的前所未有的简单，也受到了很多星星的支持，github链接请戳我";
    CGRect discussRect = [groupListModel.discuss boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 75), 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:discussAttribute context:nil];
    return discussRect.size.height+15;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
