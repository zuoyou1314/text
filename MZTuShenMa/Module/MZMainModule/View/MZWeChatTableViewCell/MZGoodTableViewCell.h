//
//  MZGoodTableViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZGroupListModel.h"
@interface MZGoodTableViewCell : UITableViewCell

@property (nonatomic,strong) MZGroupListModel *groupListModel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
