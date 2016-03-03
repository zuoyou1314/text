//
//  MZPhotoListViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPhotoListViewController.h"
#import "MZPhotoCollectionViewCell.h"
#import "MZOperationFriendView.h"
#import "MZAlbumUserPhotosParam.h"
#import "MJRefresh.h"
#import "MZIssueListsModel.h"
#import "MZPhotoListsModel.h"
#import "UIImageView+WebCache.h"
#import "MZReportUserParam.h"
#import "MZNoDeleteFriendView.h"
#import "MOKOPictureBrowsingViewController.h"
#import "MZDynamicDetailViewController.h"
@interface MZPhotoListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MZOperationFriendViewDelegate,MZNoDeleteFriendViewDelegate,MOKOPictureBrowsingViewControllerDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_modelArray;
    NSMutableArray *_imageArray;//存放图片url的数组
    NSInteger _page;
    NSString * _idDelMem;// 是否有删除权限  1.有  0.没有
}
@end
   
@implementation MZPhotoListViewController

static NSString * const photoCellIdentifier = @"photoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButton];
    // Do any additional setup after loading the view.
    // main_operation
    UIButton *rightButton = [UIButton createButtonWithNormalImage:@"main_operation" highlitedImage:nil target:self action:@selector(didClickRightBarAction)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self initUI];
}


- (void)setUname:(NSString *)uname
{
    _uname = uname;
    self.title = uname;
}



- (void)initUI
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f) collectionViewLayout:flowLayout];
      _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    //注册Cell
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MZPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:photoCellIdentifier];
    
    __weak __typeof(self) weakSelf = self;
    _page =1;
    // 下拉刷新
    _collectionView.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _page =1;
        [weakSelf initDataWithPage:_page];
    }];
    // 马上进入刷新状态
    [_collectionView.header beginRefreshing];
    // 上拉加载更多
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakSelf initDataWithPage: _page];
    }];
    
}

- (void)initDataWithPage:(NSInteger)page
{
    MZAlbumUserPhotosParam *albumUserPhotosParam = [[MZAlbumUserPhotosParam alloc]init];
    albumUserPhotosParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    albumUserPhotosParam.album_memId = self.album_memId;
    albumUserPhotosParam.album_id = self.album_id;
    albumUserPhotosParam.page = page;
    
    NSLog(@"albumUserPhotosParam.user_id == %@",albumUserPhotosParam.user_id);
    NSLog(@"albumUserPhotosParam.album_memId == %@",albumUserPhotosParam.album_memId);
    
    [MZRequestManger albumUserPhotosRequest:albumUserPhotosParam success:^(NSString * idDelMem, NSArray *object) {
        _idDelMem = [NSString stringWithFormat:@"%@",idDelMem];
        if (page == 1) {
            //    [_modelArray removeAllObjects];
            _modelArray = [NSMutableArray arrayWithCapacity:object.count];
            _imageArray = [NSMutableArray arrayWithCapacity:object.count];

        }
        for (NSDictionary *dic in object) {
            MZIssueListsModel *issueListsModel = [MZIssueListsModel objectWithKeyValues:dic];
            
            for (int i = 0; i<issueListsModel.photoLists.count; i++) {
                MZPhotoListsModel *photoListsModel = [issueListsModel.photoLists objectAtIndex:i];
                
            if (page == 1) {
                [_modelArray insertObject:issueListsModel atIndex:0];
                [_imageArray insertObject:photoListsModel atIndex:0];
            }else{
                [_modelArray addObject:issueListsModel];
                [_imageArray addObject:photoListsModel];
            }
                
            }
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



#pragma mark -----UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MZPhotoListsModel *photoListsModel = [_imageArray objectAtIndex:indexPath.row];
    
    MZPhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellIdentifier forIndexPath:indexPath];
    [photoCell.photoImage sd_setImageWithURL:[NSURL URLWithString:photoListsModel.path_img] placeholderImage:[UIImage imageNamed:@"main_dynamicPlaceholder"]];
    return photoCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *imgeurlArray = [NSMutableArray arrayWithCapacity:_imageArray.count];
    for (int i = 0; i< _imageArray.count ; i++) {
        MZPhotoListsModel *photoListsModel = [_imageArray objectAtIndex:i];
        [imgeurlArray addObject:photoListsModel.path_img];
    }
    MOKOPictureBrowsingViewController *pictureBrowsingViewController = [[MOKOPictureBrowsingViewController alloc] initWithHidden:NO];
    pictureBrowsingViewController.modelArray = _imageArray;
    pictureBrowsingViewController.imgeurlArray =imgeurlArray;
    pictureBrowsingViewController.indexNumber = indexPath.row;
    pictureBrowsingViewController.album_id = _album_id;
    pictureBrowsingViewController.delegate = self;
    if (self.albumType == MZPhotoListViewControllerTypePublicAlbum) {
        pictureBrowsingViewController.albumType = MOKOPictureBrowsingViewControllerTypePublicAlbum;
    }else{
        pictureBrowsingViewController.albumType = MOKOPictureBrowsingViewControllerTypeNormal;
    }
    [self  presentViewController:pictureBrowsingViewController animated:YES completion:^{}];
}

#pragma mark -----MOKOPictureBrowsingViewControllerDelegate
- (void)clickGoodButtonAction:(UIButton *)button
{
    NSLog(@"点赞");
    MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
    dynamicDetailVC.album_id = self.album_id;
    dynamicDetailVC.album_name = _album_name;
    dynamicDetailVC.issue_id = [NSString stringWithFormat:@"%ld",button.tag];
    dynamicDetailVC.albumType = DynamicDetailViewControllerTypeNormal;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}



#pragma mark -- Event Response
- (void)didClickRightBarAction
{
    if ([_idDelMem isEqualToString:@"1"]) {
        MZOperationFriendView *operationFriendView = [[MZOperationFriendView alloc]init];
        operationFriendView.frame = [UIScreen mainScreen].bounds;
        operationFriendView.delegate = self;
        [operationFriendView show];
    }else{
        MZNoDeleteFriendView *deleteFriendView = [[MZNoDeleteFriendView alloc]init];
        deleteFriendView.frame = [UIScreen mainScreen].bounds;
        deleteFriendView.delegate = self;
        [deleteFriendView show];
    }
}

#pragma mark ----- MZOperationFriendViewDelegate

- (void)clickRemoveFriendButtonAction
{
    //0.没有  1.有
        __weak typeof(self) weakSelf = self;
        MZDeleteAlbumMemberParam *deleteAlbumMemberParam = [[MZDeleteAlbumMemberParam alloc]init];
        deleteAlbumMemberParam.user_id = self.album_memId;
        deleteAlbumMemberParam.album_id = self.album_id;
        deleteAlbumMemberParam.del_id = self.album_memId;
        [self showHoldView];
        [MZRequestManger deleteAlbumemberRequest:deleteAlbumMemberParam success:^(NSDictionary *object) {
            [weakSelf hideHUD];
            MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
            if ([response.errMsg isEqualToString:@"账号冻结"]) {
                return ;
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *errMsg, NSString *errCode) {
            [weakSelf hideHUD];
        }];
}

//举报
- (void)clickReportButtonAction
{
    __weak typeof(self) weakSelf = self;
    MZReportUserParam *reportUserParam = [[MZReportUserParam alloc]init];
    reportUserParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    reportUserParam.album_memId = self.album_memId;
    reportUserParam.album_id = self.album_id;
    [self showHoldView];
    [MZRequestManger reportUserRequest:reportUserParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
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
