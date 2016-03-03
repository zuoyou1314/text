//
//  MZPublishCollectionViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/22.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPublishCollectionViewCell.h"

@implementation MZPublishCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)didClickRemoveButtonAction:(id)sender {
    if (_delegate  &&[_delegate respondsToSelector:@selector(clickRemoveButtonAction:)]) {
        [_delegate  clickRemoveButtonAction:(UIButton*)sender];
    }
}

//
//- (void)addLayer



@end
