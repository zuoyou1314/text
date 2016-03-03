//
//  MOKOPictureBrowsingCollectionViewFlowLayout.m
//  MOKODreamWork_iOS2
//
//  Created by _SS on 15/7/28.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import "MOKOPictureBrowsingCollectionViewFlowLayout.h"

@implementation MOKOPictureBrowsingCollectionViewFlowLayout
- (instancetype)init{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.collectionView.contentOffset = self.offsetpoint;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
    
    return NO;
}

@end
