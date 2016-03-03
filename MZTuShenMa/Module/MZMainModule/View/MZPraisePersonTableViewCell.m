//
//  MZPraisePersonTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/28.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPraisePersonTableViewCell.h"

@implementation MZPraisePersonTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _praisePersonView = [[MZPraisePersonCollectionView alloc] initWithFrame:rect(15, 0, SCREEN_WIDTH-40.0f, 35)];
    _praisePersonView.backgroundColor = [UIColor clearColor];
    [self addSubview:_praisePersonView];
    
}

- (void)setGoodListsArray:(NSMutableArray *)goodListsArray
{
    _goodListsArray = goodListsArray;
    if (goodListsArray.count == 0) {
        _numberLabel.text = @"求赞啦";
    }
    _praisePersonView.datas = goodListsArray;
    _praisePersonView.collectionView.frame = rect(0, 0, SCREEN_WIDTH-40.0f-30.0f, 35*(goodListsArray.count/7+1));
//    _praisePersonView.collectionView.frame = rect(0, 0, SCREEN_WIDTH-40.0f-30.0f, 35*(21/7+1));
    _numberLabel.text = [NSString stringWithFormat:@"%ld个赞",_praisePersonView.datas.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
