//
//  DynamicDetailTableViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/25.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZMainCommentListsModel.h"
#import "MZReplyListsModel.h"
@protocol DynamicCommentTableViewCellDelegate <NSObject>

//回复
- (void)replyWithNickName:(NSString *)nickname comment_id:(NSString *)comment_id group_id:(NSString *)group_id comment_user_id:(NSString *)comment_user_id;

////评论
//-(void)setNickName:(NSString *)nickname toUserid:(NSString *)toUserid;


@end

@interface DynamicCommentTableViewCell : UITableViewCell


@property (nonatomic,strong) MZMainCommentListsModel *model;

//@property (nonatomic,strong) MZReplyListsModel *replyListsModel;
/**
 *  自定义的cell分割线
 */
@property (strong, nonatomic)  UIView *lineView;

@property (nonatomic,assign) id<DynamicCommentTableViewCellDelegate>delegate;
//被回复人ID
@property(nonatomic,retain) NSString *toUserid;

//@property (nonatomic,strong) id iuiuh;

+(CGFloat)getCommentHeightWithNickname:(NSString *)nickname;



@end
