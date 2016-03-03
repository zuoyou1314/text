//
//  MZDynamicListViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDynamicListViewController.h"
#import "DynamicListTableViewCell.h"

#import "MZDynamicDetailViewController.h"

#import "MZPhotoAlbumDetailViewController.h"
#import "MZHomeFootAnimationButton.h"
#import "MZMessageViewController.h"

#import "MZDynamicListParam.h"
#import "MZDynamicListModel.h"
#import "MZPhotoGoodParam.h"
#import "MZModel.h"
#import "MZNewIsHaveParam.h"
#import "MZDoUploadParam.h"
#import "MJRefresh.h"
#import "MZShareView.h"
#import "MZMoreView.h"
#import "SDWebImageManager.h"
#import "MZResetAlbumImg.h"
#import "MZPhoneDelParam.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UIImageView+WebCache.h"
#import "MZNewMessageButton.h"



#import "MZGoodsCommentsParam.h"
#import "MZCreatePhotoView.h"

#import "MZPhotoIssueParam.h"
#import "MZImageListsModel.h"
#import "MZPublishViewController.h"
#import "MZShareParam.h"

#import "MZOneMoreView.h"
#import "MJChiBaoZiHeader.h"

#import "MZDynamicViewController.h"
#import "MZRecordingViewController.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"
#import "MZMakeMovieViewController.h"
#import "MZListsModel.h"


@interface MZDynamicListViewController ()<UITableViewDelegate,UITableViewDataSource,MZHomeFootAnimationButtonDelegate,MZDynamicListDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MZMoreViewDelegate,MZShareViewDelegate,MZNewMessageButtonDelegate,MZOneMoreViewDelegate,ZLPhotoPickerViewControllerDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_modelArray;
//    NSMutableArray *_imageArray;
    NSInteger _page;
    UIImage *_image;
    NSString *_filePath;                 // 沙盒中图片的完整路径
    NSString *_path_img;
    NSString *_issue_id;     //发布id
    NSString *_photoListOfTheUserId;     //照片列表的用户iD
    NSUInteger _row;
    NSString * _uname; //用户昵称
    BOOL _isDetail;
    
    BOOL _eventAlbumInfo;
    BOOL _eventNewMessages;
    BOOL _eventPhoto;
    BOOL _eventShare;
    BOOL _eventWechatShare;
    BOOL _eventMomentsShare;
    BOOL _eventMore;
    
    NSUInteger _lastPosition;//检测TableView的滚动方向
    UIImage *_tmpImage;  //发布图片
    UIButton *_addButton;//发布按钮
}

@end

@implementation MZDynamicListViewController

#pragma mark -- Life Cycle

static NSString * const dynamicListCellIdentifier = @"dynamicCell";
static NSString * const photoListCellIdentifier = @"photoListCell";


- (instancetype)initWithAlbum_id:(NSString *)album_id album_name:(NSString *)album_name
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.album_id = album_id;
        self.album_name = album_name;
//        self.dynamicStatusType =dynamicStatusType;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
    if (_modelArray.count >0 && _isDetail == YES && [userdefaultsDefine objectForKey:@"row"]) {
        MZDynamicListModel *dataModel = [_modelArray objectAtIndex:[[userdefaultsDefine objectForKey:@"row"]integerValue]];
        __weak typeof(self) weakSelf = self;
        MZGoodsCommentsParam *goodsCommentsParam = [[MZGoodsCommentsParam alloc]init];
        goodsCommentsParam.issue_id =dataModel.issue_id;
        goodsCommentsParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
        [self showHoldView];
        [MZRequestManger goodsCommentsRequest:goodsCommentsParam success:^(NSDictionary *object) {
            [weakSelf hideHUD];
            dataModel.goods= [[object objectForKey:@"goods"]integerValue];
            dataModel.comments = [[object objectForKey:@"comments"]integerValue];
            dataModel.is_good = [[object objectForKey:@"is_good"]integerValue];
            [_tableView reloadData];
        } failure:^(NSString *errMsg, NSString *errCode) {
            [weakSelf hideHUD];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isDetail = NO;
    [self initUI];
//    [self createMessageViewforHidden:NO];
}

- (void)initUI
{
//    self.view.backgroundColor = RGB(244, 244, 244);
//     self.view.backgroundColor = [UIColor orangeColor];
    
//    UIImageView *backImage = [[UIImageView alloc]initWithFrame:rect(0.0f,SCREEN_HEIGHT-72.0f-64.0f,SCREEN_WIDTH,72.0f)];
//    backImage.image = [UIImage imageNamed:@"mian_ back"];
//    [self.view addSubview:backImage];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40+64, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = RGB(244, 244, 244);
    [self.view addSubview:_tableView];
    
    
//    UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:rect(0.0f,SCREEN_HEIGHT-72.0f-64.0f,SCREEN_WIDTH,72.0f)];
//    bottomImage.image = [UIImage imageNamed:@"main_bottom"];
//    [self.view addSubview:bottomImage];
    
    //注册标识
    [_tableView registerNib:[UINib nibWithNibName:@"DynamicListTableViewCell" bundle:nil] forCellReuseIdentifier:dynamicListCellIdentifier];
    
    //添加底下悬浮Button
    _addButton = [UIButton createButtonWithNormalImage:@"footAdd@2x" highlitedImage:nil target:self action:@selector(didClickAddButtonAction)];
    _tmpImage = [UIImage imageNamed:@"footAdd"];
    [_addButton setBounds:CGRectMake(0, 0, _tmpImage.size.width, _tmpImage.size.height)];
    [_addButton setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 20 - _tmpImage.size.height/2)];
    [self.view addSubview:_addButton];
    
    
    __weak __typeof(self) weakSelf = self;
    _page =1;
    // 下拉刷新
    _tableView.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
         _page =1;
        [weakSelf initDataWithPage:_page];
    }];
    // 马上进入刷新状态
    [_tableView.header beginRefreshing];
    // 上拉加载更多
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         _page++;
        [weakSelf initDataWithPage: _page];
    }];
}

//创建悬浮的消息按钮
//- (void)createMessageViewforHidden:(BOOL)hidden
//{
//    MZNewMessageButton *messageButton = [[MZNewMessageButton alloc]init];
//    messageButton.frame = rect(100, 100, 100, 100);
//    messageButton.delegate = self;
//    [messageButton show];
//    messageButton.hidden = hidden;
//    [self.view addSubview:messageButton];
//}

#pragma mark -----MZNewMessageButtonDelegate
- (void)newMessageButtonTouchUpInside:(id)sender
{
    
    NSLog(@"消息页面");
//    [_messageButton dismiss];
    
    [[BaiduMobStat defaultStat] logEvent:@"newMessages" eventLabel:@"所有-新消息入口"];
    if(!_eventNewMessages) {
        _eventNewMessages = YES;
        [[BaiduMobStat defaultStat] eventStart:@"newMessages" eventLabel:@"所有-新消息入口"];
    } else {
        _eventNewMessages = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"newMessages" eventLabel:@"所有-新消息入口"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"newMessages" eventLabel:@"所有-新消息入口" durationTime:1000];
    
    
    MZMessageViewController *messageVC = [[MZMessageViewController alloc]init];
    messageVC.code = @"0";
    [self.navigationController pushViewController:messageVC animated:YES];
}


//- (void)newIsHaveRequest
//{
//    __weak typeof(self) weakSelf = self;
//    MZNewIsHaveParam *newlistsParam = [[MZNewIsHaveParam alloc]init];
//    newlistsParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
//    [self showHoldView];
//    [MZRequestManger newIsHaveRequest:newlistsParam success:^(NSDictionary *object) {
//        [weakSelf hideHUD];
//        MZModel *newIsHaveModel = [MZModel objectWithKeyValues:object];
//        if (newIsHaveModel.totleNums == 0) {
//            [self createMessageViewforHidden:YES];
//        }else{
//            [self createMessageViewforHidden:NO];
//        }
//    } failure:^(NSString *errMsg, NSString *errCode) {
//        [weakSelf hideHUD];
//    }];
//
//}


- (void)initDataWithPage:(NSInteger)page
{
    MZDynamicListParam *dynamicListParam = [[MZDynamicListParam alloc]init];
    dynamicListParam.album_id = self.album_id;
    dynamicListParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    dynamicListParam.page = page;
    [MZRequestManger photolistsRequest:dynamicListParam success:^(NSArray *object) {
        if (_page == 1) {
              [_modelArray removeAllObjects];
              _modelArray = [NSMutableArray arrayWithCapacity:object.count];
        }
        for (NSDictionary *dic in object) {
            MZDynamicListModel *dataModel = [MZDynamicListModel objectWithKeyValues:dic];
//            if (page == 1) {
//                [_modelArray insertObject:dataModel atIndex:0];
//            }else{
                [_modelArray addObject:dataModel];
//            }
//            for (MZImageListsModel *imageListsModel in dataModel.img_lists) {
//                [_imageArray addObject:imageListsModel];
//            }
        }
        [self endRefreshing];
    } failure:^(NSString *errMsg, NSString *errCode) {
         [self endRefreshing];
    }];

}

- (void)endRefreshing
{
    // 刷新表格
    [_tableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}


#pragma mark -- Event Response

//- (void)didClickRightBarAction
//{
//    NSLog(@"相册详情");
//    
//    
//    [[BaiduMobStat defaultStat] logEvent:@"albumInfo" eventLabel:@"照片列表页-相册信息入口"];
//    if(!_eventAlbumInfo) {
//        _eventAlbumInfo = YES;
//        [[BaiduMobStat defaultStat] eventStart:@"albumInfo" eventLabel:@"照片列表页-相册信息入口"];
//    } else {
//        _eventAlbumInfo = NO;
//        [[BaiduMobStat defaultStat] eventEnd:@"albumInfo" eventLabel:@"照片列表页-相册信息入口"];
//    }
//    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"albumInfo" eventLabel:@"照片列表页-相册信息入口" durationTime:1000];
//
//    
//    
//    MZPhotoAlbumDetailViewController *photoAlbumDetailVC = [[MZPhotoAlbumDetailViewController alloc]init];
//    photoAlbumDetailVC.album_id = self.album_id;
//    photoAlbumDetailVC.user_id = self.uid;
//    photoAlbumDetailVC.cover_img = self.cover_img;
//    [self.navigationController pushViewController:photoAlbumDetailVC animated:YES];
//    
//}


- (void)didClickAddButtonAction
{
    [MZHomeFootAnimationButton showWithDelegate:self];
    
}

#pragma mark ----- MZHomeFootAnimationButtonDelegate
- (void)phoneButtonTouchUpInside:(UIButton *)button
{
    NSLog(@"视频");
    [MZHomeFootAnimationButton hide];
    MZMakeMovieViewController *makeMovieVC = [[MZMakeMovieViewController alloc]init];
    makeMovieVC.album_id = _album_id;
    makeMovieVC.albumType = MZRecordingViewControllerTypeNormal;
    [self presentViewController:makeMovieVC animated:YES completion:^{}];
}


- (void)assetsButtonTouchUpInside:(UIButton *)button
{
    NSLog(@"相册");
    [MZHomeFootAnimationButton hide];
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    // 最多能选9张图片
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.delegate = self;
    pickerVc.maxCount = 30;
    [pickerVc showPickerVc:self];

   
}
#pragma mark -----ZLPhotoPickerViewControllerDelegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets
{
    MZRecordingViewController *recordingVC = [[MZRecordingViewController alloc]init];
    NSMutableArray *assetArray = [NSMutableArray arrayWithCapacity:assets.count];
//    NSMutableArray *selectAssets = [NSMutableArray arrayWithCapacity:assets.count];
    for (int i = 0; i<assets.count ; i++) {
        
        if ([[assets objectAtIndex:i]isKindOfClass:[UIImage class]]) {
            [assetArray addObject:[assets objectAtIndex:i]];
        }
        
        if ([[assets objectAtIndex:i]isKindOfClass:[ZLPhotoAssets class]]) {
            ZLPhotoAssets *photoAssets = [assets objectAtIndex:i];
            UIImage *image = [UIImage imageWithCGImage:photoAssets.asset.defaultRepresentation.fullResolutionImage
                                                 scale:photoAssets.asset.defaultRepresentation.scale
                                           orientation:(UIImageOrientation)photoAssets.asset.defaultRepresentation.orientation];
            [assetArray addObject:image];
        }
        
    }
    
//      [selectAssets addObject:assets];
    recordingVC.albumType = MZRecordingViewControllerTypeNormal;
    recordingVC.selectAssets = [NSMutableArray arrayWithArray:assets];
    recordingVC.assets = assetArray;
    recordingVC.album_id = self.album_id;
    [self presentViewController:recordingVC animated:YES completion:^{}];
}
#pragma mark ----- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = _tableView.contentOffset.y;
//    NSLog(@"currentPostion == %d",currentPostion);
    MZDynamicViewController *dynamicVC = (MZDynamicViewController *)self.parentViewController;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.frame = rect(0,40+64, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f);
            dynamicVC.segmentedControl.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
            dynamicVC.lineLabel.frame = rect(0, 64+40, SCREEN_WIDTH, 0.5);
            [_addButton setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 20 - _tmpImage.size.height/2)];
        }];
//        NSLog(@"ScrollUp now  向上滑");
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        
//        NSLog(@"ndvnlvn == %f",_tableView.contentSize.height);
        if (currentPostion > 200 && currentPostion< _tableView.contentSize.height-SCREEN_HEIGHT-64) {
            [UIView animateWithDuration:0.5 animations:^{
                _tableView.frame = rect(0,40+64-40, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f);
                dynamicVC.segmentedControl.frame = CGRectMake(0, 64-64, SCREEN_WIDTH, 40);
                dynamicVC.lineLabel.frame = rect(0, 64+40-64, SCREEN_WIDTH, 0.5);
                [_addButton setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 20 - _tmpImage.size.height/2+84)];
            }];
        }
//        NSLog(@"ScrollDown now  向下滑");
    }
}

#pragma mark ----- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZDynamicListModel *dataModel = [_modelArray objectAtIndex:indexPath.row];
    if (dataModel.lists.count == 1) {
        return SCREEN_WIDTH+80.0f;
    }else if (dataModel.lists.count == 2){
        return (SCREEN_WIDTH-30.0f)/2+60.0f+30.0f+20.0f;
    }else if (dataModel.lists.count == 3){
        return (SCREEN_WIDTH-30.0f)/3+60.0f+30.0f+20.0f;
    }else if (dataModel.lists.count == 4){
        return (SCREEN_WIDTH-30.0f)+60.0f+30.0f+20.0f;
    }else if (dataModel.lists.count > 4 && dataModel.lists.count < 7){
        return ((SCREEN_WIDTH-30.0f)/3)*2+60.0f+30.0f+20.0f;
    }else{
        if (dataModel.lists.count%3>0) {
             return ((SCREEN_WIDTH-30.0f)/3)*(dataModel.lists.count/3+1)+60.0f+30.0f+20.0f;
        }else{
             return ((SCREEN_WIDTH-30.0f)/3)*(dataModel.lists.count/3)+60.0f+30.0f+20.0f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicListTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:dynamicListCellIdentifier forIndexPath:indexPath];
    dynamicCell.row = indexPath.row;
    dynamicCell.delegate = self;
    dynamicCell.album_id = self.album_id;
    dynamicCell.album_name = _album_name;
    if (_modelArray.count>0) {
        MZDynamicListModel *dataModel = [_modelArray objectAtIndex:indexPath.row];
        dynamicCell.model = dataModel;
//        dynamicCell.imageListsArray = dataModel.img_lists;
    }
    return dynamicCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[BaiduMobStat defaultStat] logEvent:@"photo" eventLabel:@"照片列表页-照片详情"];
    if(!_eventPhoto) {
        _eventPhoto = YES;
        [[BaiduMobStat defaultStat] eventStart:@"photo" eventLabel:@"照片列表页-照片详情"];
    } else {
        _eventPhoto = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"photo" eventLabel:@"照片列表页-照片详情"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"photo" eventLabel:@"照片列表页-照片详情" durationTime:1000];
    
    
    MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
    dynamicDetailVC.album_id = self.album_id;
    dynamicDetailVC.album_name = _album_name;
    dynamicDetailVC.albumType = DynamicDetailViewControllerTypeNormal;
    if (_modelArray.count > 0) {
        MZDynamicListModel *dataModel = [_modelArray objectAtIndex:indexPath.row];
        dynamicDetailVC.issue_id = dataModel.issue_id;
    }
    _isDetail =YES;
    [userdefaultsDefine removeObjectForKey:@"row"];
    [userdefaultsDefine setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"row"];
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}


#pragma mark ------ MZDynamicListDelegate
- (void)didClickButtonWithTag:(NSInteger)tag photoId:(NSString *)photoId dynamicListModel:(MZDynamicListModel *)dynamicListModel row:(NSUInteger)row
{
    switch (tag) {
        case 10000:
        {
            NSLog(@"照片列表点赞");
            
//            UIButton *btn=(UIButton*)[self.view viewWithTag:tag];
//            //先将未到时间执行前的任务取消。
//            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:btn];
//            [self performSelector:@selector(todoSomething:) withObject:btn afterDelay:0.2f];
            
            MZPhotoGoodParam *photoGoodParam = [[MZPhotoGoodParam alloc]init];
            photoGoodParam.album_id = self.album_id;
            photoGoodParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
            photoGoodParam.issue_user_id = dynamicListModel.user_id;
            photoGoodParam.issue_id = photoId;
            [MZRequestManger photoGoodRequest:photoGoodParam success:^(NSDictionary *object) {
                MZModel *model = [MZModel objectWithKeyValues:object];
                if (model.errCode == 10002) {
                    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"已赞过了哦" message:nil delegate:nil
                                                              cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alterView show];
                }else if(model.errCode == 0){
                    dynamicListModel.goods= dynamicListModel.goods+1;
                    dynamicListModel.is_good = 1;
                    [_tableView reloadData];
                }else{
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"请稍后再试" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alerView show];
                }
            } failure:^(NSString *errMsg, NSString *errCode) {
                
            }];
        }
            break;
        case 10001:
        {
            NSLog(@"评论");
            MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
            dynamicDetailVC.album_id = self.album_id;
            dynamicDetailVC.album_name = _album_name;
//                dynamicDetailVC.user_id = dynamicListModel.user_id;
//            dynamicDetailVC.photo_id = dynamicListModel.photoId;
            dynamicDetailVC.issue_id = photoId;
            
            [self.navigationController pushViewController:dynamicDetailVC animated:YES];

        }
            break;
        case 10002:
        {
            NSLog(@"分享");
            
            [[BaiduMobStat defaultStat] logEvent:@"share" eventLabel:@"所有-分享入口"];
            if(!_eventShare) {
                _eventShare = YES;
                [[BaiduMobStat defaultStat] eventStart:@"share" eventLabel:@"所有-分享入口"];
            } else {
                _eventShare = NO;
                [[BaiduMobStat defaultStat] eventEnd:@"share" eventLabel:@"所有-分享入口"];
            }
            [[BaiduMobStat defaultStat] logEventWithDurationTime:@"share" eventLabel:@"所有-分享入口" durationTime:1000];
            MZShareView *shareView =[[MZShareView alloc]init];
            shareView.frame = [UIScreen mainScreen].bounds;
//            NSDictionary *dic = [dynamicListModel.lists objectAtIndex:0];
            MZListsModel *listsModel = [dynamicListModel.lists objectAtIndex:0];
//            _path_img =[dic objectForKey:@"path_img"];
            _path_img = listsModel.path_img;
            _issue_id = dynamicListModel.issue_id;
            _uname =dynamicListModel.uname;
            shareView.delegate = self;
            [shareView show];
        }
            break;
        case 10003:
        {
            NSLog(@"举报或者删除图片");
            [[BaiduMobStat defaultStat] logEvent:@"more" eventLabel:@"所有-更多入口"];
            if(!_eventMore) {
                _eventMore = YES;
                [[BaiduMobStat defaultStat] eventStart:@"more" eventLabel:@"所有-更多入口"];
            } else {
                _eventMore = NO;
                [[BaiduMobStat defaultStat] eventEnd:@"more" eventLabel:@"所有-更多入口"];
            }
            [[BaiduMobStat defaultStat] logEventWithDurationTime:@"more" eventLabel:@"所有-更多入口" durationTime:1000];
            NSLog(@"dynamicListModel.is_bos = %ld",dynamicListModel.is_bos);
            //自己是不是群主
            if (dynamicListModel.is_bos == 0) {
                MZOneMoreView *oneMoreView =[[MZOneMoreView alloc]init];
                oneMoreView.frame = [UIScreen mainScreen].bounds;
                //删除自己 不能举报自己   B
                if ([[userdefaultsDefine objectForKey:@"user_id"] isEqualToString:dynamicListModel.user_id]) {
                    oneMoreView.oneButton.tag = 50000;
//                    [oneMoreView.oneButton setImage:[UIImage imageNamed:@"mian_remove@2x"] forState:UIControlStateNormal];
                     [oneMoreView.oneButton setTitle:@"删除" forState:UIControlStateNormal];

                //自己不能删除别人 自己能举报别人   B
                }else{
                    oneMoreView.oneButton.tag = 50001;
//                    [oneMoreView.oneButton setImage:[UIImage imageNamed:@"mian_report@2x"] forState:UIControlStateNormal];
                    [oneMoreView.oneButton setTitle:@"举报" forState:UIControlStateNormal];
                }
                oneMoreView.delegate = self;
                [oneMoreView show];
            //自己是群主
            }else{
                //删除一定在
                //举报不一定在
                //1 删除  自己不能举报自己 B
                if ([[userdefaultsDefine objectForKey:@"user_id"]isEqualToString:dynamicListModel.user_id]) {
                    MZOneMoreView *oneMoreView =[[MZOneMoreView alloc]init];
                    oneMoreView.frame = [UIScreen mainScreen].bounds;
                    oneMoreView.oneButton.tag = 50000;
//                    [oneMoreView.oneButton setImage:[UIImage imageNamed:@"mian_remove@2x"] forState:UIControlStateNormal];
                    [oneMoreView.oneButton setTitle:@"删除" forState:UIControlStateNormal];
                    oneMoreView.delegate = self;
                    [oneMoreView show];
                //2 删除  自己可以举报别人  A
                }else{
                    MZMoreView *moreView =[[MZMoreView alloc]init];
                    moreView.frame = [UIScreen mainScreen].bounds;
                    moreView.delegate = self;
                    [moreView show];
                }
            }
            _issue_id = dynamicListModel.issue_id;
//            NSLog(@"photoId == %@",dynamicListModel.photoId);
            _photoListOfTheUserId = dynamicListModel.user_id;
            _row = row;
        }
            break;
        default:
            break;
    }
}


- (void)todoSomething:(UIButton *)button
{
    NSLog(@"点赞333");
//    button.enabled = YES;
}


#pragma mark ------MZMoreViewDelegate
//举报
- (void)clickReportButtonAction
{
    __weak typeof(self) weakSelf = self;
    MZReportUserParam *reportUserParam = [[MZReportUserParam alloc]init];
    reportUserParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    reportUserParam.album_memId = _photoListOfTheUserId;
    reportUserParam.album_id = self.album_id;
    [self showHoldView];
    [MZRequestManger reportUserRequest:reportUserParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
        NSLog(@"object  == %@",object );
        MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
        if ([response.errMsg isEqualToString:@"账号冻结"]) {
            return ;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"举报成功了!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];
    
}
//- (void)clickCoverButtonAction
//{
//    MZResetAlbumImg *resetAlbumImg = [[MZResetAlbumImg alloc]init];
//    resetAlbumImg.img_id = _img_id;
//    resetAlbumImg.album_id = self.album_id;
//    [MZRequestManger resetAlbumImgRequest:resetAlbumImg success:^(NSDictionary *object) {
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"小图提示" message:@"设为封面成功了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alerView show];
//    } failure:^(NSString *errMsg, NSString *errCode) {
//        
//    }];
//    
//}
- (void)clickRemoveButtonAction
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请问您要删除这条动态吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark ---- UIAlerViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
            __weak typeof(self) weakSelf = self;
            MZPhoneDelParam *phoneParam = [[MZPhoneDelParam alloc]init];
            phoneParam.issue_id =_issue_id;
            phoneParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
            [self showHoldView];
            [MZRequestManger phoneDelRequest:phoneParam success:^(NSDictionary *object) {
                [weakSelf hideHUD];
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    return ;
                }
                [_modelArray removeObjectAtIndex:_row];//移除数据源的数据
                // 马上进入刷新状态
                [_tableView.header beginRefreshing];
            } failure:^(NSString *errMsg, NSString *errCode) {
                [weakSelf hideHUD];
        }];
    }
}



- (void)clickOneButtonAction:(UIButton *)button;
{
    if (button.tag == 50000) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请问您要删除这条动态吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        __weak typeof(self) weakSelf = self;
        MZReportUserParam *reportUserParam = [[MZReportUserParam alloc]init];
        reportUserParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
        reportUserParam.album_memId = _photoListOfTheUserId;
        reportUserParam.album_id = self.album_id;
        [self showHoldView];
        [MZRequestManger reportUserRequest:reportUserParam success:^(NSDictionary *object) {
            [weakSelf hideHUD];
            MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
            NSLog(@"response.errMsg == %@",response.errMsg);
            if ([response.errMsg isEqualToString:@"账号冻结"]) {
                return ;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"举报成功了!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } failure:^(NSString *errMsg, NSString *errCode) {
            [weakSelf hideHUD];
        }];
    }
}


+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


#pragma mark ---- MZShareViewDelegate
- (void)clickWechatButtonAction
{
    [[BaiduMobStat defaultStat] logEvent:@"wechatShare" eventLabel:@"微信好友分享"];
    if(!_eventWechatShare) {
        _eventWechatShare = YES;
        [[BaiduMobStat defaultStat] eventStart:@"wechatShare" eventLabel:@"微信好友分享"];
    } else {
        _eventWechatShare = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"wechatShare" eventLabel:@"微信好友分享"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"wechatShare" eventLabel:@"微信好友分享" durationTime:1000];
    [self shareImageWithSocialPlatformWithName:UMShareToWechatSession];
}

- (void)shareImageWithSocialPlatformWithName:(NSString *)name
{
    __weak typeof(self) weakSelf = self;
    MZShareParam *shareParam = [[MZShareParam alloc]init];
    shareParam.code = @"PhotoDetail";
    shareParam.issue_id = _issue_id;
    shareParam.album_id = _album_id;
    shareParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    [self showHoldView];
    [MZRequestManger shareRequest:shareParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
        MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
        if ([response.errMsg isEqualToString:@"账号冻结"]) {
            return ;
        }

        
        UIImageView *sharImage = [[UIImageView alloc] init];
        [sharImage sd_setImageWithURL:[NSURL URLWithString:_path_img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"《%@》",_album_name];
            UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
            [socialControllerService setShareText: [NSString stringWithFormat:@"%@和您分享ta的精彩时刻",_uname] shareImage:UIImagePNGRepresentation(sharImage.image) socialUIDelegate:nil];
            NSLog(@"url == %@",[object objectForKey:@"url"]);
            [UMSocialData defaultData].extConfig.wechatSessionData.url = [object objectForKey:@"url"];
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = [object objectForKey:@"url"];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:name].snsClickHandler(weakSelf,socialControllerService,YES);
        }];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];
}


- (void)clickWechatFriendButtonAction
{
    [[BaiduMobStat defaultStat] logEvent:@"momentsShare" eventLabel:@"朋友圈分享"];
    if(!_eventMomentsShare) {
        _eventMomentsShare = YES;
        [[BaiduMobStat defaultStat] eventStart:@"momentsShare" eventLabel:@"朋友圈分享"];
    } else {
        _eventMomentsShare = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"momentsShare" eventLabel:@"朋友圈分享"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"momentsShare" eventLabel:@"朋友圈分享" durationTime:1000];
     [self shareImageWithSocialPlatformWithName:UMShareToWechatTimeline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[MDWMediaCenter defaultCenter]stopPlay];
    
    if ([userdefaultsDefine objectForKey:@"publish"]) {
          [_tableView.header beginRefreshing];
        [userdefaultsDefine removeObjectForKey:@"publish"];
    }

    if ([userdefaultsDefine boolForKey:@"firstCreatePhotoView"] == YES) {
        MZCreatePhotoView *createPhotoView = [[MZCreatePhotoView alloc]init];
        createPhotoView.frame = [UIScreen mainScreen].bounds;
        [createPhotoView show];
        [userdefaultsDefine setBool:NO forKey:@"firstCreatePhotoView"];
    }
    
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"照片列表页"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"照片列表页"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
