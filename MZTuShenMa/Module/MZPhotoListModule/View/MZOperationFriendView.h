//
//  MZOperationFriendView.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZOperationFriendViewDelegate <NSObject>

- (void)clickRemoveFriendButtonAction;

- (void)clickReportButtonAction;

@end

@interface MZOperationFriendView : UIView

@property (nonatomic,assign) id<MZOperationFriendViewDelegate>delegate;

- (void)show;

@end
