//
//  MZPraisePersonCollectionViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/28.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MZMainGoodListsModel.h"
@interface MZPraisePersonCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (nonatomic,strong) MZMainGoodListsModel *goodListsModel;

@end
