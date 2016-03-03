//
//  MZShareView.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/14.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZShareViewDelegate <NSObject>

- (void)clickWechatButtonAction;

- (void)clickWechatFriendButtonAction;

@end

@interface MZShareView : UIView

@property (nonatomic,assign) id<MZShareViewDelegate>delegate;

- (void)show;

@end
