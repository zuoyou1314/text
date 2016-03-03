//
//  MZExitAlbumView.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MZExitAlbumViewDelegate <NSObject>

- (void)clickExitAlbumButtonEvent;

@end

@interface MZExitAlbumView : UIView

@property (nonatomic,assign) id<MZExitAlbumViewDelegate>delegate;

- (void)show;

@end
