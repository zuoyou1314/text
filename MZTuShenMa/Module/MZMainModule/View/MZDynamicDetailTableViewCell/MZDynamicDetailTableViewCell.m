//
//  MZDynamicDetailTableViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/20.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDynamicDetailTableViewCell.h"
#import "MZPhotoListViewController.h"
#import "UIImageView+WebCache.h"
#import "MOKOPictureBrowsingViewController.h"
#import "MZPhotoPickerBrowserModel.h"
#import "MZListsModel.h"
#import "MZSpeechListsModel.h"
//#import "UIButton+MZRepeatClickButton.h"
@interface MZDynamicDetailTableViewCell ()
{
    BOOL _eventUserAvatar;
}

/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/**
 *  用户名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  分割线
 */
@property (nonatomic, strong) MZSegmentLine *segmentLineView;
/**
 *  点赞按钮
 */
@property (nonatomic, weak) UIButton *loveButton;
///**
// *  评论按钮
// */
//@property (nonatomic, weak) UIButton *commentButton;
/**
 *  分享按钮
 */
@property (nonatomic, weak) UIButton *shareButton;
/**
 *  更多按钮
 */
@property (nonatomic, weak) UIButton *moreButton;


@end

@implementation MZDynamicDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _headImage.layer.cornerRadius = CGRectGetHeight([_headImage bounds])/2;
    _headImage.layer.masksToBounds = YES;
    _headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHeadImageAction)];
    [_headImage addGestureRecognizer:tap];
    
    _coverCollectionView = [[MZCoverCollectionView alloc] initWithFrame:rect(0,_headImage.frame.origin.y + _headImage.frame.size.height,SCREEN_WIDTH-30.0f,SCREEN_WIDTH-30.0f)];
    _coverCollectionView.backgroundColor = [UIColor clearColor];
    _coverCollectionView.delegate = self;
    [self addSubview:_coverCollectionView];
    
    //分割线的宽度
    CGFloat segmentLineOfWidth = SCREEN_WIDTH-30.0f;
    //分割线的X值
    CGFloat segmentLineOfX = 15.0f;
    //分割线的高度
    CGFloat segmentLineOfHeight = 30.0f;
    
    _segmentLineView = [[MZSegmentLine alloc]initWithFrame:CGRectMake(segmentLineOfX, _coverCollectionView.frame.origin.y + _coverCollectionView.frame.size.height, segmentLineOfWidth, segmentLineOfHeight)];
    [self addSubview:_segmentLineView];
    
    //button的Y
    CGFloat buttonOfY = _segmentLineView.frame.origin.y;
    
    
    UIButton *lovebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    lovebutton.frame = rect(segmentLineOfX, buttonOfY, segmentLineOfWidth/4, segmentLineOfHeight);
    [lovebutton setImage:[UIImage  imageNamed:@"main_love"] forState:UIControlStateNormal];
    [lovebutton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [lovebutton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:146.0f/255.0f blue:146.0f/255.0f alpha:1.0f ] forState:UIControlStateNormal];
    [lovebutton setTitle:@"45" forState:UIControlStateNormal];
    lovebutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    lovebutton.tag = 10000;
//    lovebutton.uxy_acceptEventInterval = 0.2f;
    [self addSubview:lovebutton];
    _loveButton = lovebutton;

    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(segmentLineOfX + segmentLineOfWidth/2, buttonOfY, segmentLineOfWidth/4, segmentLineOfHeight);
    [shareButton setImage:[UIImage imageNamed:@"main_share"] forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:146.0f/255.0f blue:146.0f/255.0f alpha:1.0f ] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.tag = 10002;
    [self addSubview:shareButton];
    _shareButton = shareButton;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(segmentLineOfX + segmentLineOfWidth/2 + segmentLineOfWidth/4, buttonOfY, segmentLineOfWidth/4, segmentLineOfHeight);
    [moreButton setImage:[UIImage imageNamed:@"main_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = 10003;
    [self addSubview:moreButton];
    _moreButton = moreButton;

}

- (void)buttonDidClicked:(UIButton *)button
{
        NSLog(@"照片详情");
        if (_delegate && [_delegate respondsToSelector:@selector(didClickPhotoDetailButtonWithTag:photoId:userId:detailPhotoModel:row:path_img:)]) {
            MZListsModel *listsModel = [_detailModel.lists objectAtIndex:0];
            [_delegate didClickPhotoDetailButtonWithTag:button.tag photoId:_detailModel.issue_id userId:_detailModel.issue_user_id detailPhotoModel:_detailPhotoModel row:_row path_img:listsModel.path_img];
        }
}



#pragma mark --MZCoverCollectionViewDelegate--
//点击封面浏览图片
- (void)didClickItemActionWithIndex:(NSUInteger)index photos:(NSMutableArray *)photos
{
    //图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 数据源/delegate
    //    pickerBrowser.delegate = self;
    
    pickerBrowser.type = ZLPhotoPickerBrowserViewControllerTypePhotoDetail;
    if (self.albumType == MZDynamicDetailTableViewCellTypePublicAlbum) {
         pickerBrowser.albumType = ZLPhotoPickerBrowserViewTypePublicAlbum;
    }else{
        pickerBrowser.albumType = ZLPhotoPickerBrowserViewTypeNormal;
    }
    
    // 数据源可以不传，传photos数组 photos<里面是ZLPhotoPickerBrowserPhoto>
    pickerBrowser.photos = photos;
    // 是否可以删除照片
    pickerBrowser.editing = YES;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    pickerBrowser.album_id = _album_id;
    [pickerBrowser.goodButton setTitle:[NSString stringWithFormat:@"  %ld",_detailPhotoModel.goodNum] forState:UIControlStateNormal];
    [pickerBrowser.commentButton setTitle:[NSString stringWithFormat:@"  %ld",_detailPhotoModel.commentNums] forState:UIControlStateNormal];
//    pickerBrowser.goodButton.hidden = YES;
//    pickerBrowser.commentButton.hidden = YES;
    // 展示控制器
    [pickerBrowser showPickerVc:[self viewController]];
}


- (void)didClickItemActionWithIndex:(NSUInteger)index
{
//    MOKOPictureBrowsingViewController *pictureBrowsingViewController = [[MOKOPictureBrowsingViewController alloc] initWithHidden:YES];
//    pictureBrowsingViewController.indexNumber = index;
//    pictureBrowsingViewController.imgeurlArray =_detailModel.img_lists;
//    pictureBrowsingViewController.photoId = _detailModel.photoDetailId;
//    pictureBrowsingViewController.album_id = _album_id;
//    [[self viewController] presentViewController:pictureBrowsingViewController animated:YES completion:^{}];
}


- (void)setRow:(NSUInteger)row
{
    _row = row;
}

/**
 *  点击头像的响应方法
 */
- (void)didClickHeadImageAction
{
    NSLog(@"跳转相册");
    [[BaiduMobStat defaultStat] logEvent:@"userAvatar" eventLabel:@"所有-用户头像"];
    if(!_eventUserAvatar) {
        _eventUserAvatar = YES;
        [[BaiduMobStat defaultStat] eventStart:@"userAvatar" eventLabel:@"所有-用户头像"];
    } else {
        _eventUserAvatar = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"userAvatar" eventLabel:@"所有-用户头像"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"albumInfo" eventLabel:@"所有-用户头像" durationTime:1000];
    MZPhotoListViewController *photoListVC = [[MZPhotoListViewController alloc]init];
    photoListVC.album_memId = _detailModel.issue_user_id;
    photoListVC.album_id = _detailModel.album_id;
    photoListVC.album_name = _album_name;
    photoListVC.uname = _detailModel.uname;
    if (self.albumType == MZDynamicDetailTableViewCellTypePublicAlbum) {
        photoListVC.albumType = MZPhotoListViewControllerTypePublicAlbum;
    }else{
        photoListVC.albumType = MZPhotoListViewControllerTypeNormal;
    }
    [[self viewController].navigationController pushViewController:photoListVC animated:YES];
}


//找任意view所在控制器的方法
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (void)setDetailModel:(MZMainPhotoDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    if (detailModel.lists.count == 1) {
        _coverCollectionView.frame = rect(0,_headImage.frame.origin.y + _headImage.frame.size.height+5.0f+5.0f,SCREEN_WIDTH-30.0f,SCREEN_WIDTH-30.0f);
    }else if (detailModel.lists.count == 2){
        _coverCollectionView.frame = rect(0,_headImage.frame.origin.y + _headImage.frame.size.height + 5.0f+5.0f,SCREEN_WIDTH-30.0f,(SCREEN_WIDTH-30.0f)/2);
    }else if (detailModel.lists.count == 3){
        _coverCollectionView.frame = rect(0,_headImage.frame.origin.y + _headImage.frame.size.height + 5.0f+5.0f,SCREEN_WIDTH-30.0f,(SCREEN_WIDTH-30.0f)/3);
    }else if (detailModel.lists.count == 4){
        _coverCollectionView.frame = rect(0,_headImage.frame.origin.y + _headImage.frame.size.height + 5.0f+5.0f,SCREEN_WIDTH-30.0f,SCREEN_WIDTH-30.0f);
    }else if (detailModel.lists.count > 4 && detailModel.lists.count < 7){
        _coverCollectionView.frame = rect(0,_headImage.frame.origin.y + _headImage.frame.size.height + 5.0f+5.0f,SCREEN_WIDTH-30.0f,((SCREEN_WIDTH-30.0f)/3)*2);
    }else{
//        _coverCollectionView.frame = rect(0,_headImage.frame.origin.y + _headImage.frame.size.height + 5.0f+5.0f,SCREEN_WIDTH-30.0f,SCREEN_WIDTH-30.0f);
        if (detailModel.lists.count%3>0) {
            _coverCollectionView.frame = rect(0,_headImage.frame.origin.y + _headImage.frame.size.height + 5.0f+5.0f,SCREEN_WIDTH-30.0f,((SCREEN_WIDTH-30.0f)/3)*(detailModel.lists.count/3+1));
        }else{
            _coverCollectionView.frame = rect(0,_headImage.frame.origin.y + _headImage.frame.size.height + 5.0f+5.0f,SCREEN_WIDTH-30.0f,((SCREEN_WIDTH-30.0f)/3)*(detailModel.lists.count/3));
        }

    }
    _coverCollectionView.detailModel = detailModel;
    
    _segmentLineView.rightLineView.hidden = YES;
    _segmentLineView.frame = rect(0, _coverCollectionView.frame.origin.y + _coverCollectionView.frame.size.height+10.0f, SCREEN_WIDTH-30.0f, 30.0f);
    _loveButton.frame = rect(0, _segmentLineView.frame.origin.y, (SCREEN_WIDTH-30.0f)/4, 30.0f);
    _shareButton.frame = rect((SCREEN_WIDTH-30.0f)/4, _segmentLineView.frame.origin.y, (SCREEN_WIDTH-30.0f)/4, 30.0f);
    _moreButton.frame = rect((SCREEN_WIDTH-30.0f)/2 + (SCREEN_WIDTH-30.0f)/4 , _segmentLineView.frame.origin.y, (SCREEN_WIDTH-30.0f)/4, 30.0f);
    
    NSMutableArray *photos = [[NSMutableArray alloc]initWithCapacity:9];
    for (int i= 0;i< _detailModel.lists.count; i++) {
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc]init];
        
        
        MZListsModel *listsModel = [_detailModel.lists objectAtIndex:i];
        photo.photoURL = [NSURL URLWithString:listsModel.path_img];
        
        photo.speechMarkModel = [NSMutableArray arrayWithCapacity:listsModel.speechLists.count];
        for (int i = 0; i<listsModel.speechLists.count ; i++) {
            MZSpeechListsModel *speechListModel = [listsModel.speechLists objectAtIndex:i];
            MZPhotoPickerBrowserModel *speechMarkModel = [[MZPhotoPickerBrowserModel alloc]init];
            speechMarkModel.coords_x = speechListModel.coords_x;
            speechMarkModel.coords_y = speechListModel.coords_y;
            speechMarkModel.speech_path = speechListModel.speech_path;
            speechMarkModel.track = speechListModel.track;
            [photo.speechMarkModel addObject:speechMarkModel];//把音频model放到
        }

        
//        NSDictionary *dict = [_detailModel.lists objectAtIndex:i];
//        photo.photoURL = [NSURL URLWithString:[dict objectForKey:@"path_img"]];
        
//        if (_detailModel.have_speech.count > 0) {
//            NSDictionary *dic = [_detailModel.have_speech objectAtIndex:i];
//            NSArray *coords = [dic objectForKey:@"coords"];
//            photo.speechMarkModel = [NSMutableArray arrayWithCapacity:coords.count];
//            for (int i = 0; i < coords.count ; i++) {
//                MZPhotoPickerBrowserModel *speechMarkModel = [[MZPhotoPickerBrowserModel alloc]init];
//                NSDictionary *speechMarkDic = [coords objectAtIndex:i];
//                speechMarkModel.coords_x = [speechMarkDic objectForKey:@"coords_x"];
//                speechMarkModel.coords_y = [speechMarkDic objectForKey:@"coords_y"];
//                speechMarkModel.speech_path = [speechMarkDic objectForKey:@"speech_path"];
//                speechMarkModel.track = [speechMarkDic objectForKey:@"track"];
//                [photo.speechMarkModel addObject:speechMarkModel];//把音频model放到照片model里面
//            }
//        }
        [photos addObject:photo];
    }
    _coverCollectionView.imageArray = photos;
    

    [_headImage sd_setImageWithURL:[NSURL URLWithString:detailModel.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
    _nameLabel.text = detailModel.uname;
    NSTimeInterval time=[detailModel.time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    _timeLabel.text = currentDateStr;
    
}




- (void)setDetailPhotoModel:(MZModel *)detailPhotoModel
{
    _detailPhotoModel = detailPhotoModel;
    if (detailPhotoModel.is_good == 0) {
        [_loveButton setImage:[UIImage  imageNamed:@"main_love"] forState:UIControlStateNormal];
    }else{
        [_loveButton setImage:[UIImage imageNamed:@"Main_alreadyLove"] forState:UIControlStateNormal];
        
    }
    [_loveButton setTitle:[NSString stringWithFormat:@"  %ld",detailPhotoModel.goodNum] forState:UIControlStateNormal];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
