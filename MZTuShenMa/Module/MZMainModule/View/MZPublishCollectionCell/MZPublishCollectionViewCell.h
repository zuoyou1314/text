//
//  MZPublishCollectionViewCell.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/22.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZPublishCollectionViewCellDelegate <NSObject>

- (void)clickRemoveButtonAction:(UIButton *)button;

@end


@interface MZPublishCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) id<MZPublishCollectionViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;



@end
