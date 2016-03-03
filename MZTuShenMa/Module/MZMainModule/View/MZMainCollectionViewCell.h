//
//  MZMainCollectionViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZMainResponseDataModel.h"
@interface MZMainCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *segmentLineView;

@property (nonatomic,strong)MZMainResponseDataModel *model;

+(CGFloat)getDiscussHeightWith:(MZMainResponseDataModel *)model;

@end
