//
//  DynamicDetailTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/25.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "DynamicCommentTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface DynamicCommentTableViewCell ()

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
///**
// *  用户名
// */
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  评论内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation DynamicCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _iconImage.layer.cornerRadius = CGRectGetHeight([self.iconImage bounds])/2;
    _iconImage.layer.masksToBounds = YES;
    
//    _lineView = [[UIView alloc]initWithFrame:rect(15.0f,35.0f,SCREEN_WIDTH-30.0f,1.0f)];
//    _lineView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
//    [self addSubview:_lineView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nicknameAction)];
    _contentLabel.userInteractionEnabled=YES;
    [_contentLabel addGestureRecognizer:tap];
}


//- (void)setIuiuh:(id)iuiuh
//{
//    _iuiuh = iuiuh;
//    if ([iuiuh isKindOfClass:[MZMainCommentListsModel class]]) {
//        self.model = iuiuh;
//    }else{
//        self.replyListsModel = iuiuh;
//    }
//}



- (void)setModel:(MZMainCommentListsModel *)model
{
    _model = model;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
    if (model.type == 0) {
        _contentLabel.text = [NSString stringWithFormat:@"%@: %@",model.uname,model.discuss];
    }else{
        
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@: %@",model.uname,model.cname,model.discuss]];
        [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x308afc) range:NSMakeRange(model.uname.length,2)];
        [_contentLabel setAttributedText:aString];
//        _contentLabel.text = [NSString stringWithFormat:@"%@回复%@: %@",model.uname,model.cname,model.discuss];
    }
    NSString *touserid=[NSString stringWithFormat:@"%@",model.common_id];
    self.toUserid=touserid;
  
}


//- (void)setReplyListsModel:(MZReplyListsModel *)replyListsModel
//{
//    _replyListsModel = replyListsModel;
//    [_iconImage sd_setImageWithURL:[NSURL URLWithString:replyListsModel.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
//    _contentLabel.text = [NSString stringWithFormat:@"%@回复%@: %@",replyListsModel.uname,replyListsModel.cname,replyListsModel.discuss];
////    _contentLabel.text = [NSString stringWithFormat:@"%@",replyListsModel.discuss];
//}


-(void)nicknameAction{
    
//    if ([_iuiuh isKindOfClass:[MZReplyListsModel class]]) {
//        if (_delegate  &&[_delegate respondsToSelector:@selector(setNickName:toUserid:)]) {
//            [_delegate setNickName:_replyListsModel.uname toUserid:_replyListsModel.replyListsId];
//        }
//    }else{
//        if (_delegate  &&[_delegate respondsToSelector:@selector(setNickName:toUserid:)]) {
//            [_delegate setNickName:_model.uname toUserid:self.toUserid];
//        }
//    }
    
    if (_model.type ==1) {
        //自己不能回复自己
        if ([_model.user_id isEqualToString:[userdefaultsDefine objectForKey:@"user_id"]]) {
            return;
        }else{
            //自己能回复别人
            if (_delegate &&[_delegate respondsToSelector:@selector(replyWithNickName:comment_id:group_id:comment_user_id:)]) {
//                [_delegate setNickName:_model.uname toUserid:_model.commentListsId];
                  [_delegate replyWithNickName:_model.uname comment_id:_model.common_id group_id:_model.group_id comment_user_id:_model.user_id];
            }
        }
    }else{
        if ([_model.user_id isEqualToString:[userdefaultsDefine objectForKey:@"user_id"]]) {
            return;
        }else{
        if (_delegate  &&[_delegate respondsToSelector:@selector(replyWithNickName:comment_id:group_id:comment_user_id:)]) {
//            [_delegate setNickName:_model.uname toUserid:self.toUserid];
             [_delegate replyWithNickName:_model.uname comment_id:_model.common_id group_id:_model.group_id comment_user_id:_model.user_id];
        }
        }
    }
  
}


+ (CGFloat)getCommentHeightWithNickname:(NSString *)nickname
{
    NSDictionary * nickAttribute = @{NSFontAttributeName: font(12.0f)};
    CGRect nickRect = [nickname boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 20), 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nickAttribute context:nil];
    
//    NSDictionary * commentAttribute = @{NSFontAttributeName: font(13.0f)};
//    CGRect commentRect = [comment boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 20), 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:commentAttribute context:nil];
    
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0]};
//    CGSize textSize1 = [comment boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 20), 10000) options:NSStringDrawingUsesLineFragmentOrigin |
//                        NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    
//    return textSize1.height+35;// 让文本离cell有一定的距离显示,上7.5,下7.5
    
    return nickRect.size.height +15 + 20;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
