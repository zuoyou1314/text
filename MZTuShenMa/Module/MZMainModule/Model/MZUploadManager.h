//
//  MZUploadManager.h
//  MZTuShenMa
//
//  Created by zuo on 15/12/14.
//  Copyright © 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZUploadSoundModel.h"
#import "MBProgressHUD.h"

typedef void(^uploadBlock)(void);
@interface MZUploadManager : NSObject<UIAlertViewDelegate>
{
    /**
     *  进度条
     */
    MBProgressHUD *_progress;
}

@property (nonatomic, copy) uploadBlock uploadBlocks;
/**
 *  照片标识
 */
@property (nonatomic, strong)NSMutableArray *photoNumArray;


+ (MZUploadManager *)manager;

//上传有声图片
- (void)uploadPhotoswithModel:(MZUploadSoundModel *)model;


@end
