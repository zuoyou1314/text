//
//  MZPublishViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/22.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPublishViewController.h"
#import "MZPublishCollectionViewCell.h"
#import "MZAddCollectionViewCell.h"
#import "CTAssetsPageViewController.h"
#import "CTAssetsPickerController.h"
#import "MOKOPictureBrowsingViewController.h"
/**
 *  图片缩略图的高度
 */
#define AddImageOfHeight (self.view.frame.size.width-40.0f)/4
@interface MZPublishViewController ()<MZPublishCollectionViewCellDelegate,UIAlertViewDelegate,CTAssetsPickerControllerDelegate>
{
    UICollectionView *_collectionView;
    /**
     *  进度条
     */
    MBProgressHUD *_progress;
}
@end

@implementation MZPublishViewController

static NSString * const publishCellIdentifier = @"publishCell";
static NSString * const addCellIdentifier = @"addCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(244, 244, 244);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = rect(10, 20, 60, 44);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(0xed7790) forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [cancelButton addTarget:self action:@selector(didClickCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    completeButton.frame = rect(SCREEN_WIDTH-70, 20, 60, 44);
    [completeButton setTitleColor:RGB(72, 193, 221) forState:UIControlStateNormal];
    completeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [completeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(didClickCompleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeButton];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:rect(0, 64-0.5, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = UIColorFromRGB(0xcecece);
    [self.view addSubview:lineLabel];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    if(iPhone6P){
        _collectionView=[[UICollectionView alloc]initWithFrame:rect(0, 64.0f, SCREEN_WIDTH, 160)collectionViewLayout:layout];
    }else{
        _collectionView=[[UICollectionView alloc]initWithFrame:rect(0, 64.0f, SCREEN_WIDTH, 235)collectionViewLayout:layout];
    }
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MZPublishCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:publishCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"MZAddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:addCellIdentifier];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];

}

- (void)didClickCancelButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickCompleteButtonAction
{
    /**
     *  加载一个正在上传的菊花
     */
    _progress = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _progress.mode = MBProgressHUDModeDeterminateHorizontalBar;
//    _progress.color = [UIColor colorWithRed:0.655 green:0.655 blue:0.655 alpha:1];
    _progress.alpha = 0.8f;
    _progress.labelText = @"正在上传";
    _progress.detailsLabelText = [NSString stringWithFormat:@"%d/%ld",1,_assets.count];
    [self pickerAlbumWithIndex:0];
    
}


- (void)pickerAlbumWithIndex:(NSUInteger)index
{
    if (_assets.count >0) {
        
        ALAsset *asset = [_assets objectAtIndex:index];
        
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                     scale:asset.defaultRepresentation.scale
                               orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        CGSize size = CGSizeZero;
        if (image.size.height > 1280 || image.size.width > 1280)
        {
            if (image.size.height > 1280 && image.size.height > image.size.width)
            {
                size = CGSizeMake(image.size.width *(1280/image.size.height), 1280);
            }
            if (image.size.width > 1280 && image.size.width > image.size.height)
            {
                size = CGSizeMake(1280, image.size.height *(1280/image.size.width));
            }
        }else{
            size = image.size;
        }
        
        if (!size.height && !size.width) {
            [self saveCoverImage:[self thumbnailForAsset:asset maxPixelSize:640.0f] index:index];
        }else{
            UIImage *newImage = [MZPublishViewController imageWithImageSimple:image scaledToSize:size];
            [self saveCoverImage:newImage index:index];
        }
    }
}

- (BOOL)saveCoverImage:(UIImage *)coverImage index:(NSUInteger)index
{
    NSData *data = UIImagePNGRepresentation(coverImage);
    if (UIImageJPEGRepresentation(coverImage,1.0) != nil)
    {
        data = UIImageJPEGRepresentation(coverImage, 0.5f);
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"发生错误" message:@"图片读取出错" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    if([fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil]){
        if ([fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil]) {
            
        }else{
            return FALSE;
        }
    }else{
        return FALSE;
    }
    //得到选择后沙盒中图片的完整路径
     NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/image.png"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@:%@/%@",kHost,kPort,kDoUpload];
    
    MZDoUploadParam *doUploadParam = [[MZDoUploadParam alloc]init];
    doUploadParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    doUploadParam.album_id = self.album_id;
//    if ([userdefaultsDefine objectForKey:@"way"]) {
//        if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"1"]) {
//            doUploadParam.way = phoneNumType;
//        }
//        if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
//            doUploadParam.way = wxType;
//        }
//    }
    if (index == 0) {
        doUploadParam.code = @"1";
        doUploadParam.issue_id = @"0";
    }else{
        doUploadParam.code = @"2";
        doUploadParam.issue_id = [userdefaultsDefine objectForKey:@"issue_id"];
    }
    doUploadParam.position = [NSString stringWithFormat:@"%ld",index+1];
    
    NSDictionary *dict =[doUploadParam bindRequestParam];
    
    //在这里调用上传头像接口
    NSUInteger next = 0;//必须赋初值
    next = ++index;//index最开始的时候等于0,然后自增,递归调用
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:@"photo"
                                fileName:filePath
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MZModel *model = [MZModel objectWithKeyValues:responseObject];
        if (model.issue_id) {
            [userdefaultsDefine setObject:model.issue_id forKey:@"issue_id"];
        }
        
        [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];
        if (index == _assets.count) {
            [_progress removeFromSuperview];
            // 马上进入刷新状态
            [self dismissViewControllerAnimated:YES completion:nil];
            [userdefaultsDefine setObject:@"publish" forKey:@"publish"];
            return ;
        }
        [self pickerAlbumWithIndex:next];
        _progress.detailsLabelText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(index+1),_assets.count];
        _progress.progress = (float)(index+1)/(float)_assets.count;
        NSLog(@"_progress.progress == %f",_progress.progress);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_progress removeFromSuperview];
        NSLog(@"Error: %@", error);
        NSLog(@"operation.response.statusCode: %ld",operation.response.statusCode);
        NSLog(@"operation:%@",operation.responseString);
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"上传失败,请稍后再试" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alerView show];
        
    }];
    
    return TRUE;
    
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




- (void)setAssets:(NSMutableArray *)assets
{
    _assets = assets;
    
//    NSUInteger heightOfNumber;
//    if (_assets.count<4) {
//        heightOfNumber = 1;
//    }else if (_assets.count > 3 && _assets.count <8){
//        heightOfNumber = 2;
//    }else{
//        heightOfNumber = 3;
//    }
//    
//    _collectionView.frame = rect(0, 64.0f, SCREEN_WIDTH, heightOfNumber * 75 +10);
    [_collectionView reloadData];
}


#pragma mark -------- UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_assets.count == 9) {
        return _assets.count;
    }else{
        return _assets.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_assets.count == 9) {
        MZPublishCollectionViewCell* publishCell =  [collectionView dequeueReusableCellWithReuseIdentifier:publishCellIdentifier forIndexPath:indexPath];
        publishCell.delegate = self;
        ALAsset *asset = [_assets objectAtIndex:indexPath.row];
        publishCell.photoImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        publishCell.removeButton.tag = indexPath.row;
        return publishCell;

    }else{
        if (_assets.count > 0 && indexPath.row <_assets.count) {
            MZPublishCollectionViewCell* publishCell =  [collectionView dequeueReusableCellWithReuseIdentifier:publishCellIdentifier forIndexPath:indexPath];
            ALAsset *asset = [_assets objectAtIndex:indexPath.row];
            publishCell.photoImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
            publishCell.removeButton.tag = indexPath.row;
            publishCell.delegate = self;
            return publishCell;
        }else{
            MZAddCollectionViewCell* cell =  [collectionView dequeueReusableCellWithReuseIdentifier:addCellIdentifier forIndexPath:indexPath];
            return cell;
        }

    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70.0f-5, 70.0f-5);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0.25, 0.25, 0.25, 0.25);
//}

//设置尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(AddImageOfHeight,AddImageOfHeight);
//}

//行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
//Cell之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 20;
//}


//定义每个UICollectionView 的 margin(上,左,下,右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0f,10.0f,10.0f,10.0f);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//     CTAssetsPageViewController *vc = [[CTAssetsPageViewController alloc] initWithAssets:_assets];
    
    MOKOPictureBrowsingViewController *pictureBrowsingViewController = [[MOKOPictureBrowsingViewController alloc]initWithHidden:YES];
    pictureBrowsingViewController.imagesArray =_assets;
    if (_assets.count == 9) {
//        vc.pageIndex = indexPath.row;
//        [self presentViewController:vc animated:YES completion:nil];
        pictureBrowsingViewController.indexNumber = indexPath.row;
        [self  presentViewController:pictureBrowsingViewController animated:YES completion:^{}];
    }else{
        if (_assets.count > 0 && indexPath.row <_assets.count) {
//            vc.pageIndex = indexPath.row;
//            [self presentViewController:vc animated:YES completion:nil];
            pictureBrowsingViewController.indexNumber = indexPath.row;
            [self  presentViewController:pictureBrowsingViewController animated:YES completion:^{}];
            NSLog(@"fndjfljfljeflj");
        }else{
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.delegate = self;
            picker.selectedAssets = [NSMutableArray arrayWithArray:_assets];
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
  
}

//行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 3.5;
//}
////Cell之前的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1.5;
//}


#pragma mark -------- MZPublishCollectionViewCellDelegate

- (void)clickRemoveButtonAction:(UIButton *)button
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"确认删除这张图片吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = button.tag;
    [alertView show];
}

#pragma mark ------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ALAsset *asset = [_assets objectAtIndex:alertView.tag];
        [_assets removeObject:asset];
        [_collectionView reloadData];
    }
}

#pragma mark - Assets Picker Delegate 相册的代理方法
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

/**
 *  用户从相册选择了照片或者选择了视频就可以发布动态了：
 *
 *  @param picker 选择器
 *  @param assets 照片或视频
 */
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
    //这样写出现重复的
    //        [_assets addObjectsFromArray:assets];
    _assets = [NSMutableArray arrayWithArray:assets];
    [_collectionView reloadData];
}

/**
 *  控制选的个数
 *
 *  @param picker 选择器
 *  @param asset  图片或者视频
 *
 *  @return 选的个数
 */
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    //控制选择照片的个数
    return (picker.selectedAssets.count < 9 && asset.defaultRepresentation != nil);
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
