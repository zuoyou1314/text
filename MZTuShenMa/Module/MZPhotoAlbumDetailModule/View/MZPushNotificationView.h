//
//  MZPushNotificationView.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZPushNotificationViewDelegate <NSObject>

- (void)clickPushSkitch:(UISwitch *)pushSwitch;

@end


@interface MZPushNotificationView : UIView
@property (weak, nonatomic) IBOutlet UISwitch *pushSwitch;

@property (nonatomic, assign) id<MZPushNotificationViewDelegate>delegate;

@end
