//
//  MZMoreView.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/14.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZMoreViewDelegate <NSObject>

- (void)clickReportButtonAction;

- (void)clickRemoveButtonAction;

@end

@interface MZMoreView : UIView

@property (nonatomic,assign) id<MZMoreViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *removeLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;


- (void)show;



@end
