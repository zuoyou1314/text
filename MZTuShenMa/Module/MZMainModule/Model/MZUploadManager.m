//
//  MZUploadManager.m
//  MZTuShenMa
//
//  Created by zuo on 15/12/14.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZUploadManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MZRequestManger+User.h"
#import "MJExtension.h"
#import <ImageIO/ImageIO.h>
#import "MZLaunchManager.h"
@implementation MZUploadManager

static MZUploadManager *uploadManager = nil;

+ (MZUploadManager *)manager
{
    @synchronized(self) {
        if (uploadManager == nil) {
            uploadManager = [[MZUploadManager alloc]init];
        }
    }
    return uploadManager;
}


//上传图片
- (void)uploadPhotoswithModel:(MZUploadSoundModel *)model
{
    /**
     *  加载一个正在上传的菊花
     */
    _progress = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    _progress.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _progress.alpha = 0.8f;
    _progress.labelText = @"正在上传";
    _progress.detailsLabelText = [NSString stringWithFormat:@"%d/%ld",1,model.assets.count];
    
    [_photoNumArray removeAllObjects];
    _photoNumArray = nil;
    _photoNumArray = [NSMutableArray arrayWithCapacity:9];
    [self pickerAlbumWithIndex:0 model:model];
}

//上传音
- (void)uploadSoundWithIssue_id:(NSString *)issue_id model:(MZUploadSoundModel *)model
{
    [self sendRequestWithIndex:0 issue_id:issue_id model:model];
}

//根据图片数量递归循环上传
- (void)sendRequestWithIndex:(NSUInteger)index issue_id:(NSString *)issue_id model:(MZUploadSoundModel *)model
{
    [self loopUploadSoundWithTag:0 Index:index issue_id:issue_id model:model];
}

/**
 *  根据一张图片录音数量递归循环上传
 *
 *  @param tag      当前上传第几个录音
 *  @param index    当前上传第几张照片
 *  @param issue_id 发布id
 *  @param model    存放资源的model
 */
- (void)loopUploadSoundWithTag:(NSUInteger)tag Index:(NSUInteger)index issue_id:(NSString *)issue_id model:(MZUploadSoundModel *)model
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@:%@/%@",kHost,kPort,kUploadSpeech];
    MZUploadSpeechParam *uploadSpeechParam = [[MZUploadSpeechParam alloc]init];
//    uploadSpeechParam.issue_id = issue_id;
//    uploadSpeechParam.photo_num = [_photoNumArray objectAtIndex:index];
    uploadSpeechParam.photo_id = [_photoNumArray objectAtIndex:index];
    NSArray *photoArray = [model.photoDic objectForKey:[NSString stringWithFormat:@"%ld",index]];
    
    if (photoArray.count > 0) {
        NSDictionary *dic = [photoArray objectAtIndex:tag];
        if ([[dic allKeys]containsObject:@"one"]) {
            NSArray *locationArray = [dic objectForKey:@"one"];
            uploadSpeechParam.coords_x = [locationArray objectAtIndex:0];
            uploadSpeechParam.coords_y = [locationArray objectAtIndex:1];
        }
        if ([[dic allKeys]containsObject:@"two"]) {
            NSArray *locationArray = [dic objectForKey:@"two"];
            uploadSpeechParam.coords_x = [locationArray objectAtIndex:0];
            uploadSpeechParam.coords_y = [locationArray objectAtIndex:1];
        }
        
        if ([[dic allKeys]containsObject:@"three"]) {
            NSArray *locationArray = [dic objectForKey:@"three"];
            uploadSpeechParam.coords_x = [locationArray objectAtIndex:0];
            uploadSpeechParam.coords_y = [locationArray objectAtIndex:1];
        }
        
        if ([[dic allKeys]containsObject:@"four"]) {
            NSArray *locationArray = [dic objectForKey:@"four"];
            uploadSpeechParam.coords_x = [locationArray objectAtIndex:0];
            uploadSpeechParam.coords_y = [locationArray objectAtIndex:1];
        }
        
        if ([[dic allKeys]containsObject:@"five"]) {
            NSArray *locationArray = [dic objectForKey:@"five"];
            uploadSpeechParam.coords_x = [locationArray objectAtIndex:0];
            uploadSpeechParam.coords_y = [locationArray objectAtIndex:1];
        }

    }
    
    NSArray *timeArray = [model.timeDic objectForKey:[NSString stringWithFormat:@"%ld",index]];
    if (timeArray.count > 0) {
        uploadSpeechParam.track = [timeArray objectAtIndex:tag];
    }
    
    NSArray *dataArray = [model.recordDic objectForKey:[NSString stringWithFormat:@"%ld",index]];
    
    NSData *data;
    if (dataArray.count > 0) {
        data = [NSData dataWithContentsOfURL:[dataArray objectAtIndex:tag]];
    }
    
//    NSString *fileName =[[dataArray objectAtIndex:tag] absoluteString];
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/audio.mp3"];
    
    if (dataArray.count == 0) {
        NSUInteger fag = 0;//必须赋初值
        fag = ++index;//index最开始的时候等于0,然后自增,递归调用
        if (fag == model.assets.count) {
            [_progress removeFromSuperview];
            _uploadBlocks();
            return;
        }
        [self sendRequestWithIndex:fag issue_id:issue_id model:model];
        _progress.detailsLabelText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(fag+1),model.assets.count];
        _progress.progress = (float)(fag+1)/(float)model.assets.count;
        NSLog(@"_progress.progress == %f",_progress.progress);
    }else{
         NSDictionary *dict =[uploadSpeechParam bindRequestParam];
        //在这里调用上传头像接口
        __block __typeof(index) weakIndex = index;
        NSUInteger next = 0;//必须赋初值
        next = ++tag;//index最开始的时候等于0,然后自增,递归调用
        [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data
                                        name:@"speech"
                                    fileName:filePath
                                    mimeType:@"audio/mpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];
            
            if (tag == dataArray.count) {
                NSUInteger next = 0;//必须赋初值
                next = ++weakIndex;//index最开始的时候等于0,然后自增,递归调用
                if (weakIndex == model.assets.count) {
                     [_progress removeFromSuperview];
                    // 马上进入刷新状态
//                                [self dismissViewControllerAnimated:YES completion:nil];
//                                [userdefaultsDefine setObject:@"publish" forKey:@"publish"];
                    _uploadBlocks();
                    return ;
                }
                [self sendRequestWithIndex:next issue_id:issue_id model:model];
                _progress.detailsLabelText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(next+1),model.assets.count];
                _progress.progress = (float)(next+1)/(float)model.assets.count;
                NSLog(@"_progress.progress == %f",_progress.progress);
                return ;
            }
            
            [self loopUploadSoundWithTag:next Index:index issue_id:issue_id model:model];
//            _progress.detailsLabelText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(next+1),model.assets.count];
//            _progress.progress = (float)(next+1)/(float)model.assets.count;
//            NSLog(@"_progress.progress == %f",_progress.progress);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_progress removeFromSuperview];
            NSLog(@"Error: %@", error);
            NSLog(@"operation.response.statusCode: %ld",operation.response.statusCode);
            NSLog(@"operation:%@",operation.responseString);
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"上传失败,请稍后再试" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alerView show];
            
        }];
    }
    

}

- (void)pickerAlbumWithIndex:(NSUInteger)index model:(MZUploadSoundModel *)model
{
    if (model.assets.count >0) {
        
//        ALAsset *asset = [model.assets objectAtIndex:index];
//        
//        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
//                                             scale:asset.defaultRepresentation.scale
//                                       orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
//        if ([model.assets isKindOfClass:[UIImage class]]) {
        
            UIImage *image = [model.assets objectAtIndex:index];
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
                
                if (image.size.height > 1280 && image.size.width > 1280 && image.size.height == image.size.width)
                {
                    size = CGSizeMake(image.size.width *(1280/image.size.height), 1280);
                }
                
            }else{
                size = image.size;
            }
            
            //        if (!size.height && !size.width) {
            //            [self saveCoverImage:[self thumbnailForAsset:asset maxPixelSize:640.0f] index:index soundModel:model];
            //        }else{
            UIImage *newImage = [MZUploadManager imageWithImageSimple:image scaledToSize:size];
            [self saveCoverImage:newImage index:index soundModel:model];
            //        }
//        }

    }
}

- (BOOL)saveCoverImage:(UIImage *)coverImage index:(NSUInteger)index soundModel:(MZUploadSoundModel *)soundModel
{
    NSData *data = UIImagePNGRepresentation(coverImage);
    if (UIImageJPEGRepresentation(coverImage,1.0) != nil)
    {
        data = UIImageJPEGRepresentation(coverImage, 0.5f);
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
        if ([fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil]) {
            
        }else{
            return NO;
        }
    }else{
        return NO;
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
    doUploadParam.album_id = soundModel.album_id;
    doUploadParam.type = soundModel.type;
    doUploadParam.upload_type = soundModel.upload_type;
    
    NSLog(@"doUploadParam.upload_type == %@",doUploadParam.upload_type);
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
//    doUploadParam.position = [NSString stringWithFormat:@"%ld",index+1];
//    NSLog(@"doUploadParam.position == %@",doUploadParam.position);
    
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
        
        MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
        
        if ([response.errMsg isEqualToString:@"账号冻结"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号被冻结了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return ;
        }

        
        
        NSDictionary *dic = [responseObject objectForKey:@"responseData"];
        if ([dic objectForKey:@"issue_id"]) {
            [userdefaultsDefine setObject:[dic objectForKey:@"issue_id"] forKey:@"issue_id"];
        }
        
        [_photoNumArray addObject:[dic objectForKey:@"photo_id"]];
//
        [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];

        if (index == soundModel.assets.count) {
            // 马上进入刷新状态
//            [self dismissViewControllerAnimated:YES completion:nil];
//            [userdefaultsDefine setObject:@"publish" forKey:@"publish"];
            [self uploadSoundWithIssue_id:[userdefaultsDefine objectForKey:@"issue_id"] model:soundModel];
            return ;
        }
        [self pickerAlbumWithIndex:next model:soundModel];
        
        _progress.detailsLabelText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)(next+1),soundModel.assets.count];
        _progress.progress = (float)(next+1)/(float)soundModel.assets.count;
        NSLog(@"_progress.progress == %f",_progress.progress);
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




#pragma mark ---- 压缩图片
static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count) {
    ALAssetRepresentation *rep = (__bridge id)info;
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        NSLog(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }
    return countRead;
}
static void releaseAssetCallback(void *info) {
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}
- (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size
{
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    CGDataProviderDirectCallbacks callbacks =
    {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)
                                                              @{   (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                   (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:size],
                                                                   (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                   });
    CFRelease(source);
    CFRelease(provider);
    if (!imageRef) {
        return nil;
    }
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return toReturn;
}
#pragma end ---- 压缩图片
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
