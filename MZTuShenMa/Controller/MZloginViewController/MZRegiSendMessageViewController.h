//
//  MZRegiSendMessageViewController.h
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"
typedef NS_ENUM(NSUInteger, MZSendMessageType) {
    MZSendMessageTypeRegister=0,
    MZSendMessageTypePassword=1
};

@interface MZRegiSendMessageViewController : MZBaseViewController

@property (nonatomic,assign) MZSendMessageType type;
@property (nonatomic,copy) NSString *messageCodeString;



@end
