//
//  MZMainViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZMainViewController.h"
#import "MZBaseNavigationViewController.h"
#import "MZMainCollectionViewCell.h"
#import "MZDynamicListViewController.h"
#import "MZloginViewController.h"

#import "MZAddPhotoAlbumViewController.h"

#import "MZMainSortView.h"
#import "MZDrawerView.h"
#import "MZMessageViewController.h"
#import "MZSetViewController.h"
#import "MZFeedbackViewController.h"

#import "MZMainParam.h"
#import "MZMainResponseDataModel.h"


#import "AFNetworking.h"
#import "RequestInferface.h"
#import "MZUploadHeadImgParam.h"
#import "MZModel.h"


#import "MJRefresh.h"
#import "MZLaunchManager.h"
#import "MZEditInfoViewController.h"
#import "MZAboutWeViewController.h"


#import "MZDynamicViewController.h"
#import "MDWMainCollectionHeaderView.h"
#import "MZAdvertModel.h"
#import "MZAdvertParam.h"
#import "PopoverView.h"
#import "QRCodeReaderViewController.h"
#import "MZAppAddParam.h"

#import "MZYearView.h"

#define NAVBAR_CHANGE_POINT 0


@interface MZMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MZDrawerViewDelegate,MZMainSortViewDelegate,PopoverViewDelegate,QRCodeReaderDelegate>
{
    UICollectionView * _collectionView;
    NSMutableArray *_modelArray;
    NSMutableArray *_advertArray;
    UIImageView *_headImage;
    NSInteger _page;
    NSString *_type;
    BOOL _eventAddAlbum;
    BOOL _eventSortAlbum;
    BOOL _eventSortAlbumByCreateTime;
    BOOL _eventSortAlbumByUpdateTime;
    BOOL _eventPersonalCenter;
    BOOL _eventAlbum;
    BOOL _eventPersonalSetting;
    BOOL _eventMyMessages;
    BOOL _eventAlbumListPage;
    NSUInteger _lastPosition;//检测CollectionView的滚动方向
//    MZYearView *_yearView;
}
@end

@implementation MZMainViewController

static NSString * const mzmainCollectionViewCellIdentifier = @"mainCell";

#pragma mark -- Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![userdefaultsDefine objectForKey:@"user_id"]) {
        [[MZLaunchManager manager]logoutScreen];
    }else{
        [_collectionView.header beginRefreshing];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相册";
    [self requestBanner];
    [self initUI];
}

- (void)initUI
{
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self createBarButtonItemWithLeftBar:@"main_highlight_me" addBar:@"main_highlight_add" rightBar:@"main_highlight_sort"];
    //创建一个布局样式
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-44.0f) collectionViewLayout:layout];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-20.0f) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    //注册标识
    [_collectionView registerNib:[UINib nibWithNibName:@"MZMainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:mzmainCollectionViewCellIdentifier];
    
    //距离顶头
    layout.headerReferenceSize =CGSizeMake(_collectionView.frame.size.width,175.0f+10.0f);
    
    [_collectionView registerClass:[MDWMainCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    _type = @"create_time";
    _page=1;
    
    __weak __typeof(self) weakSelf = self;
    // 下拉刷新
    _collectionView.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page = 1;
        [weakSelf initDataPage:_page type:_type];
    }];
    
    // 马上进入刷新状态
    [_collectionView.header beginRefreshing];
    
    // 上拉加载更多
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page++;
         [weakSelf initDataPage:_page type:_type];
    }];
    
//    _yearView = [[MZYearView alloc]initWithFrame:rect(0,-30,SCREEN_WIDTH,30)];
//    _yearView.hidden = YES;
//    [self.view addSubview:_yearView];
    
//    [_yearView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.right.equalTo(self.view.mas_right).offset(0);
//        make.top.equalTo(self.view.mas_top).offset(-30);
//        make.height.equalTo(@30);
//    }];
    
}



- (void)initDataPage:(NSInteger)page type:(NSString *)type
{
    MZMainParam *mainParam = [[MZMainParam alloc]init];
    mainParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    mainParam.type = type;
    mainParam.page = page;
    [MZRequestManger AlbumlistsRequest:mainParam success:^(NSArray *responseData,NSDictionary *object) {
        MZModel *model = [MZModel objectWithKeyValues:object];
       
        if (model.errCode == 10002) {
            [[MZLaunchManager manager] tempMainViewController];
        }
        
        if (page == 1) {
            [_modelArray removeAllObjects];
            _modelArray = [NSMutableArray arrayWithCapacity:responseData.count];
        }
        for (NSDictionary *dic in responseData) {
            MZMainResponseDataModel *mainResponseDataModel = [MZMainResponseDataModel objectWithKeyValues:dic];
            //                if (page == 1) {
            //                    [_modelArray insertObject:mainResponseDataModel atIndex:0];
            //                }else{
            [_modelArray addObject:mainResponseDataModel];
            //                }
        }
        [self endRefreshing];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [self endRefreshing];
        
    }];
}


- (void)endRefreshing
{
    // 刷新表格
    [_collectionView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_collectionView.header endRefreshing];
    [_collectionView.footer endRefreshing];
}


#pragma mark -- Event Response
/**
 *  导航栏左边按钮的响应方法
 */
- (void)didClickLeftBarAction
{
    NSLog(@"弹出侧边栏");
    
    [[BaiduMobStat defaultStat] logEvent:@"personalCenter" eventLabel:@"所有-个人中心"];
    if(!_eventPersonalCenter) {
        _eventPersonalCenter = YES;
        [[BaiduMobStat defaultStat] eventStart:@"personalCenter" eventLabel:@"所有-个人中心"];
    } else {
        _eventPersonalCenter = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"personalCenter" eventLabel:@"所有-个人中心"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"personalCenter" eventLabel:@"所有-个人中心" durationTime:1000];
    
    MZDrawerView *drawerView =[[MZDrawerView alloc]init];
    drawerView.frame = [UIScreen mainScreen].bounds;
    drawerView.drawerDelegate = self;
    [drawerView show];
   
}

/**
 * Description : 首页轮播列表接口请求
 *
 */
- (void)requestBanner
{
    MZAdvertParam *advert = [[MZAdvertParam alloc]init];
    
    [MZRequestManger publicAlbumRequest:advert success:^(NSArray *object) {
        _advertArray = [NSMutableArray arrayWithCapacity:object.count];
        for (NSDictionary *dic in object) {
            MZAdvertModel *advertModel = [MZAdvertModel objectWithKeyValues:dic];
            [_advertArray addObject:advertModel];
        }
    } failure:^(NSString *errMsg, NSString *errCode) {
          
    }];
}


- (void)didClickAddButton:(UIButton *)button
{
    NSLog(@"添加相册");
    
    [[BaiduMobStat defaultStat] logEvent:@"addAlbum" eventLabel:@"相册列表页-添加相册"];
    if(!_eventAddAlbum) {
        _eventAddAlbum = YES;
        [[BaiduMobStat defaultStat] eventStart:@"addAlbum" eventLabel:@"相册列表页-添加相册"];
    } else {
        _eventAddAlbum = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"addAlbum" eventLabel:@"相册列表页-添加相册"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"addAlbum" eventLabel:@"相册列表页-添加相册" durationTime:1000];
    
    
    CGPoint point =
    CGPointMake(button.frame.origin.x + button.frame.size.width / 2,
                64.0 + 3.0);
    //
    NSArray *titles = @[@"创建相册",@"扫码加入"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point
                                                   titles:titles
                                               imageNames:@[@"main_addAlbum_normal",@"main_qrcode_normal"] highlitedImages:@[@"main_addAlbum_highlited",@"main_qrcode_highlited"]];
    pop.delegate = self;
    [pop show];
}
#pragma mark - PopoverViewDelegate
- (void)didSelectedRowAtIndex:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"创建相册");
        MZAddPhotoAlbumViewController *addPhotoAlbumVC = [[MZAddPhotoAlbumViewController alloc]init];
        [self.navigationController pushViewController:addPhotoAlbumVC animated:YES];
    } else if (index == 1) {
        NSLog(@"扫一扫");
        // 扫描二维码
        QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
        reader.delegate = self;
        
        __weak typeof (self) wSelf = self;
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"resultAsString == %@",resultAsString);
            NSString *heardString = [resultAsString substringToIndex:15];
//            NSLog(@"heardString == %@",heardString);
            if ([heardString isEqualToString:@"http://tushenme"]) {
                
                MZAppAddParam *appAddParam = [[MZAppAddParam alloc]init];
                NSArray *array = [resultAsString componentsSeparatedByString:@"="];
                appAddParam.album_id = [array objectAtIndex:1];
                //appAddParam.album_id = [resultAsString substringFromIndex:76];
                //从字符A中分隔成2个元素的数组
                appAddParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
                
                
                NSLog(@"appAddParam.album_id == %@",appAddParam.album_id);
                NSLog(@"appAddParam.user_id == %@",appAddParam.user_id);
                
                [MZRequestManger appAddRequest:appAddParam success:^(NSDictionary *object) {
                    NSLog(@"ljhdsak == %@",[object objectForKey:@"errCode"]);
                    if ([[[object objectForKey:@"errCode"]stringValue]isEqualToString:@"1"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"您已经加入过相册." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                         [alert show];
                         [wSelf.navigationController popViewControllerAnimated:YES];
                    }else if ([[[object objectForKey:@"errCode"]stringValue]isEqualToString:@"10010"]){
                        NSLog(@"您的账号被冻结了");
                        return ;
                    }else{
//
//                        
//                        
//                    }else{
                         NSString *album_name = [NSString stringWithFormat:@"《%@》",[[object objectForKey:@"responseData"]objectForKey:@"album_name"]];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加入成功" message:album_name delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                         [alert show];
                        [wSelf.navigationController popViewControllerAnimated:YES];
                        
                        MZDynamicViewController *dynamicListVC = [[MZDynamicViewController alloc]initWithAlbum_id:[NSString stringWithFormat:@"%@",[[object objectForKey:@"responseData"]objectForKey:@"id"]] album_name:[[object objectForKey:@"responseData"]objectForKey:@"album_name"]];
                        dynamicListVC.cover_img = [[object objectForKey:@"responseData"]objectForKey:@"cover_img"];
                        [wSelf.navigationController pushViewController:dynamicListVC animated:YES];
                       
                    }
                } failure:^(NSString *errMsg, NSString *errCode) {
                    NSLog(@"--------------------------");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"加入相册失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    [wSelf.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"注意" message:@"此二维码无效" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
                 [wSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        //[self presentViewController:reader animated:YES completion:NULL];
        [self.navigationController pushViewController:reader animated:YES];


    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
   
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didClickRightButton
{
    NSLog(@"排序");
    [[BaiduMobStat defaultStat] logEvent:@"sortAlbum" eventLabel:@"相册列表页-排序"];
    if(!_eventSortAlbum) {
        _eventSortAlbum = YES;
        [[BaiduMobStat defaultStat] eventStart:@"sortAlbum" eventLabel:@"相册列表页-排序"];
    } else {
        _eventSortAlbum = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"sortAlbum" eventLabel:@"相册列表页-排序"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"sortAlbum" eventLabel:@"相册列表页-排序" durationTime:1000];
    
    MZMainSortView *mainSortView = [[MZMainSortView alloc]init];
    mainSortView.frame = [UIScreen mainScreen].bounds;
    mainSortView.delegate = self;
    [mainSortView show];
    
}


#pragma mark ----- MZMainSortViewDelegate

- (void)clickCreatePhotoButtonEvent
{
    [[BaiduMobStat defaultStat] logEvent:@"sortAlbumByCreateTime" eventLabel:@"相册列表页-创建时间排序"];
    if(!_eventSortAlbumByCreateTime) {
        _eventSortAlbumByCreateTime = YES;
        [[BaiduMobStat defaultStat] eventStart:@"sortAlbumByCreateTime" eventLabel:@"相册列表页-创建时间排序"];
    } else {
        _eventSortAlbumByCreateTime = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"sortAlbumByCreateTime" eventLabel:@"相册列表页-创建时间排序"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"sortAlbumByCreateTime" eventLabel:@"相册列表页-创建时间排序" durationTime:1000];
    
    _type = @"create_time";
    [self initDataPage:1 type:_type];
}

- (void)clickUpdatePhotoButtonEvent
{
    [[BaiduMobStat defaultStat] logEvent:@"sortAlbumByUpdateTime" eventLabel:@"相册列表页-更新时间排序"];
    if(!_eventSortAlbumByUpdateTime) {
        _eventSortAlbumByUpdateTime = YES;
        [[BaiduMobStat defaultStat] eventStart:@"sortAlbumByUpdateTime" eventLabel:@"相册列表页-更新时间排序"];
    } else {
        _eventSortAlbumByUpdateTime = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"sortAlbumByUpdateTime" eventLabel:@"相册列表页-更新时间排序"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"sortAlbumByUpdateTime" eventLabel:@"相册列表页-更新时间排序" durationTime:1000];

    
    _type = @"update_time";
    [self initDataPage:1 type:_type];
}

#pragma mark ----- MZDrawerViewDelegate

- (void)didClickHeadImageAction:(UIImageView *)headImage user_img:(NSString *)user_img user_name:(NSString *)user_name sex:(NSString *)sex
{
    
    [[BaiduMobStat defaultStat] logEvent:@"personalSetting" eventLabel:@"左抽屉-个人设置"];
    if(!_eventPersonalSetting) {
        _eventPersonalSetting = YES;
        [[BaiduMobStat defaultStat] eventStart:@"personalSetting" eventLabel:@"左抽屉-个人设置"];
    } else {
        _eventPersonalSetting = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"personalSetting" eventLabel:@"左抽屉-个人设置"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"personalSetting" eventLabel:@"左抽屉-个人设置" durationTime:1000];
    
    
    MZEditInfoViewController *editInfoVC = [[MZEditInfoViewController alloc]init];
    editInfoVC.user_img = user_img;
    editInfoVC.user_name = user_name;
    editInfoVC.sex = sex;
    [self.navigationController pushViewController:editInfoVC animated:YES];
}


- (void)didClickCellWithRow:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            NSLog(@"我的消息");
            
            [[BaiduMobStat defaultStat] logEvent:@"myMessages" eventLabel:@"左抽屉-我的消息"];
            if(!_eventMyMessages) {
                _eventMyMessages = YES;
                [[BaiduMobStat defaultStat] eventStart:@"myMessages" eventLabel:@"左抽屉-我的消息"];
            } else {
                _eventMyMessages = NO;
                [[BaiduMobStat defaultStat] eventEnd:@"myMessages" eventLabel:@"左抽屉-我的消息"];
            }
            [[BaiduMobStat defaultStat] logEventWithDurationTime:@"myMessages" eventLabel:@"左抽屉-我的消息" durationTime:1000];
            
            
            MZMessageViewController *messageVC = [[MZMessageViewController alloc]init];
            messageVC.code = @"1";
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"设置");
            MZSetViewController *setVC =[[MZSetViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"APP Store评分");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/tu-shen-me/id1075792518?mt=8"]];
        }
            break;
        case 3:
        {
            NSLog(@"客服与反馈");
            MZFeedbackViewController *feedbackVC = [[MZFeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"关于我们");
            MZAboutWeViewController *aboutWeVC = [[MZAboutWeViewController alloc]init];
            [self.navigationController pushViewController:aboutWeVC animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark ----- UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    int currentPostion = _collectionView.contentOffset.y;
////    NSLog(@"currentPostion == %d",currentPostion);
//    if (currentPostion - _lastPosition > 25) {
//        _lastPosition = currentPostion;
//        if (currentPostion < 110) {
//            [UIView animateWithDuration:0.5 animations:^{
////                _yearView.frame = rect(0, -30, SCREEN_WIDTH, 30);
////                _yearView.hidden = YES;
//            }];
//        }
//        NSLog(@"ScrollUp now  向上滑");
//    }
//    else if (_lastPosition - currentPostion > 25)
//    {
//        _lastPosition = currentPostion;
//        if (currentPostion > 110) {
////            _yearView.hidden = NO;
//            [UIView animateWithDuration:0.5 animations:^{
////                _yearView.frame = rect(0, 0, SCREEN_WIDTH, 30);
//            }];
//        }
//        NSLog(@"ScrollDown now  向下滑");
//    }
//
//    
//    UIColor * color = RGBA(255, 255, 255, 1.0);
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_CHANGE_POINT) {
//        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//        [self createBarButtonItemWithLeftBar:@"main_highlight_me" addBar:@"main_highlight_add" rightBar:@"main_highlight_sort"];
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    } else {
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//        [self createBarButtonItemWithLeftBar:@"main_normal_me" addBar:@"main_normal_add" rightBar:@"main_normal_sort"];
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"main_navigationBar"] forBarMetrics:UIBarMetricsDefault];
//    }
//}

#pragma mark ---- UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _modelArray.count;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    MZMainResponseDataModel *mainResponseDataModel = [_modelArray objectAtIndex:indexPath.row];
    if ([MZMainCollectionViewCell getDiscussHeightWith:mainResponseDataModel]>14) {
        if (iPhone6 || iPhone6P) {
            return CGSizeMake(SCREEN_WIDTH, 290.0f + 10.0f + ([MZMainCollectionViewCell getDiscussHeightWith:mainResponseDataModel]-20));
        }else{
            return CGSizeMake(SCREEN_WIDTH, 290.0f + 10.0f  + ([MZMainCollectionViewCell getDiscussHeightWith:mainResponseDataModel]-20));
        }
    }else{
        return CGSizeMake(SCREEN_WIDTH, 290.0f);
    }
}

//设置header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MDWMainCollectionHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.bannerArray = _advertArray;
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MZMainResponseDataModel *mainResponseDataModel = [_modelArray objectAtIndex:indexPath.row];
    MZMainCollectionViewCell *mainCell = [collectionView dequeueReusableCellWithReuseIdentifier:mzmainCollectionViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        mainCell.segmentLineView.backgroundColor = [UIColor whiteColor];
    }else{
        mainCell.segmentLineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    mainCell.model = mainResponseDataModel;
    return mainCell;
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [[BaiduMobStat defaultStat] logEvent:@"_eventAlbum" eventLabel:@"相册列表页-相册"];
    if(!_eventPersonalCenter) {
        _eventPersonalCenter = YES;
        [[BaiduMobStat defaultStat] eventStart:@"_eventAlbum" eventLabel:@"相册列表页-相册"];
    } else {
        _eventPersonalCenter = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"_eventAlbum" eventLabel:@"相册列表页-相册"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"_eventAlbum" eventLabel:@"相册列表页-相册" durationTime:1000];
    
    
    
    MZMainResponseDataModel *mainResponseDataModel = [_modelArray objectAtIndex:indexPath.row];
//    MZDynamicListViewController *dynamicListVC = [[MZDynamicListViewController alloc]init];
    MZDynamicViewController *dynamicListVC = [[MZDynamicViewController alloc]initWithAlbum_id:mainResponseDataModel.album_id album_name:mainResponseDataModel.album_name];
    dynamicListVC.album_id = mainResponseDataModel.album_id;
//    dynamicListVC.uid = mainResponseDataModel.uid;
    dynamicListVC.cover_img = mainResponseDataModel.cover_img;
    [self.navigationController pushViewController:dynamicListVC animated:YES];
 }

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"相册列表页"];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"相册列表页"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
