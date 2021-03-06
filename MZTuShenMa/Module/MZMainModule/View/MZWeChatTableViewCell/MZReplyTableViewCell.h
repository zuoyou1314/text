//
//  MZReplyTableViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/22.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZGroupListModel.h"

@protocol MZReplyTableViewCellDelegate <NSObject>

- (void)clickReplyButtonAction:(UIButton *)button group_id:(NSString *)group_id nickname:(NSString *)nickname;

@end


@interface MZReplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (nonatomic,strong) MZGroupListModel *groupListModel;
/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  相册名
 */
@property (nonatomic, copy) NSString *album_name;

@property (nonatomic,assign) id<MZReplyTableViewCellDelegate>delegate;

+(CGFloat)getDiscussHeightWith:(MZGroupListModel *)groupListModel;
-(CGFloat)getDiscussHeightWith:(MZGroupListModel *)groupListModel;

@end
