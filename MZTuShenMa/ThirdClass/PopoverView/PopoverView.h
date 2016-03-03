//
//  PopoverView.h
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol PopoverViewDelegate;

@interface PopoverView : UIView

// 一般使用以下两个方法即可
-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles imageNames:(NSArray *)images highlitedImages:(NSArray *)highlitedImages;
-(void)show;

// 如下两个方法一般不会用到
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, assign) id<PopoverViewDelegate> delegate;

@end

@protocol PopoverViewDelegate <NSObject>

- (void)didSelectedRowAtIndex:(NSInteger)index;

@end