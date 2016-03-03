//
//  MZNoDeleteFriendView.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/23.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZNoDeleteFriendViewDelegate <NSObject>


- (void)clickReportButtonAction;

@end

@interface MZNoDeleteFriendView : UIView

@property (nonatomic,assign) id<MZNoDeleteFriendViewDelegate>delegate;

- (void)show;

@end
