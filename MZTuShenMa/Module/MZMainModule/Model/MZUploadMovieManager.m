//
//  MZUploadMovieManager.m
//  MZTuShenMa
//
//  Created by zuo on 16/1/17.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZUploadMovieManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MZRequestManger+User.h"
#import "MZUploadMovieParam.h"
#import "OKNetworkingManager.h"
#import "MZLaunchManager.h"
@implementation MZUploadMovieManager

static MZUploadMovieManager *uploadManager = nil;

+ (MZUploadMovieManager *)manager
{
    @synchronized(self) {
        if (uploadManager == nil) {
            uploadManager = [[MZUploadMovieManager alloc]init];
        }
    }
    return uploadManager;
}

//上传图片
- (void)uploadPhotoWithModel:(MZUploadMovieModel *)model
{
    /**
     *  加载一个正在上传的菊花
     */
    _progress = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    _progress.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _progress.alpha = 0.8f;
    _progress.labelText = @"正在上传";
//    _progress.detailsLabelText = 1/2;
    
    UIImage *image = [self thumbnailImageForVideo:model.mp4Url];
    
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

    UIImage *newImage = [MZUploadMovieManager imageWithImageSimple:image scaledToSize:size];
    [self saveCoverImage:newImage movieModel:model];

}


- (BOOL)saveCoverImage:(UIImage *)coverImage movieModel:(MZUploadMovieModel *)movieModel
{
    NSData *photoData = UIImagePNGRepresentation(coverImage);
    if (UIImageJPEGRepresentation(coverImage,1.0) != nil)
    {
        photoData = UIImageJPEGRepresentation(coverImage, 0.5f);
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"发生错误" message:@"图片读取出错" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
    
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    if([fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil]){
        if ([fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:photoData attributes:nil]) {
            
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    //得到选择后沙盒中图片的完整路径
    NSString *photoFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/image.png"];

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //如果报接受类型不一致请替换一致text/html
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSString *url = [NSString stringWithFormat:@"%@:%@/%@",kHost,kPort,kDoUpload];
//    
//    MZDoUploadParam *doUploadParam = [[MZDoUploadParam alloc]init];
//    doUploadParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
//    doUploadParam.album_id = movieModel.album_id;
//    doUploadParam.type = movieModel.type;
//    doUploadParam.code = @"1";
//    doUploadParam.issue_id = @"0";
//
//    NSDictionary *dict =[doUploadParam bindRequestParam];
//    
//    NSLog(@"图片dict == %@",dict);
//    
//    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:photoData
//                                    name:@"photo"
//                                fileName:photoFilePath
//                                mimeType:@"image/png"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dic = [responseObject objectForKey:@"responseData"];
//        _progress.detailsLabelText = @"1/2";
//        _progress.progress = (float)1/(float)2;
//        NSLog(@"_progress.progress == %f",_progress.progress);
//        [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];
//    
//        [self uploadMovieWithPhotoId:[dic objectForKey:@"photo_id"] movieModel:movieModel];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_progress removeFromSuperview];
//        NSLog(@"Error: %@", error);
//        NSLog(@"operation.response.statusCode: %ld",operation.response.statusCode);
//        NSLog(@"operation:%@",operation.responseString);
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"上传失败,请稍后再试" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alerView show];
//        
//    }];
//    
//    return YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@:%@/%@",kHost,kPort,kMp4Api];
    
    MZUploadMovieParam *uploadMovieParam = [[MZUploadMovieParam alloc]init];
    uploadMovieParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
//    uploadMovieParam.photo_id = photoId;
    uploadMovieParam.album_id = movieModel.album_id;
    uploadMovieParam.type = movieModel.type;
    
    uploadMovieParam.upload_type =movieModel.upload_type;
    
    NSData *data = [NSData dataWithContentsOfURL:movieModel.mp4Url];
    
    NSDictionary *dict =[uploadMovieParam bindRequestParam];
    NSLog(@"一起传参数dict == %@",dict);
    
    
    if ([OKNetworkingManager sharedInstance].netStatus == OKNetworkStatusViaWWAN) {
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _progress.detailsLabelText = @"2/2";
            _progress.progress = (float)2/(float)2;
            NSLog(@"_progress.progress == %f",_progress.progress);
        });
    }
//    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/video.mp4"];
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:photoData
                                    name:@"photo"
                                fileName:photoFilePath
                                mimeType:@"image/png"];
        [formData appendPartWithFileData:data
                                    name:@"video"
                                fileName:filePath
                                mimeType:@"video/mp4"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
        
        if ([response.errMsg isEqualToString:@"账号冻结"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号被冻结了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return ;
        }

        
        
        
        if ([OKNetworkingManager sharedInstance].netStatus == OKNetworkStatusViaWWAN) {
            
        }else{
              [_progress removeFromSuperview];
        }
        _uploadBlocks();
        [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_progress removeFromSuperview];
        NSLog(@"Error: %@", error);
        NSLog(@"operation.response.statusCode: %ld",operation.response.statusCode);
        NSLog(@"operation:%@",operation.responseString);
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"上传失败,请稍后再试" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alerView show];
        
    }];

    return YES;
}


//上传视频
//- (void)uploadMovieWithPhotoId:(NSString *)photoId movieModel:(MZUploadMovieModel *)movieModel
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //如果报接受类型不一致请替换一致text/html
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSString *url = [NSString stringWithFormat:@"%@:%@/%@",kHost,kPort,kMp4Api];
//    
//    MZUploadMovieParam *uploadMovieParam = [[MZUploadMovieParam alloc]init];
//    uploadMovieParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
//    uploadMovieParam.photo_id = photoId;
//
//    NSData *data = [NSData dataWithContentsOfURL:movieModel.mp4Url];
//    
//    NSDictionary *dict =[uploadMovieParam bindRequestParam];
//    
//    NSLog(@"视频dict == %@",dict);
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _progress.detailsLabelText = @"2/2";
//        _progress.progress = (float)2/(float)2;
//        NSLog(@"_progress.progress == %f",_progress.progress);
//    });
//    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/video.mp4"];
//    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data
//                                    name:@"video"
//                                fileName:filePath
//                                mimeType:@"video/mp4"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [_progress removeFromSuperview];
//        _uploadBlocks();
//        [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_progress removeFromSuperview];
//        NSLog(@"Error: %@", error);
//        NSLog(@"operation.response.statusCode: %ld",operation.response.statusCode);
//        NSLog(@"operation:%@",operation.responseString);
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"上传失败,请稍后再试" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alerView show];
//        
//    }];
//}




//获取视频封面，本地视频，网络视频都可以用
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    
    return thumbImg;
    
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

//打印
-(void)logInfoSuccessStatusCode:(NSInteger)statusCode responseObject:(id)responseObject responseString:(NSString*)responseString
{
    NSLog(@"请求状态: %@",@"success");
    NSLog(@"状态码: %ld",(long)statusCode);
    NSLog(@"请求响应结果: %@",responseObject);
    NSLog(@"请求响应结果: %@",responseString);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //退出登录
        MZQuitLoginParam *quitLoginParam = [[MZQuitLoginParam alloc]init];
        quitLoginParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
        [MZRequestManger quitLoginRequest:quitLoginParam success:^(NSDictionary *object) {
            
        } failure:^(NSString *errMsg, NSString *errCode) {
            
        }];
        [[MZLaunchManager manager] logoutScreen];
        [[MZLaunchManager manager] logout];
    }
}

@end
