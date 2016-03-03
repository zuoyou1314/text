//
//  MZCoverCollectionView.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/12.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZCoverCollectionView.h"
#import "MZCoverImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MZDetailCoverImageCollectionViewCell.h"
#import "MZListsModel.h"
#import<MediaPlayer/MediaPlayer.h>
#import "UIView+MDWCategory.h"
#import "MDWMediaCenter.h"
@interface MZCoverCollectionView ()
{
    MPMoviePlayerController * _moviePC;
}
@end


@implementation MZCoverCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSString * const coverImageCellIdentifier = @"coverImageCell";
//static NSString * const detailCoverImageCellIdentifier = @"detailCoverImageCell";
#pragma mark - Getter
#pragma mark Get data
//- (NSMutableArray *)photos{
//    if (!_photos) {
//        _photos = [NSMutableArray array];
//          if (_detailModel.img_lists.count != 0) {
//              for (int i= 0;i< _detailModel.img_lists.count; i++) {
//                  ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc]init];
//                  photo.photoURL = [NSURL URLWithString:[_detailModel.img_lists objectAtIndex:i]];
//                  [_photos addObject:photo];
//              }
//          }else{
//              for (int i= 0;i< _model.img_lists.count; i++) {
//                  ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc]init];
//                  photo.photoURL = [NSURL URLWithString:[_model.img_lists objectAtIndex:i]];
//                  [_photos addObject:photo];
//           
//              }
//          }
//    }
//    return _photos;
//}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        
        _collectionView=[[UICollectionView alloc] initWithFrame:rect(0, 0,self.frame.size.width,self.frame.size.height) collectionViewLayout:layout];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"MZCoverImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:coverImageCellIdentifier];
        
//        [_collectionView registerNib:[UINib nibWithNibName:@"MZDetailCoverImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:detailCoverImageCellIdentifier];
        
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_collectionView];
    }
    
    return self;
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    if (imageArray.count == 1) {
        _collectionView.frame = rect(0, 0,self.frame.size.width,SCREEN_WIDTH-30.0f);
    }else if (imageArray.count == 2){
        _collectionView.frame = rect(0, 0,self.frame.size.width,(SCREEN_WIDTH-30.0f)/2);
    }else if (imageArray.count == 3){
        _collectionView.frame = rect(0, 0,self.frame.size.width,(SCREEN_WIDTH-30.0f)/3);
    }else if (imageArray.count == 4){
        _collectionView.frame = rect(0, 0,self.frame.size.width,SCREEN_WIDTH-30.0f);
    }else if (imageArray.count > 4 && imageArray.count < 7){
        _collectionView.frame = rect(0, 0,self.frame.size.width,((SCREEN_WIDTH-30.0f)/3)*2);
    }else{
        if (imageArray.count%3>0) {
            _collectionView.frame = rect(0, 0,self.frame.size.width,((SCREEN_WIDTH-30.0f)/3)*(imageArray.count/3+1)+10);
        }else{
            _collectionView.frame = rect(0, 0,self.frame.size.width,((SCREEN_WIDTH-30.0f)/3)*(imageArray.count/3));
        }
    }
    [_collectionView reloadData];
}


- (void)setModel:(MZDynamicListModel *)model
{
    _model = model;
    
    [_collectionView reloadData];
}

- (void)setDetailModel:(MZMainPhotoDetailModel *)detailModel
{
    _detailModel = detailModel;
    [_collectionView reloadData];
}

#pragma mark -------- UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (_detailModel.img_lists.count != 0) {
//        return _detailModel.img_lists.count;
//    }else {
//        return _model.img_lists.count;
//    }
//    [_photos removeAllObjects];
//    return self.photos.count;
    return _imageArray.count;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MZCoverImageCollectionViewCell* cell =  [collectionView dequeueReusableCellWithReuseIdentifier:coverImageCellIdentifier forIndexPath:indexPath];
    cell.coverImage.contentMode = UIViewContentModeScaleAspectFill;
    
    ZLPhotoPickerBrowserPhoto *photo = _imageArray[indexPath.row];
    photo.toView = cell.coverImage;
    if (_detailModel.lists.count != 0) {
            NSUInteger width;
            NSString *photoUrlString;
            if (_detailModel.lists.count == 1) {
                width = (self.frame.size.width-2)*2;
                photoUrlString = [NSString stringWithFormat:@"%@@w_%ld",photo.photoURL,(unsigned long)width];
            }else if(_detailModel.lists.count == 2 || _detailModel.lists.count == 4){
                width = (self.frame.size.width/2-2)*2;
                photoUrlString = [NSString stringWithFormat:@"%@@w_%ld",photo.photoURL,(unsigned long)width];
            }else {
                width = (self.frame.size.width/3-2)*2;
                photoUrlString = [NSString stringWithFormat:@"%@@w_%ld",photo.photoURL,(unsigned long)width];
            }
            [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:photoUrlString]];
            [self speechMarkForHiddenModel:nil detailModel:_detailModel cell:cell indexPath:indexPath];
    }else{
        NSUInteger width;
        NSString *photoUrlString;
        if (_model.lists.count == 1) {
            width = (self.frame.size.width-2)*2;
            photoUrlString = [NSString stringWithFormat:@"%@@w_%ld",photo.photoURL,(unsigned long)width];
            NSLog(@"photoUrlString == %@",photoUrlString);
            
        }else if(_model.lists.count == 2 || _model.lists.count == 4){
            width = (self.frame.size.width/2-2)*2;
            photoUrlString = [NSString stringWithFormat:@"%@@w_%ld",photo.photoURL,(unsigned long)width];
        }else {
            width = (self.frame.size.width/3-2)*2;
            photoUrlString = [NSString stringWithFormat:@"%@@w_%ld",photo.photoURL,(unsigned long)width];
        }
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:photoUrlString]];
        [self speechMarkForHiddenModel:_model detailModel:nil cell:cell indexPath:indexPath];
    }

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  lineSpacing = 2.0f;
    if (_detailModel.lists.count != 0) {
        if (_detailModel.lists.count == 1) {
//            if(iPhone6P){
//                return CGSizeMake(self.frame.size.width-lineSpacing-1, self.frame.size.height-lineSpacing-1);
//            }else{
                return CGSizeMake(self.frame.size.width-lineSpacing, self.frame.size.height-lineSpacing);
//            }
        }else if (_detailModel.lists.count == 2){
            return CGSizeMake(self.frame.size.width/2-lineSpacing,self.frame.size.width/2-lineSpacing);
        }else if (_detailModel.lists.count == 3){
            return CGSizeMake(self.frame.size.width/3-lineSpacing, self.frame.size.width/3-lineSpacing);
        }else if (_detailModel.lists.count == 4){
            return CGSizeMake(self.frame.size.width/2-lineSpacing,self.frame.size.width/2-lineSpacing);
        }else if (_detailModel.lists.count == 5){
            return CGSizeMake(self.frame.size.width/3-lineSpacing, self.frame.size.width/3-lineSpacing);
        }else{
            return CGSizeMake(self.frame.size.width/3-lineSpacing, self.frame.size.width/3-lineSpacing);
        }
    }else {
        if (_model.lists.count == 1) {
                return CGSizeMake(self.frame.size.width-lineSpacing, self.frame.size.height-lineSpacing);
        }else if (_model.lists.count == 2){
            return CGSizeMake(self.frame.size.width/2-lineSpacing,self.frame.size.width/2-lineSpacing);
        }else if (_model.lists.count == 3){
            return CGSizeMake(self.frame.size.width/3-lineSpacing, self.frame.size.width/3-lineSpacing);
        }else if (_model.lists.count == 4){
            return CGSizeMake(self.frame.size.width/2-lineSpacing,self.frame.size.width/2-lineSpacing);
        }else if (_model.lists.count == 5){
            return CGSizeMake(self.frame.size.width/3-lineSpacing, self.frame.size.width/3-lineSpacing);
        }else{
            return CGSizeMake(self.frame.size.width/3-lineSpacing, self.frame.size.width/3-lineSpacing);
        }

    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MZListsModel *listsModel;
    if (_detailModel.lists.count != 0) {
        listsModel =[_detailModel.lists objectAtIndex:indexPath.row];
    }else{
        listsModel =[_model.lists objectAtIndex:indexPath.row];
    }
    
    if ([listsModel.type isEqualToString:@"3"]) {
        NSLog(@"播放视频");
        
        MZCoverImageCollectionViewCell* cell = (MZCoverImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [[MDWMediaCenter defaultCenter] playMovieByURL:listsModel.path_video forView:cell.coverImage];
        cell.playButton.hidden = YES;
        [MDWMediaCenter defaultCenter].mediaCenterBlocks = ^(){
            cell.playButton.hidden = NO;
        };
//        [self playingMovieWithModel:listsModel];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(didClickItemActionWithIndex:photos:)]) {
            [self.delegate didClickItemActionWithIndex:indexPath.row photos:_imageArray];
        }
    }

}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.5;
}
//Cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.5;
}


#pragma mark ----- Private Method
//是否隐藏音频以及视频标签图片
- (void)speechMarkForHiddenModel:(MZDynamicListModel *)model detailModel:(MZMainPhotoDetailModel *)detailModel cell:(MZCoverImageCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    MZListsModel *listsModel;
    if (detailModel.lists.count != 0) {
        listsModel =[_detailModel.lists objectAtIndex:indexPath.row];
    }else{
        listsModel =[_model.lists objectAtIndex:indexPath.row];
    }
    
    if (listsModel.speechLists.count > 0) {
        cell.speechMarkImage.hidden = NO;
    }else{
        cell.speechMarkImage.hidden = YES;
    }
    
    if ([listsModel.type isEqualToString:@"3"]) {
        cell.playButton.hidden = NO;
    }else{
        cell.playButton.hidden = YES;
    }
}

/**
 *  播放视频
 *
 *  @param model
 */
- (void)playingMovieWithModel:(MZListsModel *)model
{
//    NSLog(@"播放视频");
//    NSURL * url = [NSURL URLWithString:model.path_video];
//    _moviePC = [[MPMoviePlayerController alloc]initWithContentURL:url];
//    [_moviePC prepareToPlay];
//    _moviePC.movieSourceType =MPMovieSourceTypeStreaming;
//    _moviePC.controlStyle = MPMovieControlStyleNone;
//    _moviePC.scalingMode = MPMovieScalingModeAspectFill;
//    _moviePC.view.frame= self.bounds;
//    [self addSubview:_moviePC.view];
//    [_moviePC play];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playingDone) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    _moviePC.view.alpha = 0;
//    [_moviePC.view ShowView:_moviePC.view During:1.75f delegate:nil];
    
 

}

///**
// *  播放完成
// */
//-(void)playingDone
//{
//    NSLog(@"播放完成");
//    //    _moviePC.view.superview.alpha = 0.2;
//    [_moviePC.view.superview ShowView:_moviePC.view.superview During:0.75f delegate:nil];
//    [_moviePC.view removeFromSuperview];
//    _moviePC = nil;
//}





@end
