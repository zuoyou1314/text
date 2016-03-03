//
//  ZLPhotoPickerBrowserViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-14.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "ZLPhotoPickerBrowserViewController.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhotoRect.h"
#import "MZShareView.h"
#import "UIImageView+WebCache.h"
#import "MZResetAlbumImg.h"
#import "MZRequestManger+User.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "MZArowView.h"
#import "MZPhotoPickerBrowserModel.h"
#import <AVFoundation/AVFoundation.h>
#import "STKAudioPlayer.h"
static NSString *_cellIdentifier = @"collectionViewCell";

@interface ZLPhotoPickerBrowserViewController () <UIScrollViewDelegate,ZLPhotoPickerPhotoScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MZShareViewDelegate>
// 控件
@property (weak,nonatomic) UIView           *backView;
@property (weak,nonatomic) UILabel          *pageLabel;
@property (weak,nonatomic) UIPageControl    *pageControl;
@property (weak,nonatomic) UIButton         *deleleBtn;
@property (weak,nonatomic) UIButton         *backBtn;

@property (strong ,nonatomic) ZLPhotoPickerBrowserPhotoScrollView *photoPickerBrowserPhotoScrollView;
@property (strong, nonatomic) MZArowView *firstArrowView;
@property (strong, nonatomic) MZArowView *secondArrowView;
@property (strong, nonatomic) MZArowView *thirdArrowView;
@property (strong, nonatomic) MZArowView *fourthArrowView;
@property (strong, nonatomic) MZArowView *fifthArrowView;


@property (weak,nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) AVAudioPlayer *player;
// 需要增加的导航高度
@property (assign,nonatomic) CGFloat navigationHeight;

// 数据相关
// 单击时执行销毁的block
@property (nonatomic , copy) ZLPickerBrowserViewControllerTapDisMissBlock disMissBlock;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;
// 当前是否在旋转
@property (assign,nonatomic) BOOL isNowRotation;
// 是否是Push模式
@property (assign,nonatomic) BOOL isPush;

@end

@implementation ZLPhotoPickerBrowserViewController

#pragma mark - getter
#pragma mark photos
- (NSArray *)photos{
    if (!_photos) {
        _photos = [self getPhotos];
    }
    return _photos;
}

#pragma mark collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.view.zl_width + ZLPickerColletionViewPadding, self.view.zl_height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.zl_width,self.view.zl_height) collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
//        collectionView.backgroundColor = [UIColor redColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-ZLPickerColletionViewPadding)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotationDirection:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
        self.backView.hidden = NO;
        self.pageLabel.hidden = NO;
        self.shareButton.hidden = NO;
        self.downloadButton.hidden = NO;
        self.coverButton.hidden = NO;
        self.deleleBtn.hidden = !self.isEditing;
        self.deleleBtn.hidden = YES;
        
        self.firstArrowView.hidden = YES;
        self.secondArrowView.hidden = YES;
        self.thirdArrowView.hidden = YES;
        self.fourthArrowView.hidden = YES;
        self.fifthArrowView.hidden = YES;
        
        if (self.albumType == ZLPhotoPickerBrowserViewTypePublicAlbum) {
            self.coverButton.hidden = YES;
//            self.goodButton.hidden = NO;
//            self.commentButton.hidden = NO;
            self.goodButton.hidden = YES;
            self.commentButton.hidden = YES;
        }else{
            self.coverButton.hidden = NO;
            self.goodButton.hidden = YES;
            self.commentButton.hidden = YES;
        }
        
    }
    return _collectionView;
}

#pragma mark deleleBtn
- (UIButton *)deleleBtn{
    if (!_deleleBtn) {
        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleleBtn.translatesAutoresizingMaskIntoConstraints = NO;
        deleleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleleBtn setImage:[UIImage ml_imageFromBundleNamed:@"nav_delete_btn"] forState:UIControlStateNormal];
        
        // 设置阴影
//        deleleBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        deleleBtn.layer.shadowColor = [UIColor yellowColor].CGColor;
        deleleBtn.layer.shadowOffset = CGSizeMake(0, 0);
        deleleBtn.layer.shadowRadius = 3;
        deleleBtn.layer.shadowOpacity = 1.0;
        deleleBtn.hidden = YES;
        
        [deleleBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleleBtn = deleleBtn];
        
        NSString *widthVfl = @"H:[deleleBtn(deleteBtnWH)]-margin-|";
        NSString *heightVfl = @"V:|-margin-[deleleBtn(deleteBtnWH)]";
        NSDictionary *metrics = @{@"deleteBtnWH":@(50),@"margin":@(10)};
        NSDictionary *views = NSDictionaryOfVariableBindings(deleleBtn);
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _deleleBtn;
}

#pragma mark backView
- (UIView *)backView
{
    if (!_backView) {
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = RGBA(0, 0, 0, 0.7);
        backView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:backView];
        self.backView = backView;
        
        NSString *widthVfl = @"H:|-0-[backView]-0-|";
        NSString *heightVfl = @"V:|-0-[backView(ZLPickerPageCtrlH)]-0-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(backView);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(64)};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _backView;
}

#pragma mark pageLabel
- (UILabel *)pageLabel{
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.font = [UIFont systemFontOfSize:18];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.userInteractionEnabled = NO;
        pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:pageLabel];
        self.pageLabel = pageLabel;
        
        NSString *widthVfl = @"H:|-0-[pageLabel]-0-|";
        NSString *heightVfl = @"V:|-20-[pageLabel(ZLPickerPageCtrlH)]|";
        NSDictionary *views = NSDictionaryOfVariableBindings(pageLabel);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(44)};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _pageLabel;
}

- (UIButton *)shareButton
{
    if (_shareButton != nil) {
        return _shareButton;
    }
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = rect(15.0f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
    _shareButton.tag = 40000;
    [_shareButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    _shareButton.layer.borderColor = [[UIColor colorWithRed:94/255.0f green:94/255.0f blue:94/255.0f alpha:1.0f]CGColor];
    _shareButton.layer.borderWidth= 0.5f;
    _shareButton.layer.cornerRadius = 8;
    _shareButton.layer.masksToBounds = YES;
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _shareButton.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self.view addSubview:_shareButton];
//    if (_imagesArray.count>0) {
//        _shareButton.hidden = YES;
//    }
    return _shareButton;
}

- (UIButton *)downloadButton
{
    if (_downloadButton != nil) {
        return _downloadButton;
    }
    _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iPhone6) {
        _downloadButton.frame = rect(self.shareButton.frame.origin.x + self.shareButton.frame.size.width + 37.5f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
    }else if (iPhone6P){
        _downloadButton.frame = rect(self.shareButton.frame.origin.x + self.shareButton.frame.size.width + 57.5f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
    }else{
        _downloadButton.frame = rect(self.shareButton.frame.origin.x + self.shareButton.frame.size.width + 17.5f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
    }
    _downloadButton.tag = 40001;
    [_downloadButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    _downloadButton.layer.borderColor = [[UIColor colorWithRed:94/255.0f green:94/255.0f blue:94/255.0f alpha:1.0f]CGColor];
    _downloadButton.layer.borderWidth= 0.5f;
    _downloadButton.layer.cornerRadius = 8;
    _downloadButton.layer.masksToBounds = YES;
    _downloadButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _downloadButton.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self.view addSubview:_downloadButton];
//    if (_imagesArray.count>0) {
//        _downloadButton.hidden = YES;
//    }
    return _downloadButton;
}

- (UIButton *)coverButton
{
    if (_coverButton != nil) {
        return _coverButton;
    }
    _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iPhone6) {
        _coverButton.frame = rect(self.downloadButton.frame.origin.x + self.downloadButton.frame.size.width + 37.5f, SCREEN_HEIGHT-51.0f, 109.0f, 38.0f);
    }else if (iPhone6P){
        _coverButton.frame = rect(self.downloadButton.frame.origin.x + self.downloadButton.frame.size.width + 57.5f, SCREEN_HEIGHT-51.0f, 109.0f, 38.0f);
    }else{
        _coverButton.frame = rect(self.downloadButton.frame.origin.x + self.downloadButton.frame.size.width + 17.5f, SCREEN_HEIGHT-51.0f, 109.0f, 38.0f);
    }
    _coverButton.tag = 40002;
    [_coverButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_coverButton setTitle:@"设置为相册封面" forState:UIControlStateNormal];
    //    _coverButton.layer.borderColor = [[UIColor colorWithRed:65.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:1.0f]CGColor];
    _coverButton.layer.borderColor = [[UIColor colorWithRed:94/255.0f green:94/255.0f blue:94/255.0f alpha:1.0f]CGColor];
    _coverButton.layer.borderWidth= 0.5f;
    _coverButton.layer.cornerRadius = 8;
    _coverButton.layer.masksToBounds = YES;
    _coverButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _coverButton.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self.view addSubview:_coverButton];
//    if (_imagesArray.count>0) {
//        _coverButton.hidden = YES;
//    }
    return _coverButton;
}

- (UIButton *)goodButton
{
    if (_goodButton != nil) {
        return _goodButton;
    }
    _goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goodButton.frame = rect(SCREEN_WIDTH/2, 20, SCREEN_WIDTH/4 ,44.0f);
    [_goodButton setImage:[UIImage  imageNamed:@"main_love"] forState:UIControlStateNormal];
    [_goodButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:146.0f/255.0f blue:146.0f/255.0f alpha:1.0f ] forState:UIControlStateNormal];
    [_goodButton setTitle:@" 145" forState:UIControlStateNormal];
    _goodButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _goodButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    [_goodButton setTitle:[NSString stringWithFormat:@" %ld",(long)_goods] forState:UIControlStateNormal];
    [_goodButton addTarget:self action:@selector(didClickGoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    _goodButton.tag = [_photoId integerValue];
//    if (self.isHidden == YES) {
//        _goodButton.hidden = YES;
//    }
    [self.view addSubview:_goodButton];
    return _goodButton;
}


- (UIButton *)commentButton
{
    if (_commentButton != nil) {
        return _commentButton;
    }
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = rect(SCREEN_WIDTH/4+SCREEN_WIDTH/2-10.0f, 20, SCREEN_WIDTH/4 ,44.0f);
    _commentButton.tag = 40004;
    [_commentButton setImage:[UIImage  imageNamed:@"main_comment"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:146.0f/255.0f blue:146.0f/255.0f alpha:1.0f ] forState:UIControlStateNormal];
    [_commentButton setTitle:@" 145" forState:UIControlStateNormal];
    _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    [_commentButton setTitle:[NSString stringWithFormat:@" %ld",(long)_comments] forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(didClickGoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    _commentButton.tag = [_photoId integerValue];
//    if (self.isHidden == YES) {
//        _commentButton.hidden = YES;
//    }
    [self.view addSubview:_commentButton];
    return _commentButton;
}


- (MZArowView *)firstArrowView
{
    if (_firstArrowView != nil) {
        return _firstArrowView;
    }
    _firstArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_firstArrowView];
    return _firstArrowView;
}

- (MZArowView *)secondArrowView
{
    if (_secondArrowView != nil) {
        return _secondArrowView;
    }
    _secondArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_secondArrowView];
    return _secondArrowView;
}


- (MZArowView *)thirdArrowView
{
    if (_thirdArrowView != nil) {
        return _thirdArrowView;
    }
    _thirdArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_thirdArrowView];
    return _thirdArrowView;
}

- (MZArowView *)fourthArrowView
{
    if (_fourthArrowView != nil) {
        return _fourthArrowView;
    }
    _fourthArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_fourthArrowView];
    return _fourthArrowView;
}

- (MZArowView *)fifthArrowView
{
    if (_fifthArrowView != nil) {
        return _fifthArrowView;
    }
    _fifthArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_fifthArrowView];
    return _fifthArrowView;
}


/**
 *  创建照片详情,以及上面的5个录音标签
 */
- (void)createPhotoImageViewAndArrowView:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath
{
    NSArray *strarray = [_pageLabel.text componentsSeparatedByString:@"/"];
    ZLPhotoPickerBrowserPhoto *photoModel = [_photos objectAtIndex:[[strarray objectAtIndex:0] integerValue]-1];
    
    [_firstArrowView stopPlay];
    [_secondArrowView stopPlay];
    [_thirdArrowView stopPlay];
    [_fourthArrowView stopPlay];
    [_fifthArrowView stopPlay];
    
    if (photoModel.speechMarkModel.count == 0) {
        self.firstArrowView.hidden = YES;
        self.secondArrowView.hidden = YES;
        self.thirdArrowView.hidden = YES;
        self.fourthArrowView.hidden = YES;
        self.fifthArrowView.hidden = YES;
    }else{
        
        self.firstArrowView.hidden = YES;
        self.secondArrowView.hidden = YES;
        self.thirdArrowView.hidden = YES;
        self.fourthArrowView.hidden = YES;
        self.fifthArrowView.hidden = YES;
        
    
       
        
        __weak typeof(self) weakSelf = self;
        for (int i = 0; i<photoModel.speechMarkModel.count; i++) {
            MZPhotoPickerBrowserModel *model = [photoModel.speechMarkModel objectAtIndex:i];
            if (i == 0) {
                [_firstArrowView.leftArrowButton setTitle:model.track forState:UIControlStateNormal];
                [_firstArrowView.rightArrowButton setTitle:model.track  forState:UIControlStateNormal];
//                _firstArrowView.frame = rect([model.coords_x floatValue]*SCREEN_WIDTH - 56.0f , [model.coords_y floatValue]*SCREEN_HEIGHT, 112+8, 50/2);
                _firstArrowView.frame = rect([model.coords_x floatValue]*SCREEN_WIDTH - 56.0f ,  [model.coords_y floatValue]*SCREEN_HEIGHT+_photoPickerBrowserPhotoScrollView.photoImageView.frame.origin.y, 112+8, 50/2);
                
                _firstArrowView.hidden = NO;
                if ([model.coords_x floatValue]-56.0f <= SCREEN_WIDTH/2) {
                    _firstArrowView.leftArrowButton.hidden = YES;
                }else{
                    _firstArrowView.rightArrowButton.hidden = YES;
                }
                _firstArrowView.userInteractionEnabled = YES;
                _firstArrowView.speechPathUrl = [NSURL URLWithString:model.speech_path];
//                _firstArrowView.type = MZArowViewTypePublicAlbum;
                _firstArrowView.arowViewBeganBlocks = ^(){
                    weakSelf.secondArrowView.userInteractionEnabled = NO;
                    weakSelf.thirdArrowView.userInteractionEnabled = NO;
                    weakSelf.fourthArrowView.userInteractionEnabled = NO;
                    weakSelf.fifthArrowView.userInteractionEnabled = NO;
                };
                _firstArrowView.arowViewOverBlocks = ^(){
                    weakSelf.secondArrowView.userInteractionEnabled = YES;
                    weakSelf.thirdArrowView.userInteractionEnabled = YES;
                    weakSelf.fourthArrowView.userInteractionEnabled = YES;
                    weakSelf.fifthArrowView.userInteractionEnabled = YES;
                };
                

            }
            
            
            if (i == 1) {
                [_secondArrowView.leftArrowButton setTitle:model.track forState:UIControlStateNormal];
                [_secondArrowView.rightArrowButton setTitle:model.track  forState:UIControlStateNormal];
                _secondArrowView.frame = rect([model.coords_x floatValue]*SCREEN_WIDTH - 56.0f , [model.coords_y floatValue]*SCREEN_HEIGHT+_photoPickerBrowserPhotoScrollView.photoImageView.frame.origin.y, 112+8, 50/2);
                _secondArrowView.hidden = NO;
                if ([model.coords_x floatValue]-56.0f <= SCREEN_WIDTH/2) {
                    _secondArrowView.rightArrowButton.hidden = YES;
                }else{
                    _secondArrowView.leftArrowButton.hidden = YES;
                }
                _secondArrowView.userInteractionEnabled = YES;
                _secondArrowView.speechPathUrl = [NSURL URLWithString:model.speech_path];
//                _secondArrowView.type = MZArowViewTypePublicAlbum;
                _secondArrowView.arowViewBeganBlocks = ^(){
                    weakSelf.firstArrowView.userInteractionEnabled = NO;
                    weakSelf.thirdArrowView.userInteractionEnabled = NO;
                    weakSelf.fourthArrowView.userInteractionEnabled = NO;
                    weakSelf.fifthArrowView.userInteractionEnabled = NO;
                };
                _secondArrowView.arowViewOverBlocks = ^(){
                    weakSelf.firstArrowView.userInteractionEnabled = YES;
                    weakSelf.thirdArrowView.userInteractionEnabled = YES;
                    weakSelf.fourthArrowView.userInteractionEnabled = YES;
                    weakSelf.fifthArrowView.userInteractionEnabled = YES;
                };
            }
            
            if (i == 2) {
                [_thirdArrowView.leftArrowButton setTitle:model.track forState:UIControlStateNormal];
                [_thirdArrowView.rightArrowButton setTitle:model.track  forState:UIControlStateNormal];
                _thirdArrowView.frame = rect([model.coords_x floatValue]*SCREEN_WIDTH - 56.0f , [model.coords_y floatValue]*SCREEN_HEIGHT+_photoPickerBrowserPhotoScrollView.photoImageView.frame.origin.y, 112+8, 50/2);
                _thirdArrowView.hidden = NO;
                if ([model.coords_x floatValue]-56.0f <= SCREEN_WIDTH/2) {
                    _thirdArrowView.rightArrowButton.hidden = YES;
                }else{
                    _thirdArrowView.leftArrowButton.hidden = YES;
                }
                _thirdArrowView.userInteractionEnabled = YES;
//                _thirdArrowView.type = MZArowViewTypePublicAlbum;
                _thirdArrowView.speechPathUrl = [NSURL URLWithString:model.speech_path];
                
                _thirdArrowView.arowViewBeganBlocks = ^(){
                    weakSelf.firstArrowView.userInteractionEnabled = NO;
                    weakSelf.secondArrowView.userInteractionEnabled = NO;
                    weakSelf.fourthArrowView.userInteractionEnabled = NO;
                    weakSelf.fifthArrowView.userInteractionEnabled = NO;
                };
                _thirdArrowView.arowViewOverBlocks = ^(){
                    weakSelf.firstArrowView.userInteractionEnabled = YES;
                    weakSelf.secondArrowView.userInteractionEnabled = YES;
                    weakSelf.fourthArrowView.userInteractionEnabled = YES;
                    weakSelf.fifthArrowView.userInteractionEnabled = YES;
                };
            }
            
            if (i == 3) {
                [_fourthArrowView.leftArrowButton setTitle:model.track forState:UIControlStateNormal];
                [_fourthArrowView.rightArrowButton setTitle:model.track  forState:UIControlStateNormal];
                _fourthArrowView.frame = rect([model.coords_x floatValue]*SCREEN_WIDTH - 56.0f , [model.coords_y floatValue]*SCREEN_HEIGHT+_photoPickerBrowserPhotoScrollView.photoImageView.frame.origin.y, 112+8, 50/2);
                _fourthArrowView.hidden = NO;
                if ([model.coords_x floatValue]-56.0f <= SCREEN_WIDTH/2) {
                    _fourthArrowView.rightArrowButton.hidden = YES;
                }else{
                    _fourthArrowView.leftArrowButton.hidden = YES;
                }
                _fourthArrowView.userInteractionEnabled = YES;
                _fourthArrowView.speechPathUrl = [NSURL URLWithString:model.speech_path];
//                _fourthArrowView.type = MZArowViewTypePublicAlbum;
                _fourthArrowView.arowViewBeganBlocks = ^(){
                    weakSelf.firstArrowView.userInteractionEnabled = NO;
                    weakSelf.secondArrowView.userInteractionEnabled = NO;
                    weakSelf.thirdArrowView.userInteractionEnabled = NO;
                    weakSelf.fifthArrowView.userInteractionEnabled = NO;
                };
                _fourthArrowView.arowViewOverBlocks = ^(){
                    weakSelf.firstArrowView.userInteractionEnabled = YES;
                    weakSelf.secondArrowView.userInteractionEnabled = YES;
                    weakSelf.thirdArrowView.userInteractionEnabled = YES;
                    weakSelf.fifthArrowView.userInteractionEnabled = YES;
                };
            }
            
            if (i == 4) {
                [_fifthArrowView.leftArrowButton setTitle:model.track forState:UIControlStateNormal];
                [_fifthArrowView.rightArrowButton setTitle:model.track  forState:UIControlStateNormal];
                _fifthArrowView.frame = rect([model.coords_x floatValue]*SCREEN_WIDTH - 56.0f , [model.coords_y floatValue]*SCREEN_HEIGHT+_photoPickerBrowserPhotoScrollView.photoImageView.frame.origin.y, 112+8, 50/2);
                _fifthArrowView.hidden = NO;
                if ([model.coords_x floatValue]-56.0f <= SCREEN_WIDTH/2) {
                    _fifthArrowView.rightArrowButton.hidden = YES;
                }else{
                    _fifthArrowView.leftArrowButton.hidden = YES;
                }
                _fifthArrowView.userInteractionEnabled = YES;
                _fifthArrowView.speechPathUrl = [NSURL URLWithString:model.speech_path];
//                _fifthArrowView.type = MZArowViewTypePublicAlbum;
                _fifthArrowView.arowViewBeganBlocks = ^(){
                    weakSelf.firstArrowView.userInteractionEnabled = NO;
                    weakSelf.secondArrowView.userInteractionEnabled = NO;
                    weakSelf.thirdArrowView.userInteractionEnabled = NO;
                    weakSelf.fourthArrowView.userInteractionEnabled = NO;
                };
                _fifthArrowView.arowViewOverBlocks = ^(){
                    weakSelf.firstArrowView.userInteractionEnabled = YES;
                    weakSelf.secondArrowView.userInteractionEnabled = YES;
                    weakSelf.thirdArrowView.userInteractionEnabled = YES;
                    weakSelf.fourthArrowView.userInteractionEnabled = YES;
                };
            }
            
        }
    }

    
    
//    for (int i = 0; i<photoModel.speechMarkModel.count; i++) {
//        MZPhotoPickerBrowserModel *model = [photoModel.speechMarkModel objectAtIndex:i];
//        MZArowView *arowView = [[MZArowView alloc]initWithFrame:rect([model.coords_x floatValue]*SCREEN_WIDTH - 56.0f , [model.coords_y floatValue]*SCREEN_HEIGHT, 112+8, 50/2)];
//        [arowView.leftArrowButton setTitle:model.track forState:UIControlStateNormal];
//        [arowView.rightArrowButton setTitle:model.track  forState:UIControlStateNormal];
//        if ([model.coords_x floatValue]-56.0f <= SCREEN_WIDTH/2) {
//            arowView.rightArrowButton.hidden = YES;
//        }else{
//            arowView.leftArrowButton.hidden = YES;
//        }
//        arowView.tag = 500+i;
//        arowView.speechPathUrl = [NSURL URLWithString:model.speech_path];
//        [self.view addSubview:arowView];
//    }

    

}

- (void)didClickGoodButtonAction:(UIButton *)button
{
    if (_delegate&&[_delegate respondsToSelector:@selector(clickGoodButtonAction:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [_delegate clickGoodButtonAction:button];
        }];
    }
}


#pragma mark pageControl
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:pageControl];
        self.pageControl = pageControl;
        
        NSString *widthVfl = @"H:|-0-[pageControl]-0-|";
        NSString *heightVfl = @"V:[pageControl(ZLPickerPageCtrlH)]-20-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(pageControl);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(ZLPickerPageCtrlH)};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _pageControl;
}

- (void)didClickButtonAction:(UIButton *)button
{
    switch (button.tag) {
        case 40000:
        {
            MZShareView *shareView =[[MZShareView alloc]init];
            shareView.frame = [UIScreen mainScreen].bounds;
            shareView.delegate = self;
            [shareView show];
        }
            break;
        case 40001:
        {
            NSLog(@"下载");
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            ZLPhotoPickerBrowserPhoto *photoModel = [_photos objectAtIndex:[[_pageLabel.text substringToIndex:1] integerValue]-1];
            //NSNSURL转NSString
//            NSString *photoString = photoModel.photoURL.absoluteString;
//            NSArray *array = [photoString componentsSeparatedByString:@"t_"];
            // [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[array objectAtIndex:0],[array objectAtIndex:1]]
            [manager downloadImageWithURL:photoModel.photoURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"显示当前进度");
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                NSLog(@"下载完成");
                //下载图片到相册
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下载成功了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alerView show];
            }];
            
        }
            break;
        case 40002:
        {
            NSLog(@"设置为封面");
            MZResetAlbumImg *resetAlbumImg = [[MZResetAlbumImg alloc]init];
            resetAlbumImg.album_id = _album_id;
            resetAlbumImg.user_id = [userdefaultsDefine objectForKey:@"user_id"];
            NSArray *strarray = [_pageLabel.text componentsSeparatedByString:@"/"];
            ZLPhotoPickerBrowserPhoto *photoModel = [_photos objectAtIndex:[[strarray objectAtIndex:0] integerValue]-1];
            //NSNSURL转NSString
            NSString *photoString = photoModel.photoURL.absoluteString;
            resetAlbumImg.img_url = photoString;
            [MZRequestManger resetAlbumImgRequest:resetAlbumImg success:^(NSDictionary *object) {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    return ;
                }
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设为封面成功了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alerView show];
            } failure:^(NSString *errMsg, NSString *errCode) {
                
            }];
        }
            break;
        default:
            break;
    }
}

- (void)clickWechatButtonAction
{
    [self shareImageWithSocialPlatformWithName:UMShareToWechatSession];
}

- (void)shareImageWithSocialPlatformWithName:(NSString *)name
{
    __weak typeof(self) weakSelf = self;
    UIImageView *sharImage = [[UIImageView alloc] init];
    ZLPhotoPickerBrowserPhoto *photoModel = [_photos objectAtIndex:[[_pageLabel.text substringToIndex:1] integerValue]-1];
    //NSNSURL转NSString
//    NSString *photoString = photoModel.photoURL.absoluteString;
//    NSArray *array = [photoString componentsSeparatedByString:@"t_"];
    [sharImage sd_setImageWithURL:photoModel.photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
        [socialControllerService setShareText:@"和你的朋友一起玩的相册" shareImage:UIImagePNGRepresentation(sharImage.image) socialUIDelegate:nil];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:name].snsClickHandler(weakSelf,socialControllerService,YES);
    }];

//    [sharImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[array objectAtIndex:0],[array objectAtIndex:1]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
//        [socialControllerService setShareText:@"和你的朋友一起玩的相册" shareImage:UIImagePNGRepresentation(sharImage.image) socialUIDelegate:nil];
//        [UMSocialSnsPlatformManager getSocialPlatformWithName:name].snsClickHandler(weakSelf,socialControllerService,YES);
//    }];
}

- (void)clickWechatFriendButtonAction
{
    [self shareImageWithSocialPlatformWithName:UMShareToWechatTimeline];
}


#pragma mark getPhotos
- (NSArray *)getPhotos{
    NSMutableArray *photos = [NSMutableArray arrayWithArray:_photos];
    if ([self isDataSourceElsePhotos]) {
        NSInteger section = self.currentIndexPath.section;
        NSInteger rows = [self.dataSource photoBrowser:self numberOfItemsInSection:section];
        photos = [NSMutableArray arrayWithCapacity:rows];
        for (NSInteger i = 0; i < rows; i++) {
            [photos addObject:[self.dataSource photoBrowser:self photoAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]]];
        }
    }
    return photos;
}

#pragma mark - Life cycle
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.photos.count == 0) {
        NSAssert(self.dataSource, @"你没成为数据源代理");
    }
    if (!self.isPush) {
        
    }else{
        if (self.currentPage >= 0) {
            self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width, self.collectionView.contentOffset.y);
            if (self.currentPage == self.photos.count - 1 && self.photos.count > 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width - ZLPickerColletionViewPadding, self.collectionView.contentOffset.y);
                });
            }
        }
    }
}

- (void)showToView{
    _photos = [_photos copy];
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor blackColor];
//    mainView.backgroundColor = [UIColor cyanColor];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    UIView *mainBgView = [[UIView alloc] init];
    mainBgView.alpha = 0.0;
    mainBgView.backgroundColor = [UIColor blackColor];
//    mainBgView.backgroundColor = [UIColor purpleColor];
    mainBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainBgView.frame = [UIScreen mainScreen].bounds;
    [mainView addSubview:mainBgView];
    
    __block UIImageView *toImageView = nil;
    if ([self isDataSourceElsePhotos]) {
        toImageView = (UIImageView *)[[self.dataSource photoBrowser:self photoAtIndexPath:self.currentIndexPath] toView];
    }else{
        toImageView = (UIImageView *)[self.photos[self.currentIndexPath.row] toView];
    }
    
    if (![toImageView isKindOfClass:[UIImageView class]] && self.status != UIViewAnimationAnimationStatusFade) {
        assert(@"error: need toView `UIImageView` class.");
        return;
    }
    
    __block UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [mainBgView addSubview:imageView];
    mainView.clipsToBounds = YES;
    
    UIImage *thumbImage = nil;
    if ([self isDataSourceElsePhotos]) {
        if ([self.photos[self.currentIndexPath.item] asset] == nil) {
            thumbImage = [[self.dataSource photoBrowser:self photoAtIndexPath:self.currentIndexPath] thumbImage];
        }else{
            thumbImage = [[self.dataSource photoBrowser:self photoAtIndexPath:self.currentIndexPath] aspectRatioImage];
        }
    }else{
        if ([self.photos[self.currentPage] asset] == nil) {
            thumbImage = [self.photos[self.currentIndexPath.item] thumbImage];
        }else{
            thumbImage = [self.photos[self.currentIndexPath.item] photoImage];
        }
    }
    
    if (thumbImage == nil) {
        thumbImage = toImageView.image;
    }
    
    if (self.status == UIViewAnimationAnimationStatusFade){
        imageView.image = thumbImage;
    }else{
        if (thumbImage == nil) {
            imageView.image = toImageView.image;
        }else{
            imageView.image = thumbImage;
        }
    }
    
    if (self.status == UIViewAnimationAnimationStatusFade){
        imageView.alpha = 0.0;
        imageView.frame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImage:imageView.image];
    }else if(self.status == UIViewAnimationAnimationStatusZoom){
        CGRect tempF = [toImageView.superview convertRect:toImageView.frame toView:[self getParsentView:toImageView]];
//        NSLog(@"%@",[self getParsentViewController:toImageView]);
//        NSLog(@"%@ %@  %@",toImageView,NSStringFromCGRect(tempF),[self getParsentView:toImageView]);
        if (self.navigationHeight) {
            tempF.origin.y += self.navigationHeight;
        }
        imageView.frame = tempF;
    }
    
    __block CGRect tempFrame = imageView.frame;
    __weak typeof(self)weakSelf = self;
    self.disMissBlock = ^(NSInteger page){
        mainView.hidden = NO;
        mainView.alpha = 1.0;
        CGRect originalFrame = CGRectZero;
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        // 缩放动画
        if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
            UIImage *thumbImage = nil;
            if ([weakSelf isDataSourceElsePhotos]) {
                if ([weakSelf.photos[weakSelf.currentPage] asset] == nil) {
                    thumbImage = [[weakSelf.dataSource photoBrowser:weakSelf photoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]] thumbImage];
                }else{
                    thumbImage = [[weakSelf.dataSource photoBrowser:weakSelf photoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]] photoImage];
                }
                
            }else{
                if ([weakSelf.photos[page] asset] == nil) {
                    thumbImage = [weakSelf.photos[page] thumbImage];
                }else{
                    thumbImage = [weakSelf.photos[page] photoImage];
                }
            }
            
            ZLPhotoPickerBrowserPhoto *photo = weakSelf.photos[page];
            if (thumbImage == nil) {
                imageView.image = [(UIImageView *)[photo toView] image];
                thumbImage = imageView.image;
            }else{
                imageView.image = thumbImage;
            }
            
            if (imageView.image == nil) {
                UICollectionViewCell *cell = [weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]];
                ZLPhotoPickerBrowserPhotoScrollView *scrollView = (ZLPhotoPickerBrowserPhotoScrollView *)[cell viewWithTag:101];
                if ([scrollView isKindOfClass:[ZLPhotoPickerBrowserPhotoScrollView class]] && scrollView != nil) {
                    imageView.image = scrollView.photoImageView.image;
                }
            }
            
            CGRect ivFrame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImage:thumbImage];
            if (!CGRectEqualToRect(ivFrame, CGRectZero)) {
                imageView.frame = ivFrame;
            }
            UIImageView *toImageView2 = nil;
            if ([weakSelf isDataSourceElsePhotos]) {
                toImageView2 = (UIImageView *)[[weakSelf.dataSource photoBrowser:weakSelf photoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]] toView];
            }else{
                toImageView2 = (UIImageView *)[weakSelf.photos[page] toView];
            }
            NSLog(@"toImageView2 == %@",toImageView2);
            
            if (self.type == ZLPhotoPickerBrowserViewControllerTypePhotoList) {
                originalFrame = [toImageView2.superview convertRect:toImageView2.frame toView:[weakSelf getParsentView:toImageView2]];
            }else{
                originalFrame = [toImageView2.superview convertRect:rect(0,64,toImageView2.frame.size.width,toImageView2.frame.size.height) toView:[weakSelf getParsentView:toImageView2]];
            }
            if (CGRectIsEmpty(originalFrame)) {
                originalFrame = tempFrame;
            }
        
        }else{
            // 淡入淡出
            imageView.alpha = 0.0;
        }

        if (weakSelf.navigationHeight) {
            originalFrame.origin.y += weakSelf.navigationHeight;
        }
        
        [UIView animateWithDuration:0.35 animations:^{
            if (weakSelf.status == UIViewAnimationAnimationStatusFade){
                mainBgView.alpha = 0.0;
                mainView.alpha = 0.0;
            }else if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                weakSelf.view.alpha = 0.0;
                mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                mainBgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                imageView.frame = originalFrame;
            }
        } completion:^(BOOL finished) {
            [mainView removeFromSuperview];
            [imageView removeFromSuperview];
        }];
    };
    
    [weakSelf reloadData];
    if (imageView.image == nil) {
        weakSelf.status = UIViewAnimationAnimationStatusFade;
        mainView.hidden = YES;
    }else{
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.35 animations:^{
            if (weakSelf.status == UIViewAnimationAnimationStatusFade){
                // 淡入淡出
                mainBgView.alpha = 1.0;
                imageView.alpha = 1.0;
            }else if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                mainBgView.alpha = 1.0;
                imageView.frame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:imageView];
            }
        } completion:^(BOOL finished) {
            mainView.hidden = YES;
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupReload];
    self.view.backgroundColor = [UIColor blackColor];
//    self.view.backgroundColor = [UIColor greenColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [_firstArrowView stopPlay];
    [_secondArrowView stopPlay];
    [_thirdArrowView stopPlay];
    [_fourthArrowView stopPlay];
    [_fifthArrowView stopPlay];
    
    self.navigationController.navigationBar.alpha = 1.0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)setupReload{
    if (self.isPush) {
        [self reloadData];
        __weak typeof(self)weakSelf = self;
        __block BOOL navigationisHidden = NO;
        self.disMissBlock = ^(NSInteger page){
            if (navigationisHidden) {
                [UIView animateWithDuration:.25 animations:^{
                    weakSelf.navigationController.navigationBar.alpha = 1.0;
                }];
            }else{
                [UIView animateWithDuration:.25 animations:^{
                    weakSelf.navigationController.navigationBar.alpha = 0.0;
                }];
            }
            navigationisHidden = !navigationisHidden;
        };
    }else{
        // 初始化动画
        [self showToView];
    }
}

#pragma mark get Controller.view
- (UIView *)getParsentView:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

- (id)getParsentViewController:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return [view nextResponder];
    }
    return [self getParsentViewController:view.superview];
}


#pragma mark - reloadData
- (void)reloadData{
    if (self.currentPage <= 0){
        self.currentPage = self.currentIndexPath.item;
    }else{
        --self.currentPage;
    }
    
    if (self.currentPage >= self.photos.count) {
        self.currentPage = self.photos.count - 1;
    }
    
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    // 添加自定义View
    if ([self.delegate respondsToSelector:@selector(photoBrowserShowToolBarViewWithphotoBrowser:)]) {
        UIView *toolBarView = [self.delegate photoBrowserShowToolBarViewWithphotoBrowser:self];
        toolBarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat width = self.view.zl_width;
        CGFloat x = self.view.zl_x;
        if (toolBarView.zl_width) {
            width = toolBarView.zl_width;
        }
        if (toolBarView.zl_x) {
            x = toolBarView.zl_x;
        }
        toolBarView.frame = CGRectMake(x, self.view.zl_height - 44, width, 44);
        [self.view addSubview:toolBarView];
    }
    
    [self setPageLabelPage:self.currentPage];
    //    [self setPageControlPage:self.currentPage];
    if (self.currentPage >= 0) {
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width, self.collectionView.contentOffset.y);
        //        if (self.currentPage == self.photos.count - 1 && self.photos.count > 1) {
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(00.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width - ZLPickerColletionViewPadding, self.collectionView.contentOffset.y);
        //            });
        //        }
    }
}

- (UIColor *)randomColor{
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self isDataSourceElsePhotos]) {
        return [self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section];
    }
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    if (collectionView.isDragging) {
        cell.hidden = NO;
    }
    if (self.photos.count) {
        //        cell.backgroundColor = [UIColor clearColor];
        
        ZLPhotoPickerBrowserPhoto *photo = nil;
        
        if ([self isDataSourceElsePhotos]) {
            photo = [self.dataSource photoBrowser:self photoAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:self.currentIndexPath.section]];
        }else{
            photo = self.photos[indexPath.item];
        }
        
        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        CGRect tempF = [UIScreen mainScreen].bounds;
        
        UIView *scrollBoxView = [[UIView alloc] init];
        scrollBoxView.frame = tempF;
        scrollBoxView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:scrollBoxView];
        
        _photoPickerBrowserPhotoScrollView  =  [[ZLPhotoPickerBrowserPhotoScrollView alloc] init];
        
        _photoPickerBrowserPhotoScrollView.sheet = self.sheet;
        // 为了监听单击photoView事件
        _photoPickerBrowserPhotoScrollView.frame = tempF;
        
        _photoPickerBrowserPhotoScrollView.tag = 101;
        if (self.isPush) {
            _photoPickerBrowserPhotoScrollView.zl_y -= 32;
        }
        _photoPickerBrowserPhotoScrollView.photoScrollViewDelegate = self;
        _photoPickerBrowserPhotoScrollView.photo = photo;
        
        __weak typeof(scrollBoxView)weakScrollBoxView = scrollBoxView;
        __weak typeof(self)weakSelf = self;
        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoDidSelectView:atIndexPath:)]) {
            [[scrollBoxView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            _photoPickerBrowserPhotoScrollView.callback = ^(id obj){
                [weakSelf.delegate photoBrowser:weakSelf photoDidSelectView:weakScrollBoxView atIndexPath:indexPath];
            };
        }
        
        
       
        [scrollBoxView addSubview:_photoPickerBrowserPhotoScrollView];
        _photoPickerBrowserPhotoScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
//        ZLPhotoPickerBrowserPhotoScrollView *scrollView =  [[ZLPhotoPickerBrowserPhotoScrollView alloc] init];
//
//        scrollView.sheet = self.sheet;
//        // 为了监听单击photoView事件
//        scrollView.frame = tempF;
//        scrollView.tag = 101;
//        if (self.isPush) {
//            scrollView.zl_y -= 32;
//        }
//        scrollView.photoScrollViewDelegate = self;
//        scrollView.photo = photo;
//        
//        __weak typeof(scrollBoxView)weakScrollBoxView = scrollBoxView;
//        __weak typeof(self)weakSelf = self;
//        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoDidSelectView:atIndexPath:)]) {
//            [[scrollBoxView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            scrollView.callback = ^(id obj){
//                [weakSelf.delegate photoBrowser:weakSelf photoDidSelectView:weakScrollBoxView atIndexPath:indexPath];
//            };
//        }
//        
//      
//        NSLog(@"scrollView == %@",scrollView.photoImageView);
//        [scrollBoxView addSubview:scrollView];
//        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return cell;
}

- (NSUInteger)getRealPhotosCount{
    if ([self isDataSourceElsePhotos]) {
        return [self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section];
    }
    return self.photos.count;
}


-(void)setPageLabelPage:(NSInteger)page{
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %ld",page + 1, self.photos.count];
    [self createPhotoImageViewAndArrowView:nil indexPath:nil];
    if (self.isPush) {
        self.title = self.pageLabel.text;
    }
}

- (void)setPageControlPage:(long)page {
    self.pageControl.numberOfPages = self.photos.count;
    self.pageControl.currentPage = page;
    if (self.pageControl.numberOfPages > 1) {
        self.pageControl.hidden = NO;
    } else {
        self.pageControl.hidden = YES;
    }
    
}

#pragma mark - <UIScrollViewDelegate>
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.isNowRotation) {
//        self.isNowRotation = NO;
//        return;
//    }
//
//    CGRect tempF = self.collectionView.frame;
//    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5);
//    if (tempF.size.width < [UIScreen mainScreen].bounds.size.width){
//        tempF.size.width = [UIScreen mainScreen].bounds.size.width;
//    }
//
//
//    if ([self isDataSourceElsePhotos]) {
//        if ((currentPage < [self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section] - 1) || self.photos.count == 1) {
//            tempF.origin.x = 0;
//        }else{
//            tempF.origin.x = -ZLPickerColletionViewPadding;
//        }
//    }else{
//        if ((currentPage < self.photos.count - 1) || self.photos.count == 1) {
//            tempF.origin.x = 0;
//        }else{
//            tempF.origin.x = -ZLPickerColletionViewPadding;
//        }
//    }
//
//
//    self.collectionView.frame = tempF;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = (NSInteger)(scrollView.contentOffset.x / (scrollView.frame.size.width));
    if (currentPage == self.photos.count - 2) {
        currentPage = roundf((scrollView.contentOffset.x) / (scrollView.frame.size.width));
    }
    
    //    if (currentPage == self.photos.count - 1 && currentPage != self.currentPage && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
    //        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + ZLPickerColletionViewPadding, self.collectionView.contentOffset.y);
    //    }
    
    self.currentPage = currentPage;
    [self setPageLabelPage:currentPage];
    //    [self setPageControlPage:currentPage];
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didCurrentPage:)]) {
        [self.delegate photoBrowser:self didCurrentPage:self.currentPage];
    }
}

#pragma mark - 展示控制器
- (void)showPickerVc:(UIViewController *)vc{
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        if (([vc isKindOfClass:[UITableViewController class]] || [vc isKindOfClass:[UICollectionView class]]) && weakVc.navigationController != nil) {
            self.navigationHeight = CGRectGetMaxY(weakVc.navigationController.navigationBar.frame);
        }
        [weakVc presentViewController:self animated:NO completion:nil];
    }
}

- (void)showPushPickerVc:(UIViewController *)vc{
    self.isPush = YES;
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        if (([vc isKindOfClass:[UITableViewController class]] || [vc isKindOfClass:[UICollectionView class]]) && weakVc.navigationController != nil) {
            self.navigationHeight = CGRectGetMaxY(weakVc.navigationController.navigationBar.frame);
        }
        [weakVc.navigationController pushViewController:self animated:YES];
    }
}

#pragma mark - 删除照片
- (void)delete{
//    // 准备删除
//    if ([self.delegate respondsToSelector:@selector(photoBrowser:willRemovePhotoAtIndexPath:)]) {
//        if(![self.delegate photoBrowser:self willRemovePhotoAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:self.currentIndexPath.section]]){
//            return ;
//        }
//    }
//    
//    UIAlertView *removeAlert = [[UIAlertView alloc]
//                                initWithTitle:@"确定要删除此图片？"
//                                message:nil
//                                delegate:self
//                                cancelButtonTitle:@"取消"
//                                otherButtonTitles:@"确定", nil];
//    [removeAlert show];
}

- (BOOL)isDataSourceElsePhotos{
    return self.dataSource != nil;
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSInteger page = self.currentPage;
        if ([self.delegate respondsToSelector:@selector(photoBrowser:removePhotoAtIndexPath:)]) {
            [self.delegate photoBrowser:self removePhotoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:self.currentIndexPath.section]];
        }
        
        if (self.photos.count > self.currentPage || self.dataSource != nil) {
            NSMutableArray *photos = [NSMutableArray arrayWithArray:self.photos];
            [photos removeObjectAtIndex:self.currentPage];
            self.photos = photos;
        }
        
        if (page >= self.photos.count) {
            self.currentPage--;
        }
        
        self.status = UIViewAnimationAnimationStatusFade;
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:self.currentIndexPath.section]];
        if (cell) {
            if([[[cell.contentView subviews] lastObject] isKindOfClass:[UIView class]]){
                
                [UIView animateWithDuration:.35 animations:^{
                    [[[cell.contentView subviews] lastObject] setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [self reloadData];
                }];
            }
        }
        
        if (self.photos.count < 1)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
    }
}

#pragma mark - Rotation
- (void)changeRotationDirection:(NSNotification *)noti{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.zl_size.width + ZLPickerColletionViewPadding, self.view.zl_height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.alpha = 0.0;
    [self.collectionView setCollectionViewLayout:flowLayout animated:YES];
    self.isNowRotation = YES;
    
    self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width, self.collectionView.contentOffset.y);
    
    UICollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0]];
    for (UICollectionViewCell *cell in [self.collectionView subviews]) {
        if ([cell isKindOfClass:[UICollectionViewCell class]]) {
            cell.hidden = ![cell isEqual:currentCell];
            ZLPhotoPickerBrowserPhotoScrollView *scrollView = (ZLPhotoPickerBrowserPhotoScrollView *)[cell.contentView viewWithTag:101];
            [scrollView setMaxMinZoomScalesForCurrentBounds];
        }
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self.collectionView.alpha = 1.0;
    }];
}

#pragma mark - <PickerPhotoScrollViewDelegate>
- (void)pickerPhotoScrollViewDidSingleClick:(ZLPhotoPickerBrowserPhotoScrollView *)photoScrollView{
    if (self.disMissBlock) {
        if (self.photos.count == 1) {
            self.currentPage = 0;
        }
        self.disMissBlock(self.currentPage);
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showHeadPortrait:(UIImageView *)toImageView{
    
}

- (void)showHeadPortrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl{
    
}
@end