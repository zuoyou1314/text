//
//  MZArowView.m
//  MZTuShenMa
//
//  Created by zuo on 15/12/4.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZArowView.h"
#import <AVFoundation/AVFoundation.h>

@interface MZArowView ()<AVAudioPlayerDelegate,STKAudioPlayerDelegate>
{
    NSTimer *_lightTimer;
    STKAudioPlayer *_audioPlayer;
}
@end


@implementation MZArowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    
    _leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftArrowButton.frame = rect(0, 0, 112/2, 50/2);
    [_leftArrowButton setImage:[UIImage imageNamed:@"recording_leftArrow"] forState:UIControlStateNormal];
    [_leftArrowButton setTitle:@"13" forState:UIControlStateNormal];
    [_leftArrowButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-50,0,0)];
    [_leftArrowButton setTitleColor:RGB(52, 204, 228) forState:UIControlStateNormal];
    _leftArrowButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_leftArrowButton addTarget:self action:@selector(didClickArrowViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftArrowButton];
    
    
    _rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightArrowButton.frame = rect(56+8, 0, 112/2, 50/2);
    [_rightArrowButton setImage:[UIImage imageNamed:@"recording_rightArrow"] forState:UIControlStateNormal];
    [_rightArrowButton setTitle:@"13" forState:UIControlStateNormal];
    [_rightArrowButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-60,0,0)];
    [_rightArrowButton setTitleColor:RGB(52, 204, 228) forState:UIControlStateNormal];
    _rightArrowButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_rightArrowButton addTarget:self action:@selector(didClickArrowViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightArrowButton];
    
    _lightImageView = [[UIImageView alloc]initWithFrame:rect(51, _rightArrowButton.center.y-8, 17, 17)];
    _lightImageView.image = [UIImage imageNamed:@"recording_normal"];
    
//    _lightImageView.layer.cornerRadius = _lightImageView.frame.size.width / 2;
//    _lightView.backgroundColor = [UIColor whiteColor];
//    _lightView.clipsToBounds = YES;
//    _lightView.layer.borderWidth = 1.5f;
//    _lightView.layer.borderColor = [UIColor grayColor].CGColor;
//    //阴影的颜色
//    _lightView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    _lightView.layer.shadowOffset = CGSizeMake(0, 0);
//    //阴影透明度
//    _lightView.layer.shadowOpacity = 2.0;
//    //阴影圆角度数
//    _lightView.layer.shadowRadius = 10.0;
    
    [self addSubview:_lightImageView];
    
    
    
   
}

// 临近手机消息触发
- (void) proximityChanged:(NSNotification *)notification {
    //--------------------------------------------------------------
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"接近耳朵");
        //设置从听筒不放,状态设置成播放和录音
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else//没黑屏幕
    {
        NSLog(@"不接近耳朵");
        //设置扬声器播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        if (![player isPlaying]) {//没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
        //
        //            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        //
        //        }
    }
    //-------------------------------------------------------------------------------
}




- (void)setSpeechPathUrl:(NSURL *)speechPathUrl
{
    _speechPathUrl = speechPathUrl;
}


- (void)didClickArrowViewAction:(UIButton *)button
{
    NSLog(@"------------------------播放------------------------------");
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    BOOL proximityState = [[UIDevice currentDevice]proximityState];
    NSLog(@"++++++++%d",proximityState);
    UIDevice *device = [UIDevice currentDevice];
    device.proximityMonitoringEnabled=YES; // 允许临近检测
    if (device.proximityMonitoringEnabled == YES) {
        // 临近消息触发
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(proximityChanged:)
         
                                                     name:UIDeviceProximityStateDidChangeNotification object:device];
        
    }

    
//    if (self.type == MZArowViewTypePublicAlbum) {
        _arowViewBeganBlocks();
//    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    _audioPlayer = [[STKAudioPlayer alloc] init];
    _audioPlayer.delegate = self;
    [_audioPlayer playURL:_speechPathUrl];
    
    
}

- (void)stopPlay
{
    if (_audioPlayer.state == STKAudioPlayerStatePlaying) {
        [_audioPlayer stop];
//        [_lightTimer invalidate];
//        _lightTimer = nil;
//        _lightImageView.image = [UIImage imageNamed:@"recording_normal"];
//        [_leftArrowButton setImage:[UIImage imageNamed:@"recording_leftArrow"] forState:UIControlStateNormal];
//        [_rightArrowButton setImage:[UIImage imageNamed:@"recording_rightArrow"] forState:UIControlStateNormal];
    }
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}




- (void)changeLightStatus
{
    _lightImageView.image = [UIImage imageNamed:@"recording_normal"];
    [_leftArrowButton setImage:[UIImage imageNamed:@"recording_leftArrow"] forState:UIControlStateNormal];
    [_rightArrowButton setImage:[UIImage imageNamed:@"recording_rightArrow"] forState:UIControlStateNormal];
    _lightImageView.alpha = 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        [_leftArrowButton setImage:[UIImage imageNamed:@"recording_rightArrow_press"] forState:UIControlStateNormal];
        [_rightArrowButton setImage:[UIImage imageNamed:@"recording_leftArrow_press"] forState:UIControlStateNormal];
        _lightImageView.image = [UIImage imageNamed:@"recording_Highlighted"];
        _lightImageView.alpha = 1.0f;
    }];
}



#pragma mark streamingKti代理方法
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId{
    NSLog(@"开始播放");
    _lightTimer=[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(changeLightStatus) userInfo:self repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_lightTimer forMode:NSDefaultRunLoopMode];
    [_lightTimer fire];
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    NSLog(@"状态改变%u",previousState);
    if (previousState == STKAudioPlayerStateStopped ) {
//        [_lightTimer invalidate];
//        _lightTimer = nil;
//        _lightImageView.image = [UIImage imageNamed:@"recording_normal"];
//        [_leftArrowButton setImage:[UIImage imageNamed:@"recording_leftArrow"] forState:UIControlStateNormal];
//        [_rightArrowButton setImage:[UIImage imageNamed:@"recording_rightArrow"] forState:UIControlStateNormal];
    }
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems{
    NSLog(@"未知%@",queuedItems);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId{
    NSLog(@"完成加载");
//    [_lightTimer invalidate];
//    _lightTimer = nil;
//    _lightImageView.image = [UIImage imageNamed:@"recording_normal"];
//    [_leftArrowButton setImage:[UIImage imageNamed:@"recording_leftArrow"] forState:UIControlStateNormal];
//    [_rightArrowButton setImage:[UIImage imageNamed:@"recording_rightArrow"] forState:UIControlStateNormal];
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line{
    NSLog(@"信息%@",line);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    NSLog(@"%u错误",errorCode);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    NSLog(@"结束播放");
//    if (self.type == MZArowViewTypePublicAlbum) {
        _arowViewOverBlocks();
//    }
    [_lightTimer invalidate];
    _lightTimer = nil;
    _lightImageView.image = [UIImage imageNamed:@"recording_normal"];
    [_leftArrowButton setImage:[UIImage imageNamed:@"recording_leftArrow"] forState:UIControlStateNormal];
    [_rightArrowButton setImage:[UIImage imageNamed:@"recording_rightArrow"] forState:UIControlStateNormal];
    
    
    //删除近距离事件监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
        
    }
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
}

@end
