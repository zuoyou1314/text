//
//  MZPraisePersonCollectionView.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/28.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPraisePersonCollectionView.h"
#import "MZPraisePersonCollectionViewCell.h"
@implementation MZPraisePersonCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static NSString * const praisePersonCellIdentifier = @" praisePersonCell";

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        
        _collectionView=[[UICollectionView alloc] initWithFrame:rect(0, 0, self.frame.size.width-30.0f, self.frame.size.height) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"MZPraisePersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:praisePersonCellIdentifier];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_collectionView];
        
    }
    
    return self;
}


-(void)setDatas:(NSMutableArray *)datas{
    _datas = datas;
}

#pragma mark -------- UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MZMainGoodListsModel *goodListsModel = [_datas objectAtIndex:indexPath.row];
    MZPraisePersonCollectionViewCell* cell =  (MZPraisePersonCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:praisePersonCellIdentifier forIndexPath:indexPath];
//    cell.headImage.image = [UIImage imageNamed:@"120x120"];
    cell.goodListsModel = goodListsModel;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(22,22);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6.5, 6.5, 6.5, 6.5);
}



//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}



@end
