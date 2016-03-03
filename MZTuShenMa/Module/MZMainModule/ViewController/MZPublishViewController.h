//
//  MZPublishViewController.h
//  MZTuShenMa
//
//  Created by zuo on 15/10/22.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"

@interface MZPublishViewController : MZBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray * assets;
/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;

@end
