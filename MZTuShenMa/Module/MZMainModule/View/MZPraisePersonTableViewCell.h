//
//  MZPraisePersonTableViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/28.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MZPraisePersonCollectionView.h"
@interface MZPraisePersonTableViewCell : UITableViewCell

@property (nonatomic,strong)MZPraisePersonCollectionView *praisePersonView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@property (nonatomic,strong) NSMutableArray *goodListsArray;


@end
