//
//  MZNewMessageButton.h
//  MZTuShenMa
//
//  Created by Wangxin on 15/9/15.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZNewMessageButtonDelegate <NSObject>

- (void) newMessageButtonTouchUpInside:(id)sender;

@end

@interface MZNewMessageButton : UIImageView

@property (nonatomic, assign) id <MZNewMessageButtonDelegate> delegate;

- (void) show;

- (void) dismiss;


@end
