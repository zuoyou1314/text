//
//  MDWMediaCenter.m
//  MM
//
//  Created by Justin Yuan on 15/1/23.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import "MDWMediaCenter.h"
#import "UIView+MDWCategory.h"

@interface MDWMediaCenter()
{
    MPMoviePlayerController *_movieController;
    UIView *_playerMask;
    BOOL _playing;//是否正在播放
    STKAudioPlayer *_audioPlayer;
}

@end

@implementation MDWMediaCenter

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

+ (instancetype)defaultCenter
{
    static MDWMediaCenter *_defaultCenter;
    if (!_defaultCenter) {
        _defaultCenter = [[MDWMediaCenter alloc] init];
    }
    return _defaultCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
         _audioPlayer = [[STKAudioPlayer alloc] init];
        
        _movieController = [[MPMoviePlayerController alloc] initWithContentURL:nil];
        _movieController.controlStyle = MPMovieControlStyleNone;
        
        _playerMask = [[UIView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer *stoper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPlay)];
        [_playerMask addGestureRecognizer:stoper];
        
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
        
        //视频播放完成的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playingDone) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        //        _isPlay = NO;
        //        _playImage = [[UIImageView alloc]initWithFrame:[ToolViewAndData MyAutoLayoutWithFrame:rect(120, 70, 80, 80)]];
        //        _playImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bt_play.png"]];
        //        _playImage.frame = [ToolViewAndData MyAutoLayoutWithFrame:rect(120, 70, 80, 80)];
        //        _playImage.center = CGPointMake(_playerMask.frame.size.width / 2, _playerMask.frame.size.height / 2);;
        //        _playImage.center = _playerMask.center;
        //        _playImage.center = [_playerMask convertPoint:_playerMask.center fromView:_playerMask.superview];
        //        _playImage.hidden = YES;
        //        [_playerMask addSubview:_playImage];
        
    }
    return self;
}

#pragma mark - Public Functions

- (void)playMovieByURL:(NSString *)url forView:(UIImageView *)source
{
    [self playMovieByURL:url];
    _movieController.view.frame = source.bounds;
    [source addSubview:_movieController.view];
    
    _movieController.view.alpha = 0;
    [_movieController.view ShowView:_movieController.view During:1.75f delegate:nil];
    
    [self didStartPlayWithForView:source];

}

- (void)playMovieByURL:(NSString *)url
{
    [self stopPlay];

    _movieController.contentURL = [NSURL URLWithString:url];
    _movieController.scalingMode = MPMovieScalingModeAspectFill;
    [_movieController prepareToPlay];
    [_movieController play];

}

- (void)didStartPlayWithForView:(UIImageView *)source
{
    _playerMask.frame = source.bounds;
    [source addSubview:_playerMask];
    _playing = YES;
}

- (void)stopPlay
{
    [_movieController stop];
    
//    _movieController.view.superview.alpha = 0.2;
    [_movieController.view.superview ShowView:_movieController.view.superview During:0.75f delegate:nil];
    [_movieController.view removeFromSuperview];
    _movieController.contentURL = nil;

    [_playerMask removeFromSuperview];
    _playing = NO;

}

- (void)playSound:(NSString *)soundUrl forView:(UIImageView *)source
{
    [self stopPlay];
    [_audioPlayer play:soundUrl];
}


#pragma mark - Private Methods

#pragma mark - Properties Getter

- (BOOL)playing
{
    return _playing;
}

#pragma mark - Present Gallery


#pragma mark - MPMoviePlayerState

//- (void)moviePlayerStateChanged:(NSNotification *)notification
//{
//    switch (_movieController.playbackState) {
//        case MPMoviePlaybackStateStopped:
////        case MPMoviePlaybackStatePaused:
////        case MPMoviePlaybackStateInterrupted:
//            [self stopPlay];
//            break;
//        default:
//            break;
//    }
//}

/**
 *  播放完成
 */
-(void)playingDone
{
    NSLog(@"播放完成");
    [self stopPlay];
    _mediaCenterBlocks();
    
}


//-(void)playingDone
//{
//        [_movieController.view removeFromSuperview];
//        _movieController.contentURL = nil;
//        [_playerMask removeFromSuperview];
//        _playing = NO;
//}
@end
