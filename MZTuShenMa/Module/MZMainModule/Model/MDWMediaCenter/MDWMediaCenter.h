//
//  MDWMediaCenter.h
//  MM
//
//  Created by Justin Yuan on 15/1/23.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "STKAudioPlayer.h"

typedef void(^mediaCenterBlock)(void);

@interface MDWMediaCenter : NSObject 

+ (instancetype)defaultCenter;

@property (nonatomic,readonly) BOOL playing;

@property (nonatomic, copy) mediaCenterBlock mediaCenterBlocks;

@property (nonatomic, strong)MPMoviePlayerController *movieController;


- (void)playMovieByURL:(NSString *)url forView:(UIImageView *)source;

- (void)stopPlay;


//- (void)playSound:(NSString *)soundUrl forView:(UIImageView *)source;


@end
