//
//  MOKOPictureBrowsingCollectionViewCell.h
//  MOKODreamWork_iOS2
//
//  Created by _SS on 15/7/23.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZShareView.h"
typedef void(^LongPressImageBlock)(void);
@interface MOKOPictureBrowsingCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) LongPressImageBlock longPressImageBlock;
/**
 *  发布图片内容url
 */
@property (nonatomic, strong) NSString *imageurl;
/**
 *  照片的id
 */
@property (nonatomic, copy) NSString *photoId;
/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  点击第几张图片推出来次浏览页面
 */
@property (nonatomic, assign) NSUInteger indexNumber;
/**
 *  自定义collectionviewcell里含有的imageView
 */
@property (nonatomic, strong) UIImageView *imageView;




- (void)setImage:(UIImage *)image;


@end
