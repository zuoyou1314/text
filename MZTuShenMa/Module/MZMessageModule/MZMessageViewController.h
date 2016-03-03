//
//  MZMessageViewController.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/29.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"

@interface MZMessageViewController : MZBaseViewController

//分辨你是查新消息还是历史消息  0：新消息  1：历史消息
@property (nonatomic,copy) NSString *code;

@end
