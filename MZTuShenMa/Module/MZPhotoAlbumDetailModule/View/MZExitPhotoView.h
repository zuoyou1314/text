//
//  MZExitPhotoView.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZExitPhotoViewDelegate <NSObject>

- (void)clickExitButtonAction;

@end

@interface MZExitPhotoView : UIView

@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@property (nonatomic,assign) id<MZExitPhotoViewDelegate>delegate;

@end
