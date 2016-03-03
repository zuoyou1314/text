//
//  MZDrawerVIew.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/29.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZDrawerViewDelegate <NSObject>

@required

- (void)didClickHeadImageAction:(UIImageView *)headImage user_img:(NSString *)user_img  user_name:(NSString *)user_name sex:(NSString *)sex;

- (void)didClickCellWithRow:(NSInteger)row;



@end



@interface MZDrawerView : UIView

@property (nonatomic,weak) id<MZDrawerViewDelegate>drawerDelegate;

- (void)show;

@end
