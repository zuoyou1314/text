//
//  MOKOPictureBrowsingViewController.m
//  MOKODreamWork_iOS2
//
//  Created by _SS on 15/7/22.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import "MOKOPictureBrowsingViewController.h"
#import "MOKOPictureBrowsingCollectionViewCell.h"
#import "MOKOPictureBrowsingCollectionViewFlowLayout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "MZResetAlbumImg.h"
#import "MZRequestManger+User.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface MOKOPictureBrowsingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,MZShareViewDelegate>
/**
 *  多张图片滑动的collectionView
 */
@property (nonatomic, strong) UICollectionView *imagesCollectionView;
/**
 *  翻页
 */
//@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *pageLabel;

/**
 *  长按图片的url
 */
@property (nonatomic, strong) NSString *longPressImageUrl;
@end

@implementation MOKOPictureBrowsingViewController

- (instancetype)initWithHidden:(BOOL)hidden
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.isHidden = hidden;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor orangeColor];
//    self.imagesArray = @[@"imageHolder",@"movieHolder",@"imageHolder"];
    [self.view addSubview:self.imagesCollectionView];
//    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.pageLabel];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.downloadButton];
    [self.view addSubview:self.coverButton];
    [self.view addSubview:self.goodButton];
    [self.view addSubview:self.commentButton];
    [self pictureBrowsingViewControllerEventResponse];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.imagesCollectionView.frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.imagesCollectionView.center = self.view.center;
//    self.pageControl.frame = CGRectMake(0.f, SCREEN_HEIGHT - 40.f, SCREEN_WIDTH, 40.f);
//    self.pageControl.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 40.f);
    self.backView.frame = rect(0.0f, 0.0f, SCREEN_WIDTH, 64.0f);
    self.pageLabel.frame = rect(0.0f, 20.0f, SCREEN_WIDTH, 44.0f);
    if (iPhone6) {
        self.shareButton.frame = rect(15.0f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
        if (self.albumType == MOKOPictureBrowsingViewControllerTypePublicAlbum) {
             self.downloadButton.frame = rect(SCREEN_WIDTH-95, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
        }else{
            self.downloadButton.frame = rect(self.shareButton.frame.origin.x + self.shareButton.frame.size.width + 37.5f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
            self.coverButton.frame = rect(self.downloadButton.frame.origin.x + self.downloadButton.frame.size.width + 37.5f, SCREEN_HEIGHT-51.0f, 109.0f, 38.0f);
        }
    }else if (iPhone6P){
        self.shareButton.frame = rect(15.0f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
        if (self.albumType == MOKOPictureBrowsingViewControllerTypePublicAlbum) {
            self.downloadButton.frame = rect(SCREEN_WIDTH-95, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
        }else{
            self.downloadButton.frame = rect(self.shareButton.frame.origin.x + self.shareButton.frame.size.width + 57.5f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
            self.coverButton.frame = rect(self.downloadButton.frame.origin.x + self.downloadButton.frame.size.width + 57.5f, SCREEN_HEIGHT-51.0f, 109.0f, 38.0f);
        }
    }else{
        self.shareButton.frame = rect(10.0f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
        if (self.albumType == MOKOPictureBrowsingViewControllerTypePublicAlbum) {
            self.downloadButton.frame = rect(SCREEN_WIDTH-90, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
        }else{
            self.downloadButton.frame = rect(self.shareButton.frame.origin.x + self.shareButton.frame.size.width + 17.5f, SCREEN_HEIGHT-51.0f, 80.0f, 38.0f);
            self.coverButton.frame = rect(self.downloadButton.frame.origin.x + self.downloadButton.frame.size.width + 17.5f, SCREEN_HEIGHT-51.0f, 109.0f, 38.0f);
        }
        
    }
    self.goodButton.frame = rect(SCREEN_WIDTH/2, 20, SCREEN_WIDTH/4 ,44.0f);
    self.commentButton.frame = rect(SCREEN_WIDTH/4+SCREEN_WIDTH/2-10.0f, 20, SCREEN_WIDTH/4 ,44.0f);
   
    

}

#pragma mark -- Private Method

#pragma mark -- Event Response
- (void)pictureBrowsingViewControllerEventResponse{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissviewController:)];
    [self.view addGestureRecognizer:tap];

}
- (void)dissmissviewController:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
/**
 *  保存图片
 */
- (void)saveImage{
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.longPressImageUrl]];
//    UIImage *image = [UIImage imageWithData:data];
    UIImage *image = [UIImage imageNamed:@"imageHolder"];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error != NULL) {
        UIAlertView *photoSave = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [photoSave show];
        [photoSave dismissWithClickedButtonIndex:0 animated:YES];
    }else {
        UIAlertView *photoSave = [[UIAlertView alloc] initWithTitle:@"\n保存成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [photoSave show];
        [photoSave dismissWithClickedButtonIndex:0 animated:YES];
    }
}
/**
 *  举报这条动态
 */
- (void)reportTheDynamic{
    NSLog(@"举报这条动态");
//    MOKOComplainViewController *complainViewController=[[MOKOComplainViewController alloc] init];
//    complainViewController.type = MOKOComplainTypePictureBrowsing;
////    complainViewController.touserid = _dreamShowModel.girlid;
////    complainViewController.indexid = _dreamShowModel.indexid;
//    [self presentViewController:complainViewController animated:NO completion:nil];
    
}
/**
 *  分享这条动态
 */
- (void)shareTheDynamic{
//    MOKOShareViewController *shareVC = [[MOKOShareViewController alloc]init];
//    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:shareVC animated:NO completion:nil];
}


#pragma mark -- Private Method
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
            
            NSArray *array = [[_imgeurlArray objectAtIndex: [[_pageLabel.text substringToIndex:1] integerValue]-1] componentsSeparatedByString:@"t_"];
            
            [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[array objectAtIndex:0],[array objectAtIndex:1]]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
            resetAlbumImg.img_url = [_imgeurlArray objectAtIndex: [[_pageLabel.text substringToIndex:1] integerValue]-1];
            resetAlbumImg.user_id = [userdefaultsDefine objectForKey:@"user_id"];
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
    //分隔字符串,组成新的字符串
    NSArray *array = [[_imgeurlArray objectAtIndex: [[_pageLabel.text substringToIndex:1] integerValue]-1] componentsSeparatedByString:@"t_"];
    [sharImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[array objectAtIndex:0],[array objectAtIndex:1]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
        [socialControllerService setShareText:@"和你的朋友一起玩的相册" shareImage:UIImagePNGRepresentation(sharImage.image) socialUIDelegate:nil];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:name].snsClickHandler(weakSelf,socialControllerService,YES);
    }];
}

- (void)clickWechatFriendButtonAction
{
    [self shareImageWithSocialPlatformWithName:UMShareToWechatTimeline];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-  (void)showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存",@"举报",@"分享", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -- Getter and Setter

- (void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
}



- (UICollectionView *)imagesCollectionView{
    if (_imagesCollectionView != nil) {
        return _imagesCollectionView;
    }
    MOKOPictureBrowsingCollectionViewFlowLayout *viewLayout = [[MOKOPictureBrowsingCollectionViewFlowLayout alloc] init];
    viewLayout.offsetpoint = CGPointMake(SCREEN_WIDTH *_indexNumber, 0.f);
    _imagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:viewLayout];
    _imagesCollectionView.showsHorizontalScrollIndicator = FALSE; // 去掉滚动条
//    _imagesCollectionView.backgroundColor = [UIColor yellowColor];
    _imagesCollectionView.pagingEnabled = YES;
    _imagesCollectionView.delegate = self;
    _imagesCollectionView.dataSource = self;
    [_imagesCollectionView registerClass:[MOKOPictureBrowsingCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    return _imagesCollectionView;
}

//- (UIPageControl *)pageControl{
//    if (_pageControl != nil) {
//        return _pageControl;
//    }
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
//    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    _pageControl.numberOfPages = self.imagesArray.count;
//    _pageControl.enabled = NO;
//    return _pageControl;
//}

//- (void)setImgeurlArray:(NSArray *)imgeurlArray
//{
//    _imgeurlArray = imgeurlArray;
//}

- (void)setImagesArray:(NSArray *)imagesArray
{
    _imagesArray = imagesArray;
}



- (UILabel *)pageLabel
{
    if (_pageLabel != nil) {
        return _pageLabel;
    }
    
    _pageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.textColor = [UIColor whiteColor];
    if (_imagesArray.count > 0) {
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)_indexNumber+1,(unsigned long)_imagesArray.count];
    }else{
        
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)_indexNumber+1,(unsigned long)_imgeurlArray.count];
    }
   
    return _pageLabel;
}

- (UIView *)backView
{
    if (_backView != nil) {
        return _backView;
    }
    _backView = [[UIView alloc]initWithFrame:CGRectZero];
    _backView.backgroundColor = RGBA(0, 0, 0, 0.7);
    return _backView;
}


- (UIButton *)shareButton
{
    if (_shareButton != nil) {
        return _shareButton;
    }
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectZero;
    _shareButton.tag = 40000;
    [_shareButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    _shareButton.layer.borderColor = [[UIColor colorWithRed:94/255.0f green:94/255.0f blue:94/255.0f alpha:1.0f]CGColor];
    _shareButton.layer.borderWidth= 0.5f;
    _shareButton.layer.cornerRadius = 8;
    _shareButton.layer.masksToBounds = YES;
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _shareButton.backgroundColor = RGBA(0, 0, 0, 0.4);
    if (_imagesArray.count>0) {
        _shareButton.hidden = YES;
    }
    return _shareButton;
}

- (UIButton *)downloadButton
{
    if (_downloadButton != nil) {
        return _downloadButton;
    }
    _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadButton.frame = CGRectZero;
    _downloadButton.tag = 40001;
    [_downloadButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    _downloadButton.layer.borderColor = [[UIColor colorWithRed:94/255.0f green:94/255.0f blue:94/255.0f alpha:1.0f]CGColor];
    _downloadButton.layer.borderWidth= 0.5f;
    _downloadButton.layer.cornerRadius = 8;
    _downloadButton.layer.masksToBounds = YES;
    _downloadButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _downloadButton.backgroundColor = RGBA(0, 0, 0, 0.4);
    if (_imagesArray.count>0) {
        _downloadButton.hidden = YES;
    }
    return _downloadButton;
}

- (UIButton *)coverButton
{
    if (_coverButton != nil) {
        return _coverButton;
    }
    _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverButton.frame = CGRectZero;
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
    if (_imagesArray.count>0) {
        _coverButton.hidden = YES;
    }
    return _coverButton;
}

- (UIButton *)goodButton
{
    if (_goodButton != nil) {
        return _goodButton;
    }
    _goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goodButton.frame = CGRectZero;
    [_goodButton setImage:[UIImage  imageNamed:@"main_love"] forState:UIControlStateNormal];
    [_goodButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:146.0f/255.0f blue:146.0f/255.0f alpha:1.0f ] forState:UIControlStateNormal];
    _goodButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _goodButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    MZPhotoListsModel *photoListsModel = [_modelArray objectAtIndex:_indexNumber];
    [_goodButton setTitle:[NSString stringWithFormat:@" %ld",(long)photoListsModel.goods] forState:UIControlStateNormal];
    [_goodButton addTarget:self action:@selector(didClickGoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _goodButton.tag = [photoListsModel.issue_id integerValue];
    if (self.isHidden == YES) {
        _goodButton.hidden = YES;
    }
    return _goodButton;
}


- (UIButton *)commentButton
{
    if (_commentButton != nil) {
        return _commentButton;
    }
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectZero;
    _commentButton.tag = 40004;
    [_commentButton setImage:[UIImage  imageNamed:@"main_comment"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:146.0f/255.0f blue:146.0f/255.0f alpha:1.0f ] forState:UIControlStateNormal];
    _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    MZPhotoListsModel *photoListsModel = [_modelArray objectAtIndex:_indexNumber];
    [_commentButton setTitle:[NSString stringWithFormat:@" %ld",(long)photoListsModel.comments] forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(didClickGoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _commentButton.tag = [photoListsModel.issue_id integerValue];
    if (self.isHidden == YES) {
        _commentButton.hidden = YES;
    }
    return _commentButton;
}


#pragma mark - UICollectionViewDelegate And UICollectionViewDataSource
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0.f, 1.f, 0.f, 0.f);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_imagesArray.count >0) {
        return _imagesArray.count;
    }else{
        return _imgeurlArray.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString * identifier = @"CollectionCell";
    MOKOPictureBrowsingCollectionViewCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier: identifier forIndexPath:indexPath];
//    collectionCell.backgroundColor = [UIColor redColor];
//    collectionCell.longPressImageBlock = ^{
//        self.longPressImageUrl = [self.imagesArray objectAtIndex:indexPath.section];
//        [self showActionSheet];
//    };

    if (_imagesArray.count >0) {
        ALAsset *asset = [_imagesArray objectAtIndex:indexPath.section];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                             scale:asset.defaultRepresentation.scale
                                       orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        [collectionCell setImage:image];
    }else{
        collectionCell.imageurl = [_imgeurlArray objectAtIndex:indexPath.section];
//        collectionCell.photoId = _issue_id;
        collectionCell.album_id = _album_id;
        collectionCell.indexNumber = indexPath.section+1;
    }
    return collectionCell;
}

# pragma mark - UIctionSheetction
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self saveImage];
            break;
        case 1:
            [self reportTheDynamic];
            break;
        case 2:
            [self shareTheDynamic];
            break;
    }
    
}
#pragma mark - call back
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
//    self.pageControl.currentPage = page;
    if (_imagesArray.count >0) {
        _pageLabel.text = [NSString stringWithFormat:@"%lu/%ld",page+1,(unsigned long)_imagesArray.count];
    }else{
        _pageLabel.text = [NSString stringWithFormat:@"%lu/%ld",page+1,(unsigned long)_imgeurlArray.count];
        
        MZPhotoListsModel *photoListsModel = [_modelArray objectAtIndex:page];
        [_goodButton setTitle:[NSString stringWithFormat:@" %ld",(long)photoListsModel.goods] forState:UIControlStateNormal];
        _goodButton.tag = [photoListsModel.issue_id integerValue];
        [_commentButton setTitle:[NSString stringWithFormat:@" %ld",(long)photoListsModel.comments] forState:UIControlStateNormal];
        _commentButton.tag = [photoListsModel.issue_id integerValue];

    }
   
}

- (void)didClickGoodButtonAction:(UIButton *)button
{
    if (_delegate&&[_delegate respondsToSelector:@selector(clickGoodButtonAction:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
              [_delegate clickGoodButtonAction:button];
        }];
    }
}



@end
