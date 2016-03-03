//
//  MZWaterfallViewController.m
//  MZTuShenMa
//
//  Created by zuo on 16/1/6.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZWaterfallViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MZCommonPhotoAlbumCollectionViewCell.h"
#import "MZHomeFootAnimationButton.h"
#import "ZLPhotoPickerViewController.h"
#import "MZMakeMovieViewController.h"
#import "MZDynamicListParam.h"
#import "MJRefresh.h"
#import "MZDynamicListModel.h"
#import "MZDynamicDetailViewController.h"
#import "MZRecordingViewController.h"
#import "ZLPhotoAssets.h"
@interface MZWaterfallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,MZHomeFootAnimationButtonDelegate,ZLPhotoPickerViewControllerDelegate>
{
    UICollectionView * _collectionView;
    UIButton *_addButton;//发布按钮
    UIImage *_tmpImage;  //发布图片
    NSInteger _page;
    NSMutableArray *_modelArray;
}
@end

@implementation MZWaterfallViewController

static NSString * const commonPhotoAlbumCellIdentifier = @"commonPhotoAlbumCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MDWMediaCenter defaultCenter]stopPlay];
    if ([userdefaultsDefine objectForKey:@"publish"]) {
        [_collectionView.header beginRefreshing];
        [userdefaultsDefine removeObjectForKey:@"publish"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.album_name;
    [self setLeftBarButton];
    
    //创建一个布局样式
    CHTCollectionViewWaterfallLayout * layout = [[CHTCollectionViewWaterfallLayout alloc]init];
    layout.columnCount = 2;
    layout.itemRenderDirection = CHTCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst;
    layout.minimumColumnSpacing = 10;
    layout.minimumInteritemSpacing = 10;

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册标识
    [_collectionView registerNib:[UINib nibWithNibName:@"MZCommonPhotoAlbumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:commonPhotoAlbumCellIdentifier];
    
    //添加底下悬浮Button
    _addButton = [UIButton createButtonWithNormalImage:@"footAdd@2x" highlitedImage:nil target:self action:@selector(didClickAddButtonAction)];
    _tmpImage = [UIImage imageNamed:@"footAdd"];
    [_addButton setBounds:CGRectMake(0, 0, _tmpImage.size.width, _tmpImage.size.height)];
    [_addButton setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 20 - _tmpImage.size.height/2-64)];
    [self.view addSubview:_addButton];
    
    
    __weak __typeof(self) weakSelf = self;
    _page =1;
   
    // 下拉刷新
    _collectionView.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page =1;
        [weakSelf initDataWithPage:_page];
    }];
    
    // 马上进入刷新状态
    [_collectionView.header beginRefreshing];
    
    // 上拉加载更多
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page++;
        [weakSelf initDataWithPage: _page];
    }];


}

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
        NSLog(@"object == %@",object);
        for (NSDictionary *dic in object) {
            MZDynamicListModel *dataModel = [MZDynamicListModel objectWithKeyValues:dic];
            [_modelArray addObject:dataModel];
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





- (void)didClickAddButtonAction
{
    [MZHomeFootAnimationButton showWithDelegate:self];
}

#pragma mark ---- MZHomeFootAnimationButtonDelegate
- (void)assetsButtonTouchUpInside:(UIButton *)button
{
    [MZHomeFootAnimationButton hide];
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    // 最多能选9张图片
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
}

- (void)phoneButtonTouchUpInside:(UIButton *)button
{
    [MZHomeFootAnimationButton hide];
    NSLog(@"拍视频");
    MZMakeMovieViewController *makeMovieVC = [[MZMakeMovieViewController alloc]init];
    makeMovieVC.album_id = _album_id;
    makeMovieVC.albumType = MZRecordingViewControllerTypePublicAlbum;
    [self presentViewController:makeMovieVC animated:YES completion:^{}];
}

#pragma mark -----ZLPhotoPickerViewControllerDelegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets
{
    MZRecordingViewController *recordingVC = [[MZRecordingViewController alloc]init];
    NSMutableArray *assetArray = [NSMutableArray arrayWithCapacity:assets.count];
    for (int i = 0; i< assets.count ; i++) {
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
    recordingVC.albumType = MZRecordingViewControllerTypePublicAlbum;
    recordingVC.selectAssets = [NSMutableArray arrayWithArray:assets];
    recordingVC.assets = assetArray;
    recordingVC.album_id = self.album_id;
    [self presentViewController:recordingVC animated:YES completion:^{}];
}


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
    
     MZDynamicListModel *dataModel = [_modelArray objectAtIndex:indexPath.row];
      return  [MZCommonPhotoAlbumCollectionViewCell getItemSize:dataModel];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MZDynamicListModel *dataModel = [_modelArray objectAtIndex:indexPath.row];
    MZCommonPhotoAlbumCollectionViewCell *commonPhotoAlbumCell = [collectionView dequeueReusableCellWithReuseIdentifier:commonPhotoAlbumCellIdentifier forIndexPath:indexPath];
    commonPhotoAlbumCell.model = dataModel;
    return commonPhotoAlbumCell;
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
    dynamicDetailVC.album_id = self.album_id;
    dynamicDetailVC.album_name = _album_name;
    if (_modelArray.count > 0) {
        MZDynamicListModel *dataModel = [_modelArray objectAtIndex:indexPath.row];
        dynamicDetailVC.issue_id = dataModel.issue_id;
    }
    dynamicDetailVC.albumType = DynamicDetailViewControllerTypePublicAlbum;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}






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
