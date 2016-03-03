//
//  MZUploadMovieManager.h
//  MZTuShenMa
//
//  Created by zuo on 16/1/17.
//  Copyright © 2016年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZUploadMovieModel.h"
//#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
typedef void(^uploadBlock)(void);

@interface MZUploadMovieManager : NSObject<UIAlertViewDelegate>
{
    /**
     *  进度条
     */
    MBProgressHUD *_progress;
}

@property (nonatomic, copy) uploadBlock uploadBlocks;

+ (MZUploadMovieManager *)manager;

//上传有声图片
- (void)uploadPhotoWithModel:(MZUploadMovieModel *)model;

@end
