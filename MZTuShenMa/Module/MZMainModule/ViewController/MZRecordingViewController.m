//
//  MZRecordingViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/11/30.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZRecordingViewController.h"
#import "MZPublishCollectionViewCell.h"
#import "MZAddCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "MZArowView.h"
#import "MZDoUploadParam.h"
#import "MZUploadSpeechParam.h"
#import "MZUploadSoundModel.h"
#import "MZUploadManager.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"

//存放音频以及视频
#define PATH_TO_SORE_MEDIA [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"]stringByAppendingPathComponent:@"RecordedFile"]
@interface MZRecordingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,ZLPhotoPickerViewControllerDelegate>
{
    BOOL _isFirstShow;//是否是第一次显示
    BOOL _firstIsSuccessful;//是否录制成功
    BOOL _secondIsSuccessful;//是否录制成功
    BOOL _thirdIsSuccessful;//是否录制成功
    BOOL _fourthIsSuccessful;//是否录制成功
    BOOL _fifthIsSuccessful;//是否录制成功
    NSIndexPath *_seleteIndexPath;
    /**
     *  录音路径
     */
    NSURL * _recordedFile;
    /**
     *  录音
     */
    AVAudioRecorder * _recorder;
    /**
     *  播放音频
     */
    AVAudioPlayer *_player;
    //录音时的起始位置
    CGPoint _firstLocation;
    
    CGFloat _firstX;
    CGFloat _firstY;
    NSMutableDictionary *_dic;
    CGPoint _tempPoint;
    CGPoint _updatePoint;
}
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) UIButton *photoButton;
//@property (strong, nonatomic) UIView *grayView;
//@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *grayButton;


@property (strong, nonatomic) MZArowView *firstArrowView;
@property (strong, nonatomic) MZArowView *secondArrowView;
@property (strong, nonatomic) MZArowView *thirdArrowView;
@property (strong, nonatomic) MZArowView *fourthArrowView;
@property (strong, nonatomic) MZArowView *fifthArrowView;

#pragma mark ---- model
@property (strong, nonatomic) NSMutableDictionary *photoDic;
@property (strong, nonatomic) NSMutableArray *photoArray;

@property (strong, nonatomic) NSMutableArray *recordArray;
@property (strong, nonatomic) NSMutableDictionary *fileDic;

@property (strong, nonatomic) NSMutableArray *timeArray;
@property (strong, nonatomic) NSMutableDictionary *timeDic;


@end

@implementation MZRecordingViewController


static NSString * const publishCellIdentifier = @"publishCell";
static NSString * const addCellIdentifier = @"addCell";

#pragma mark ---- Life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置状态栏是否隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //设置状态栏是否隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZRecordingViewController" owner:self options:nil] lastObject];
        [self initUI];
    }
    return self;
}



- (void)initUI
{
    _isFirstShow = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MZPublishCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:publishCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"MZAddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:addCellIdentifier];

    _photoDic = [[NSMutableDictionary alloc]initWithCapacity:9];
    _fileDic = [[NSMutableDictionary alloc]initWithCapacity:9];
    _timeDic = [[NSMutableDictionary alloc]initWithCapacity:9];
    
    _assets = [NSMutableArray arrayWithCapacity:9];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    NSLog(@"第一次创建图片");
    [self createPhotoImageViewAndArrowView:nil indexPath:indexPath];
  
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ---- Action
/**
 *  按下录音按钮
 */
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    _photoImageView = (UIImageView *)gestureRecognizer.view;
    NSLog(@"当前选择第%ld张照片",(long)_photoImageView.tag);
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
      
        
        //检测麦克风功能是否打开
        [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
            if (!granted)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法录音" message:@"请在iPhone的“设置-隐私-麦克风”选项中,允许图什么访问你的手机麦克风。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
                [alert show];
            }
            else
            {
                  NSLog(@"开始录音了");
                [_grayButton setTitle:@"松开结束,上滑取消" forState:UIControlStateNormal];
                
                
                _tempPoint = [gestureRecognizer locationInView:self.view];
                
                _recordArray = _fileDic[[NSString stringWithFormat:@"%ld",_photoImageView.tag]];
                if (_recordArray == nil) {
                    _recordArray = [[NSMutableArray alloc]initWithCapacity:5];
                }
                
                _photoArray = _photoDic[[NSString stringWithFormat:@"%ld",_photoImageView.tag]];
                if(_photoArray == nil) {
                    _photoArray = [[NSMutableArray alloc]initWithCapacity:5];
                }
                
                _timeArray = _timeDic[[NSString stringWithFormat:@"%ld",_photoImageView.tag]];
                if(_timeArray == nil) {
                    _timeArray = [[NSMutableArray alloc]initWithCapacity:5];
                }
                
                
                if (_fifthIsSuccessful == YES && _fourthIsSuccessful == YES && _thirdIsSuccessful == YES && _secondIsSuccessful == YES && _firstIsSuccessful == YES) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉,您已经添加足够多的语言标签了." delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                
                
                //对录音的准备工作
                [self prepareAudio];
                _firstLocation = [gestureRecognizer locationInView:_photoImageView];
                [_recorder prepareToRecord];
                [_recorder record];
            }
        }];
        
        /**
         *  松开录制完成
         */
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        
        NSLog(@"结束录音");
        if (_firstIsSuccessful == NO && _secondIsSuccessful == NO) {
            // 304 < 434
            if (_updatePoint.y < _tempPoint.y ) {
                NSLog(@"第一次录音,手指上滑，取消发送");
                [_grayButton setTitle:@"松开结束,上滑取消" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                });
                return;
            }
        }
        if (_firstIsSuccessful == YES && _secondIsSuccessful == NO ) {
            // 304 < 434
            if (_updatePoint.y < _tempPoint.y ) {
                NSLog(@"第二次录音,手指上滑，取消发送");
                [_grayButton setTitle:@"松开结束,上滑取消" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                });
                return;
            }
        }
         if (_secondIsSuccessful == YES && _thirdIsSuccessful == NO) {
             // 304 < 434
             if (_updatePoint.y < _tempPoint.y) {
                 NSLog(@"第三次录音,手指上滑，取消发送");
                 [_grayButton setTitle:@"松开结束,上滑取消" forState:UIControlStateNormal];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                 });
                 return;
             }
         }
        if (_thirdIsSuccessful == YES && _fourthIsSuccessful == NO) {
            // 304 < 434
            if (_updatePoint.y < _tempPoint.y ) {
                NSLog(@"第四次录音,手指上滑，取消发送");
                [_grayButton setTitle:@"松开结束,上滑取消" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                });
                return;
            }

        }
         if (_fourthIsSuccessful == YES && _fifthIsSuccessful == NO) {
             // 304 < 434
             if (_updatePoint.y < _tempPoint.y ) {
                 NSLog(@"第五次录音,手指上滑，取消发送");
                 [_grayButton setTitle:@"松开结束,上滑取消" forState:UIControlStateNormal];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                 });
                 return;
             }

         }

        
        NSError *playerError;
        if ((NSUInteger)_recorder.currentTime % 60 == 0 ) {
            [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"说话时间太短" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            [alert dismissWithClickedButtonIndex:0 animated:NO];
            
        }else{
            
            _dic = [[NSMutableDictionary alloc]initWithCapacity:5];
            if (_firstIsSuccessful == NO && _secondIsSuccessful == NO) {
                [_firstArrowView.leftArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_firstArrowView.rightArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_timeArray addObject:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60]];
                [_timeDic setObject:_timeArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                [_recorder stop];
                NSLog(@"第一次录音开始啦啦啦啦啦");
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
                NSLog(@"第一次录音_recordedFile == %@",_recordedFile);
                _player.volume = 1.0f;
                if (_player == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }else{
                    _firstIsSuccessful = YES;
                }
            }
            
            if (_firstIsSuccessful == YES && _secondIsSuccessful == NO && _firstArrowView.hidden == YES) {
                _firstArrowView.hidden = NO;
                if (_firstLocation.x>=SCREEN_WIDTH/2) {
                    _firstArrowView.leftArrowButton.hidden = YES;
                    _firstArrowView.rightArrowButton.hidden = NO;
                }else{
                    _firstArrowView.leftArrowButton.hidden = NO;
                    _firstArrowView.rightArrowButton.hidden = YES;
                }
                _firstArrowView.frame = rect(-56+_firstLocation.x, _firstLocation.y,112+8, 50/2);
                if(_firstArrowView.superview == nil) {
                    [_photoImageView addSubview:_firstArrowView];
                }
                _firstArrowView.speechPathUrl = _recordedFile;
                [_dic setObject:@[[NSString stringWithFormat:@"%f",_firstLocation.x/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",_firstLocation.y/SCREEN_HEIGHT]] forKey:@"one"];
                [_photoArray addObject:_dic];
                [_photoDic setObject:_photoArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                
                [_recordArray addObject:_recordedFile];
                [_fileDic setObject:_recordArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                _firstArrowView.arowViewBeganBlocks = ^(){};
                _firstArrowView.arowViewOverBlocks = ^(){};
                [_grayButton setTitle:@"添加语音标签成功,试试再加一个?" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                });
                return;
            }
            
            if (_firstIsSuccessful == YES && _secondIsSuccessful == NO ) {
               
                [_secondArrowView.leftArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_secondArrowView.rightArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_timeArray addObject:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60]];
                [_timeDic setObject:_timeArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                [_recorder stop];
                NSLog(@"第二次录音开始啦啦啦啦啦");
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
                NSLog(@"第二次录音recordedFile == %@",_recordedFile);
                _player.volume = 1.0f;
                if (_player == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }else{
                    _secondIsSuccessful = YES;
                }
            }
            
            if (_secondIsSuccessful == YES && _firstIsSuccessful == YES && _secondArrowView.hidden == YES) {
                _secondArrowView.hidden = NO;
                if (_firstLocation.x>=SCREEN_WIDTH/2) {
                    _secondArrowView.leftArrowButton.hidden = YES;
                    _secondArrowView.rightArrowButton.hidden = NO;
                }else{
                    _secondArrowView.leftArrowButton.hidden = NO;
                    _secondArrowView.rightArrowButton.hidden = YES;
                }
                _secondArrowView.frame = rect(-56+_firstLocation.x, _firstLocation.y,112+8, 50/2);
                if(_secondArrowView.superview == nil) {
                    [_photoImageView addSubview:_secondArrowView];
                }
                _secondArrowView.speechPathUrl = _recordedFile;
                [_dic setObject:@[[NSString stringWithFormat:@"%f",_firstLocation.x/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",_firstLocation.y/SCREEN_HEIGHT]] forKey:@"two"];
                [_photoArray addObject:_dic];
                [_photoDic setObject:_photoArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                
                [_recordArray addObject:_recordedFile];
                [_fileDic setObject:_recordArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                _secondArrowView.arowViewBeganBlocks = ^(){};
                _secondArrowView.arowViewOverBlocks = ^(){};
                [_grayButton setTitle:@"添加语音标签成功,试试再加一个?" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                });
                return;
            }
            
            
            if (_secondIsSuccessful == YES && _thirdIsSuccessful == NO) {
                [_thirdArrowView.leftArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_thirdArrowView.rightArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_timeArray addObject:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60]];
                [_timeDic setObject:_timeArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                [_recorder stop];
                NSLog(@"第三次录音开始啦啦啦啦啦");
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
                NSLog(@"第三次录音recordedFile == %@",_recordedFile);
                
                _player.volume = 1.0f;
                if (_player == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }else{
                    _thirdIsSuccessful = YES;
                }
            }
            
            if (_thirdIsSuccessful == YES && _secondIsSuccessful == YES && _thirdArrowView.hidden == YES) {
                _thirdArrowView.hidden = NO;
                if (_firstLocation.x>=SCREEN_WIDTH/2) {
                    _thirdArrowView.leftArrowButton.hidden = YES;
                    _thirdArrowView.rightArrowButton.hidden = NO;
                }else{
                    _thirdArrowView.leftArrowButton.hidden = NO;
                    _thirdArrowView.rightArrowButton.hidden = YES;
                }
                _thirdArrowView.frame = rect(-56+_firstLocation.x, _firstLocation.y,112+8, 50/2);
                if(_thirdArrowView.superview == nil) {
                    [_photoImageView addSubview:_thirdArrowView];
                }
                _thirdArrowView.speechPathUrl = _recordedFile;
                [_dic setObject:@[[NSString stringWithFormat:@"%f",_firstLocation.x/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",_firstLocation.y/SCREEN_HEIGHT]] forKey:@"three"];
                [_photoArray addObject:_dic];
                [_photoDic setObject:_photoArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                
                [_recordArray addObject:_recordedFile];
                [_fileDic setObject:_recordArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                _thirdArrowView.arowViewBeganBlocks = ^(){};
                _thirdArrowView.arowViewOverBlocks = ^(){};
                [_grayButton setTitle:@"添加语音标签成功,试试再加一个?" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                });
                return;
            }
            
            
            if (_thirdIsSuccessful == YES && _fourthIsSuccessful == NO) {
                [_fourthArrowView.leftArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_fourthArrowView.rightArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_timeArray addObject:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60]];
                [_timeDic setObject:_timeArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                [_recorder stop];
                NSLog(@"第四次录音开始啦啦啦啦啦");
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
                NSLog(@"第四次录音recordedFile == %@",_recordedFile);
                _player.volume = 1.0f;
                if (_player == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }else{
                    _fourthIsSuccessful = YES;
                }
            }
            
            if (_fourthIsSuccessful == YES && _thirdIsSuccessful == YES && _fourthArrowView.hidden == YES) {
                _fourthArrowView.hidden = NO;
                if (_firstLocation.x>=SCREEN_WIDTH/2) {
                    _fourthArrowView.leftArrowButton.hidden = YES;
                    _fourthArrowView.rightArrowButton.hidden = NO;
                }else{
                    _fourthArrowView.leftArrowButton.hidden = NO;
                    _fourthArrowView.rightArrowButton.hidden = YES;
                }
                _fourthArrowView.frame = rect(-56+_firstLocation.x, _firstLocation.y,112+8, 50/2);
                if(_fourthArrowView.superview == nil) {
                    [_photoImageView addSubview:_fourthArrowView];
                }
                _fourthArrowView.speechPathUrl = _recordedFile;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:5];
                [dic setObject:@[[NSString stringWithFormat:@"%f",_firstLocation.x/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",_firstLocation.y/SCREEN_HEIGHT]] forKey:@"four"];
                [_photoArray addObject:dic];
                [_photoDic setObject:_photoArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                
                [_recordArray addObject:_recordedFile];
                [_fileDic setObject:_recordArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                _fourthArrowView.arowViewBeganBlocks = ^(){};
                _fourthArrowView.arowViewOverBlocks = ^(){};
                [_grayButton setTitle:@"添加语音标签成功,试试再加一个?" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                });
                return;
            }
            
            if (_fourthIsSuccessful == YES && _fifthIsSuccessful == NO) {
                [_fifthArrowView.leftArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_fifthArrowView.rightArrowButton setTitle:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60] forState:UIControlStateNormal];
                [_timeArray addObject:[NSString stringWithFormat:@"%ld",((NSUInteger) _recorder.currentTime) % 60]];
                [_timeDic setObject:_timeArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                [_recorder stop];
                NSLog(@"第五次录音开始啦啦啦啦啦");
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
                NSLog(@"第五次录音recordedFile == %@",_recordedFile);
                _player.volume = 1.0f;
                if (_player == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }else{
                    _fifthIsSuccessful = YES;
                }
            }
            
            if (_fifthIsSuccessful == YES && _fourthIsSuccessful == YES && _fifthArrowView.hidden == YES) {
                _fifthArrowView.hidden = NO;
                if (_firstLocation.x>=SCREEN_WIDTH/2) {
                    _fifthArrowView.leftArrowButton.hidden = YES;
                    _fifthArrowView.rightArrowButton.hidden = NO;
                }else{
                    _fifthArrowView.leftArrowButton.hidden = NO;
                    _fifthArrowView.rightArrowButton.hidden = YES;
                }
                _fifthArrowView.frame = rect(-56+_firstLocation.x, _firstLocation.y,112+8, 50/2);
                if(_fifthArrowView.superview == nil) {
                    [_photoImageView addSubview:_fifthArrowView];
                }
                _fifthArrowView.speechPathUrl = _recordedFile;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:5];
                [dic setObject:@[[NSString stringWithFormat:@"%f",_firstLocation.x/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",_firstLocation.y/SCREEN_HEIGHT]] forKey:@"five"];
                [_photoArray addObject:dic];
                [_photoDic setObject:_photoArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                
                [_recordArray addObject:_recordedFile];
                [_fileDic setObject:_recordArray forKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
                _fifthArrowView.arowViewBeganBlocks = ^(){};
                _fifthArrowView.arowViewOverBlocks = ^(){};
                [_grayButton setTitle:@"添加语音标签成功,试试再加一个?" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
                });
                return;
            }
            
        }
        
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"正在录音");
        _updatePoint = [gestureRecognizer locationInView:self.view];
//        if (point.y < _tempPoint.y - 10) {
//            NSLog(@"松开手指，取消发送");
//            if (_firstIsSuccessful == NO && _secondIsSuccessful == NO) {
//                [_firstArrowView removeFromSuperview];
//            }
//
//            if (!CGPointEqualToPoint(point, _tempPoint) && point.y < _tempPoint.y - 8) {
//                _tempPoint = point;
//            }
//            
//        } else
        // 180 401
//            if (point.y < _tempPoint.y + 10) {

//            [_grayButton setTitle:@"松开结束,上滑取消" forState:UIControlStateNormal];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
//            });
            
//            NSLog(@"手指上滑，取消发送");
//            if (_firstIsSuccessful == NO && _secondIsSuccessful == NO) {
//                [_firstArrowView removeFromSuperview];
//            }
        
//            if (!CGPointEqualToPoint(point, _tempPoint) && point.y > _tempPoint.y + 8) {
//                _tempPoint = point;
//            }
//        }
        
        NSLog(@"%@      %@", NSStringFromCGPoint(_updatePoint), NSStringFromCGPoint(_tempPoint));
    }
    
//    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
//        NSLog(@"cancel, end");
//        [_recorder stop];
//        [_recorder deleteRecording];
//
//    }
}

- (void)setAssets:(NSMutableArray *)assets
{
    _assets = assets;
    UIImage *image;
    if (_assets.count > 0) {
         _photoImageView.image = [_assets objectAtIndex:0];
        image = [_assets objectAtIndex:0];
    }
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = width*image.size.height/image.size.width;
    CGFloat newHeight = SCREEN_HEIGHT-66.0f;
    
    if (height>newHeight) {
        CGFloat newWidth = newHeight*image.size.width/image.size.height;
        _photoImageView.frame = rect((SCREEN_WIDTH-newWidth)/2,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,newWidth,newHeight);
        _grayButton.frame = rect(48.0f-(SCREEN_WIDTH-newWidth)/2, 10.0f, SCREEN_WIDTH-96.0f, 25.0f);
    }else{
        _photoImageView.frame = rect(0,66,width,height);
//        _photoImageView.center = point(width/2, 66+(SCREEN_HEIGHT-66.0f)/2);
    }
}

- (void)setSelectAssets:(NSMutableArray *)selectAssets
{
    _selectAssets = selectAssets;
}



//点击返回按钮的响应方法
- (IBAction)didClickBackButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击完成按钮的响应方法
- (IBAction)didClickCompleteButtonAction:(id)sender {
    NSLog(@"完成");
    
    [_firstArrowView stopPlay];
    [_secondArrowView stopPlay];
    [_thirdArrowView stopPlay];
    [_fourthArrowView stopPlay];
    [_fifthArrowView stopPlay];
    
    MZUploadSoundModel *uploadSoundModel = [[MZUploadSoundModel alloc]init];
    uploadSoundModel.album_id = _album_id;
    uploadSoundModel.assets = _assets;
    uploadSoundModel.photoDic = _photoDic;
    uploadSoundModel.recordDic = _fileDic;
    uploadSoundModel.timeDic = _timeDic;
    if (self.albumType == MZRecordingViewControllerTypePublicAlbum) {
        uploadSoundModel.upload_type = @"common";
    }else{
        uploadSoundModel.upload_type = @"";
    }
    if (_fileDic.count > 0) {
        uploadSoundModel.type = @"2";
    }else{
        uploadSoundModel.type = @"1";
    }
    
    [[MZUploadManager manager]uploadPhotoswithModel:uploadSoundModel];
    [MZUploadManager manager].uploadBlocks = ^(){
        [self dismissViewControllerAnimated:YES completion:nil];
        [userdefaultsDefine setObject:@"publish" forKey:@"publish"];
    };
}


//移动位置
- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    NSLog(@"gesture translatedPoint  xxoo xxoo");
    CGPoint translatedPoint = [recognizer translationInView:_photoImageView];
    
    
    //获取当前移动的View
    MZArowView *arowView = (MZArowView *)recognizer.view;
    NSArray *photoArray = [_photoDic objectForKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
    if (arowView.tag-500 < photoArray.count) {
        NSMutableDictionary *locationDic = [photoArray objectAtIndex:arowView.tag-500];
  
    if ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateBegan) {
        _firstLocation = [recognizer locationInView:_photoImageView];
        
        _firstX = recognizer.view.center.x;
        _firstY = recognizer.view.center.y;
        NSLog(@"self.view bounds is %@", NSStringFromCGRect(_photoImageView.bounds));
        NSLog(@"pan gesture testPanView begin  is %@,%@", NSStringFromCGPoint([recognizer view].center), NSStringFromCGRect([recognizer view].frame));
    }
    
    if ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat x = _firstX + translatedPoint.x;
        CGFloat y = _firstY + translatedPoint.y;
        
        if (x < recognizer.view.frame.size.width / 2.0) {
            x = recognizer.view.frame.size.width / 2.0;
            NSLog(@"最左边%f",x);
            arowView.leftArrowButton.hidden = NO;
            arowView.rightArrowButton.hidden = YES;
            
        } else if (x + recognizer.view.frame.size.width / 2.0 > _photoImageView.frame.size.width) {
            x = _photoImageView.frame.size.width - recognizer.view.frame.size.width / 2.0;
            NSLog(@"最右边%f",x);
            arowView.leftArrowButton.hidden = YES;
            arowView.rightArrowButton.hidden = NO;
        }
        
        if (y < recognizer.view.frame.size.height / 2.0) {
            y = recognizer.view.frame.size.height / 2.0;
        } else if (y + recognizer.view.frame.size.height / 2.0 > _photoImageView.frame.size.height) {
            y = _photoImageView.frame.size.height - recognizer.view.frame.size.height / 2.0;
        }
        
        
        
        NSLog(@"gesture translatedPoint moving  is %@", NSStringFromCGPoint(translatedPoint));
        recognizer.view.center = CGPointMake(x, y);
    }
    
    if (([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateEnded) || ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateCancelled)) {
        switch (arowView.tag-500) {
            case 0:
            {
                [locationDic setObject:@[[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.x+56.0f)/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.y)/SCREEN_HEIGHT]] forKey:@"one"];
            }
                break;
            case 1:
            {
                [locationDic setObject:@[[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.x+56.0f)/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.y)/SCREEN_HEIGHT]] forKey:@"two"];
            }
                break;
            case 2:
            {
                [locationDic setObject:@[[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.x+56.0f)/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.y)/SCREEN_HEIGHT]] forKey:@"three"];
            }
                break;
            case 3:
            {
                [locationDic setObject:@[[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.x+56.0f)/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.y)/SCREEN_HEIGHT]] forKey:@"four"];
            }
                break;
            case 4:
            {
                [locationDic setObject:@[[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.x+56.0f)/SCREEN_WIDTH],[NSString stringWithFormat:@"%f",([recognizer view].frame.origin.y)/SCREEN_HEIGHT]] forKey:@"five"];
            }
                break;
                
            default:
                break;
        }
        
        
        NSLog(@"gesture translatedPoint  end is %@", NSStringFromCGPoint(translatedPoint));
        
        NSLog(@"pan gesture testPanView end  is %@,%@", NSStringFromCGPoint([recognizer view].center), NSStringFromCGRect([recognizer view].frame));
    }
        
           }
}

//长按删除录音
- (void)arrowViewhandleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        //获取当前长按的View
        MZArowView *arowView = (MZArowView *)gestureRecognizer.view;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请问您要删除这条录音吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = arowView.tag - 500;
        NSLog(@"alert.tag == %ld",(long)alert.tag);
        [alert show];
    }
}


- (void)didClickPhotoImageAction:(UITapGestureRecognizer *)tap
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"说话时间太短" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
    NSLog(@"录音时间太短");
}


#pragma mark ---- UIAlerViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableArray *photoArray = [_photoDic objectForKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
        NSMutableArray *dataArray = [_fileDic objectForKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
        NSMutableArray *timeArray = [_timeDic objectForKey:[NSString stringWithFormat:@"%ld",(long)_photoImageView.tag]];
        NSArray *keyArray = @[@"one",@"two",@"three",@"four",@"five"];
        if(alertView.tag >= keyArray.count) {
            return;
        }
        NSString *key = keyArray[alertView.tag];
        for (int i = 0; i < photoArray.count;i++) {
//            NSDictionary *dict = photoArray[i];
            NSMutableDictionary *dict = photoArray[i];
            NSLog(@"%@  %@",key,dict.allKeys);
            if([dict.allKeys containsObject:key]) {
                [photoArray removeObjectAtIndex:i];
                [dataArray removeObjectAtIndex:i];
                [timeArray removeObjectAtIndex:i];
                switch (alertView.tag) {
                    case 0:
                    {
                        NSLog(@"第1个");
                        [_firstArrowView removeFromSuperview];
                        _firstArrowView.hidden = YES;
                        _firstIsSuccessful = NO;
                        _secondIsSuccessful = NO;
                    }
                        break;
                    case 1:
                    {
                        NSLog(@"第2个");
                        [_secondArrowView removeFromSuperview];
                        _secondArrowView.hidden = YES;
                        _firstIsSuccessful = YES;
                        _secondIsSuccessful = NO;

                    }
                        break;
                    case 2:
                    {
                        NSLog(@"第3个");
                        [_thirdArrowView removeFromSuperview];
                        _thirdArrowView.hidden = YES;
                        _secondIsSuccessful = YES;
                        _thirdIsSuccessful = NO;

                    }
                        break;
                    case 3:
                    {
                        NSLog(@"第4个");
                        [_fourthArrowView removeFromSuperview];
                        _fourthArrowView.hidden = YES;
                        _thirdIsSuccessful = YES;
                        _fourthIsSuccessful = NO;

                    }
                        break;
                    case 4:
                    {
                        NSLog(@"第5个");
                        [_fifthArrowView removeFromSuperview];
                        _fifthArrowView.hidden = YES;
                        _fourthIsSuccessful = YES;
                        _fifthIsSuccessful = NO;

                    }
                        break;
                        
                    default:
                        break;
                }
                break;
            }
        }
    }
}


- (void)setAlbumType:(MZRecordingViewControllerType)albumType
{
    _albumType = albumType;
}


#pragma mark ---- UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.albumType == MZRecordingViewControllerTypePublicAlbum) {
        
        if (_assets.count > 0 && _assets.count < 9 ) {
            return _assets.count+1;
        }else{
            return 9;
        }
    }else{
        
        if (_assets.count > 0 && _assets.count < 30 ) {
            return _assets.count+1;
        }else{
            return 30;
        }
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.albumType == MZRecordingViewControllerTypePublicAlbum) {
        
        if (_assets.count == 9) {
            MZPublishCollectionViewCell* publishCell =  [collectionView dequeueReusableCellWithReuseIdentifier:publishCellIdentifier forIndexPath:indexPath];
            publishCell.layer.borderColor = [[UIColor whiteColor]CGColor];
            publishCell.layer.borderWidth= 0.0f;
            publishCell.photoImageView.image = [_assets objectAtIndex:indexPath.row];
            publishCell.removeButton.hidden = YES;
            if (indexPath.row == 0 && _isFirstShow == YES) {
                [self clickPublishCell:publishCell borderWidth:2.0f];
                _isFirstShow = NO;
            }
            if (_seleteIndexPath.row == indexPath.row) {
                [self clickPublishCell:publishCell borderWidth:2.0f];
            }
            return publishCell;
        }else{
            if (_assets.count > 0 && indexPath.row <_assets.count ) {
                MZPublishCollectionViewCell* publishCell =  [collectionView dequeueReusableCellWithReuseIdentifier:publishCellIdentifier forIndexPath:indexPath];
                publishCell.layer.borderColor = [[UIColor whiteColor]CGColor];
                publishCell.layer.borderWidth= 0.0f;
                publishCell.photoImageView.image = [_assets objectAtIndex:indexPath.row];
                publishCell.removeButton.hidden = YES;
                if (indexPath.row == 0 && _isFirstShow == YES) {
                    [self clickPublishCell:publishCell borderWidth:2.0f];
                    _isFirstShow = NO;
                }
                
                if (_seleteIndexPath.row == indexPath.row) {
                    [self clickPublishCell:publishCell borderWidth:2.0f];
                }
                return publishCell;
            }else{
                MZAddCollectionViewCell* cell =  [collectionView dequeueReusableCellWithReuseIdentifier:addCellIdentifier forIndexPath:indexPath];
                return cell;
            }
        }

        
    }else{

        if (_assets.count > 0 && _assets.count < 30) {
            if (_assets.count > 0 && indexPath.row <_assets.count ) {
                MZPublishCollectionViewCell* publishCell =  [collectionView dequeueReusableCellWithReuseIdentifier:publishCellIdentifier forIndexPath:indexPath];
                publishCell.layer.borderColor = [[UIColor whiteColor]CGColor];
                publishCell.layer.borderWidth= 0.0f;
                publishCell.photoImageView.image = [_assets objectAtIndex:indexPath.row];
                publishCell.removeButton.hidden = YES;
                if (indexPath.row == 0 && _isFirstShow == YES) {
                    [self clickPublishCell:publishCell borderWidth:2.0f];
                    _isFirstShow = NO;
                }
                
                if (_seleteIndexPath.row == indexPath.row) {
                    [self clickPublishCell:publishCell borderWidth:2.0f];
                    _photoImageView.image = [_assets objectAtIndex:_seleteIndexPath.row];
                    UIImage *image = [_assets objectAtIndex:indexPath.row];
                    CGFloat width = SCREEN_WIDTH;
                    CGFloat height = width*image.size.height/image.size.width;
                    CGFloat newHeight = SCREEN_HEIGHT-8.0f-50.0f-8.0f;
                    
                    if (height>newHeight) {
                        CGFloat newWidth = newHeight*image.size.width/image.size.height;
                        _photoImageView.frame = rect((SCREEN_WIDTH-newWidth)/2,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,newWidth,newHeight);
                        _grayButton.frame = rect(48.0f-(SCREEN_WIDTH-newWidth)/2, 10.0f, SCREEN_WIDTH-96.0f, 25.0f);
                    }else{
                        _photoImageView.frame = rect(0,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,width,height);
                    }

                }
                return publishCell;
            }else{
                MZAddCollectionViewCell* cell =  [collectionView dequeueReusableCellWithReuseIdentifier:addCellIdentifier forIndexPath:indexPath];
                return cell;
            }
        }else{
            MZPublishCollectionViewCell* publishCell =  [collectionView dequeueReusableCellWithReuseIdentifier:publishCellIdentifier forIndexPath:indexPath];
            publishCell.layer.borderColor = [[UIColor whiteColor]CGColor];
            publishCell.layer.borderWidth= 0.0f;
            publishCell.photoImageView.image = [_assets objectAtIndex:indexPath.row];
            publishCell.removeButton.hidden = YES;
            if (indexPath.row == 0 && _isFirstShow == YES) {
                [self clickPublishCell:publishCell borderWidth:2.0f];
                _isFirstShow = NO;
            }
            if (_seleteIndexPath.row == indexPath.row) {
                [self clickPublishCell:publishCell borderWidth:2.0f];
                _photoImageView.image = [_assets objectAtIndex:_seleteIndexPath.row];
                UIImage *image = [_assets objectAtIndex:indexPath.row];
                CGFloat width = SCREEN_WIDTH;
                CGFloat height = width*image.size.height/image.size.width;
                CGFloat newHeight = SCREEN_HEIGHT-8.0f-50.0f-8.0f;
                
                if (height>newHeight) {
                    CGFloat newWidth = newHeight*image.size.width/image.size.height;
                    _photoImageView.frame = rect((SCREEN_WIDTH-newWidth)/2,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,newWidth,newHeight);
                    _grayButton.frame = rect(48.0f-(SCREEN_WIDTH-newWidth)/2, 10.0f, SCREEN_WIDTH-96.0f, 25.0f);
                }else{
                    _photoImageView.frame = rect(0,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,width,height);
                }

            }
            return publishCell;
        }
        
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(45,45);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.albumType == MZRecordingViewControllerTypePublicAlbum) {
        if (_assets.count == 9) {
            [_firstArrowView stopPlay];
            [_secondArrowView stopPlay];
            [_thirdArrowView stopPlay];
            [_fourthArrowView stopPlay];
            [_fifthArrowView stopPlay];
            [_photoImageView removeFromSuperview];
            [self createPhotoImageViewAndArrowView:_photoDic indexPath:indexPath];
            _seleteIndexPath = indexPath;
            NSArray *visibleCells = _collectionView.visibleCells;
            for (MZPublishCollectionViewCell *cell in visibleCells){
                if (cell.isSelected == YES) {
                    cell.layer.borderColor = [UIColorFromRGB(0x308afc) CGColor];
                    cell.layer.borderWidth= 2.0f;
                }else{
                    cell.layer.borderColor = [[UIColor whiteColor]CGColor];
                    cell.layer.borderWidth= 0.0f;
                }
            }
            
            
            _photoImageView.image = [_assets objectAtIndex:indexPath.row];
            UIImage *image = [_assets objectAtIndex:indexPath.row];
            CGFloat width = SCREEN_WIDTH;
            CGFloat height = width*image.size.height/image.size.width;
            CGFloat newHeight = SCREEN_HEIGHT-8.0f-50.0f-8.0f;
            
            if (height>newHeight) {
                CGFloat newWidth = newHeight*image.size.width/image.size.height;
                _photoImageView.frame = rect((SCREEN_WIDTH-newWidth)/2,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,newWidth,newHeight);
                _grayButton.frame = rect(48.0f-(SCREEN_WIDTH-newWidth)/2, 10.0f, SCREEN_WIDTH-96.0f, 25.0f);
            }else{
                _photoImageView.frame = rect(0,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,width,height);
            }
            
        }else{
            if (_assets.count > 0 && indexPath.row <_assets.count) {
                [_firstArrowView stopPlay];
                [_secondArrowView stopPlay];
                [_thirdArrowView stopPlay];
                [_fourthArrowView stopPlay];
                [_fifthArrowView stopPlay];
                [_photoImageView removeFromSuperview];
                [self createPhotoImageViewAndArrowView:_photoDic indexPath:indexPath];
                
                //            [_photoArray removeAllObjects];
                _seleteIndexPath = indexPath;
                NSLog(@"_seleteIndexPath == %ld",_seleteIndexPath.row);
                NSArray *visibleCells = _collectionView.visibleCells;
                for (MZPublishCollectionViewCell *cell in visibleCells){
                    if (cell.isSelected == YES) {
                        cell.layer.borderColor = [UIColorFromRGB(0x308afc) CGColor];
                        cell.layer.borderWidth= 2.0f;
                    }else{
                        cell.layer.borderColor = [[UIColor whiteColor]CGColor];
                        cell.layer.borderWidth= 0.0f;
                    }
                }
                
                _photoImageView.image = [_assets objectAtIndex:indexPath.row];
                UIImage *image = [_assets objectAtIndex:indexPath.row];
                CGFloat width = SCREEN_WIDTH;
                CGFloat height = width*image.size.height/image.size.width;
                CGFloat newHeight = SCREEN_HEIGHT-8.0f-50.0f-8.0f;
                
                if (height>newHeight) {
                    CGFloat newWidth = newHeight*image.size.width/image.size.height;
                    _photoImageView.frame = rect((SCREEN_WIDTH-newWidth)/2,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,newWidth,newHeight);
                    _grayButton.frame = rect(48.0f-(SCREEN_WIDTH-newWidth)/2, 10.0f, SCREEN_WIDTH-96.0f, 25.0f);
                }else{
                    _photoImageView.frame = rect(0,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,width,height);
                }
                
            }else{
                // 创建控制器
                ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
                // 默认显示相册里面的内容SavePhotos
                pickerVc.status = PickerViewShowStatusCameraRoll;
                pickerVc.selectPickers = _selectAssets;
                //            pickerVc.selectPickers = self.photoAssets;
                pickerVc.maxCount = 9;
                pickerVc.topShowPhotoPicker = YES;
                pickerVc.delegate = self;
                [pickerVc showPickerVc:self];
            }
        }

        
    }else{
        if (_assets.count == 30) {
            [_firstArrowView stopPlay];
            [_secondArrowView stopPlay];
            [_thirdArrowView stopPlay];
            [_fourthArrowView stopPlay];
            [_fifthArrowView stopPlay];
            [_photoImageView removeFromSuperview];
            [self createPhotoImageViewAndArrowView:_photoDic indexPath:indexPath];
            _seleteIndexPath = indexPath;
            NSArray *visibleCells = _collectionView.visibleCells;
            for (MZPublishCollectionViewCell *cell in visibleCells){
                if (cell.isSelected == YES) {
                    cell.layer.borderColor = [UIColorFromRGB(0x308afc) CGColor];
                    cell.layer.borderWidth= 2.0f;
                }else{
                    cell.layer.borderColor = [[UIColor whiteColor]CGColor];
                    cell.layer.borderWidth= 0.0f;
                }
            }
            
            
            _photoImageView.image = [_assets objectAtIndex:indexPath.row];
            UIImage *image = [_assets objectAtIndex:indexPath.row];
            CGFloat width = SCREEN_WIDTH;
            CGFloat height = width*image.size.height/image.size.width;
            CGFloat newHeight = SCREEN_HEIGHT-8.0f-50.0f-8.0f;
            
            if (height>newHeight) {
                CGFloat newWidth = newHeight*image.size.width/image.size.height;
                _photoImageView.frame = rect((SCREEN_WIDTH-newWidth)/2,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,newWidth,newHeight);
                _grayButton.frame = rect(48.0f-(SCREEN_WIDTH-newWidth)/2, 10.0f, SCREEN_WIDTH-96.0f, 25.0f);
            }else{
                _photoImageView.frame = rect(0,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,width,height);
            }
            
        }else{
            if (_assets.count > 0 && indexPath.row <_assets.count) {
                [_firstArrowView stopPlay];
                [_secondArrowView stopPlay];
                [_thirdArrowView stopPlay];
                [_fourthArrowView stopPlay];
                [_fifthArrowView stopPlay];
                [_photoImageView removeFromSuperview];
                [self createPhotoImageViewAndArrowView:_photoDic indexPath:indexPath];
                _seleteIndexPath = indexPath;
//                NSLog(@"_seleteIndexPath == %ld",_seleteIndexPath.row);
                NSArray *visibleCells = _collectionView.visibleCells;
                for (MZPublishCollectionViewCell *cell in visibleCells){
                    if (cell.isSelected == YES) {
                        cell.layer.borderColor = [UIColorFromRGB(0x308afc) CGColor];
                        cell.layer.borderWidth= 2.0f;
                    }else{
                        cell.layer.borderColor = [[UIColor whiteColor]CGColor];
                        cell.layer.borderWidth= 0.0f;
                    }
                }
                
                _photoImageView.image = [_assets objectAtIndex:indexPath.row];
                UIImage *image = [_assets objectAtIndex:indexPath.row];
                CGFloat width = SCREEN_WIDTH;
                CGFloat height = width*image.size.height/image.size.width;
                CGFloat newHeight = SCREEN_HEIGHT-8.0f-50.0f-8.0f;
                
                if (height>newHeight) {
                    CGFloat newWidth = newHeight*image.size.width/image.size.height;
                    _photoImageView.frame = rect((SCREEN_WIDTH-newWidth)/2,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,newWidth,newHeight);
                    _grayButton.frame = rect(48.0f-(SCREEN_WIDTH-newWidth)/2, 10.0f, SCREEN_WIDTH-96.0f, 25.0f);
                }else{
                    _photoImageView.frame = rect(0,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,width,height);
                }
                
            }else{
                // 创建控制器
                ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
                // 默认显示相册里面的内容SavePhotos
                pickerVc.status = PickerViewShowStatusCameraRoll;
                NSLog(@"_selectAssets == %@",_selectAssets);
                pickerVc.selectPickers = _selectAssets;
                //            pickerVc.selectPickers = self.photoAssets;
                pickerVc.maxCount = 30;
                pickerVc.topShowPhotoPicker = YES;
                pickerVc.delegate = self;
                [pickerVc showPickerVc:self];
            }
        }

        
    }
}

#pragma mark -----ZLPhotoPickerViewControllerDelegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets
{
    NSLog(@"assets == %@",assets);
//    for (ZLPhotoAssets *asset in assets) {
//        for (ZLPhotoAssets *asset2 in _selectAssets) {
//            if ([asset isKindOfClass:[UIImage class]] || [asset2 isKindOfClass:[UIImage class]]) {
//                continue;
//            }
//            if ([asset.asset.defaultRepresentation.url isEqual:asset2.asset.defaultRepresentation.url]) {
//                NSLog(@"相同的图片");
//                break;
//            }
//        }
//    }
    
    
    for (int i = 0; i< assets.count; i++) {
//        for (i = 0 ; i < _selectAssets.count ; i++) {
        if (i>(_selectAssets.count-1)) {
            break;
        }
            ZLPhotoAssets * afterAssets = [assets objectAtIndex:i];
            ZLPhotoAssets * beforeAssets = [_selectAssets objectAtIndex:i];
            if ([afterAssets isKindOfClass:[UIImage class]] || [beforeAssets isKindOfClass:[UIImage class]]) {
                continue;
            }
            if ([afterAssets.asset.defaultRepresentation.url isEqual:beforeAssets.asset.defaultRepresentation.url]) {
                NSLog(@"相同的图片");
//                break;
            }else{
                NSMutableArray *photoArray = [_photoDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
                [photoArray removeAllObjects];
                NSMutableArray *dataArray = [_fileDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
                [dataArray removeAllObjects];
                NSMutableArray *timeArray = [_timeDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
                [timeArray removeAllObjects];
                [_firstArrowView removeFromSuperview];
                [_secondArrowView removeFromSuperview];
                [_thirdArrowView removeFromSuperview];
                [_fourthArrowView removeFromSuperview];
                [_fifthArrowView removeFromSuperview];
            }
    }
    
//    if ([asset.asset.defaultRepresentation.url isEqual:asset2.asset.defaultRepresentation.url]) {
//        
//    }
//        [selectAssets addObject:asset2];

    
    self.selectAssets = [NSMutableArray arrayWithArray:assets];
    NSMutableArray *assetArray = [NSMutableArray arrayWithCapacity:assets.count];
    for (int i = 0; i< assets.count ; i++) {
        if ([[assets objectAtIndex:i]isKindOfClass:[UIImage class]]) {
            [assetArray addObject:[assets objectAtIndex:i]];
        }
        
        if ([[assets objectAtIndex:i]isKindOfClass:[ZLPhotoAssets class]]) {
            ZLPhotoAssets *photoAssets = [assets objectAtIndex:i];
            UIImage *image = [UIImage imageWithCGImage:photoAssets.asset.defaultRepresentation.fullResolutionImage
                                                 scale:photoAssets.asset.defaultRepresentation.scale
                                           orientation:(UIImageOrientation)photoAssets.asset.defaultRepresentation.orientation];
            [assetArray addObject:image];
        }
        
    }
    self.assets = assetArray;
    [_collectionView reloadData];
}


#pragma mark ---- Private Methrod

- (void)clickPublishCell:(MZPublishCollectionViewCell *)publishCell borderWidth:(CGFloat)borderWidth
{
    publishCell.layer.borderColor = [UIColorFromRGB(0x308afc) CGColor];
    publishCell.layer.borderWidth= borderWidth;
}


//获取Documents文件夹里面有几个文件
- (NSUInteger)numberOfFilesInDocPath
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSError *numberOfFilesError;
    NSArray *filelist = [filemgr contentsOfDirectoryAtPath:docPath error:&numberOfFilesError];
    NSUInteger count = [filelist count];
    return count;
}

//对录音的准备工作
- (void)prepareAudio
{
    NSUInteger numberOfFiles = [self numberOfFilesInDocPath];
    
    NSString *newFileName = [NSString stringWithFormat:@"recordedFile%ld.m4a",(unsigned long)numberOfFiles];
    NSMutableArray *pathComponents = [NSMutableArray arrayWithObjects:
                                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                      newFileName,
                                      nil];
    NSLog(@"pathComponents == %@",pathComponents);
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    _recordedFile = outputFileURL;
    /**
     *  后台播放音频设置
     */
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    //切换为听筒播放
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    //切换为扬声器播放
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if(session == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [session setActive:YES error:nil];
        //录音设置
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        //录音格式 无法使用
        [settings setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
        //通道数
        [settings setValue :[NSNumber numberWithInt:1] forKey: AVNumberOfChannelsKey];
        [settings setValue:[NSNumber numberWithFloat:8000.f] forKey:AVSampleRateKey];
        //线性采样位数
        [settings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
        //音频质量,采样质量
        [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        NSError *error;
        _recorder = [[AVAudioRecorder alloc] initWithURL:_recordedFile settings:settings error:&error];
        NSLog(@"%@",error);
        _recorder.delegate = self;
    }
}

/**
 *  创建照片详情,以及上面的5个录音标签
 */
- (void)createPhotoImageViewAndArrowView:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath
{
    
    _firstIsSuccessful = NO;
    _secondIsSuccessful = NO;
    _thirdIsSuccessful = NO;
    _fourthIsSuccessful = NO;
    _fifthIsSuccessful = NO;
    
  
    //rect(0,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,SCREEN_WIDTH,SCREEN_HEIGHT - _collectionView.frame.origin.y - _collectionView.frame.size.height+8.0f+50)
    _photoImageView = [[UIImageView alloc]initWithFrame:rect(0,_collectionView.frame.origin.y + _collectionView.frame.size.height + 8.0f,SCREEN_WIDTH,SCREEN_HEIGHT-8.0f-50.0f-8.0f)];
//    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
//    _photoImageView.backgroundColor = [UIColor redColor];
    _photoImageView.userInteractionEnabled = YES;
    _photoImageView.tag = indexPath.row;
    [self.view addSubview:_photoImageView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickPhotoImageAction:)];
    [_photoImageView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [_photoImageView addGestureRecognizer:longPress];
    
    _grayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _grayButton.backgroundColor = RGBA(0, 0, 0, 0.4);
    _grayButton.frame = rect(48.0f, 10.0f, SCREEN_WIDTH-96.0f, 25.0f);
    [_grayButton setTitle:@"按住照片任意位置,开始录制语音标签" forState:UIControlStateNormal];
    [_grayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_grayButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_photoImageView addSubview:_grayButton];
    

    _firstArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    _firstArrowView.hidden = YES;
//    _firstArrowView.backgroundColor = [UIColor redColor];
    _firstArrowView.tag = 500;
    [_photoImageView addSubview:_firstArrowView];
    
    UIPanGestureRecognizer *firstPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_firstArrowView addGestureRecognizer:firstPan];
    
    UILongPressGestureRecognizer *firstlongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(arrowViewhandleLongPress:)];
    [_firstArrowView addGestureRecognizer:firstlongPress];
    
    
    _secondArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    _secondArrowView.hidden = YES;
    _secondArrowView.tag = 501;
//    _secondArrowView.backgroundColor = [UIColor greenColor];
    [_photoImageView addSubview:_secondArrowView];
    
    UIPanGestureRecognizer *secondPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_secondArrowView addGestureRecognizer:secondPan];
    
    UILongPressGestureRecognizer *secondlongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(arrowViewhandleLongPress:)];
    [_secondArrowView addGestureRecognizer:secondlongPress];
    
    
    _thirdArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    _thirdArrowView.hidden = YES;
    _thirdArrowView.tag = 502;
//    _thirdArrowView.type = MZArowViewTypeNormal;
//    _thirdArrowView.backgroundColor = [UIColor yellowColor];
    [_photoImageView addSubview:_thirdArrowView];
    
    UIPanGestureRecognizer *thirdPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_thirdArrowView addGestureRecognizer:thirdPan];
    
    UILongPressGestureRecognizer *thirdlongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(arrowViewhandleLongPress:)];
    [_thirdArrowView addGestureRecognizer:thirdlongPress];
    
    
    _fourthArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    _fourthArrowView.hidden = YES;
    _fourthArrowView.tag = 503;
//    _fourthArrowView.backgroundColor = [UIColor purpleColor];
    [_photoImageView addSubview:_fourthArrowView];
    UIPanGestureRecognizer *fourthPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_fourthArrowView addGestureRecognizer:fourthPan];
    
    UILongPressGestureRecognizer *fourthlongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(arrowViewhandleLongPress:)];
    [_fourthArrowView addGestureRecognizer:fourthlongPress];
    
    
    _fifthArrowView = [[MZArowView alloc]initWithFrame:CGRectZero];
    _fifthArrowView.hidden = YES;
    _fifthArrowView.tag = 504;
//    _fifthArrowView.backgroundColor = [UIColor blueColor];
    [_photoImageView addSubview:_fifthArrowView];
    UIPanGestureRecognizer *fifthPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_fifthArrowView addGestureRecognizer:fifthPan];
    
    UILongPressGestureRecognizer *fifthlongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(arrowViewhandleLongPress:)];
    [_fifthArrowView addGestureRecognizer:fifthlongPress];
    
    NSArray *photoArray = [_photoDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//    NSLog(@" indexPath.row = %ld  photoArray == %@, photoArray.count == %ld photoDic = %@",(long)indexPath.row,photoArray,photoArray.count,_photoDic);
    NSArray *timeArray = [_timeDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    NSArray *recordArray = [_fileDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    


    
    for (int i = 0; i < timeArray.count; i++) {
        if (i == 0) {
            [_firstArrowView.leftArrowButton setTitle:[timeArray objectAtIndex:i] forState:UIControlStateNormal];
            [_firstArrowView.rightArrowButton setTitle:[timeArray objectAtIndex:i]  forState:UIControlStateNormal];
        }
        if (i == 1) {
            [_secondArrowView.leftArrowButton setTitle:[timeArray objectAtIndex:i] forState:UIControlStateNormal];
            [_secondArrowView.rightArrowButton setTitle:[timeArray objectAtIndex:i]  forState:UIControlStateNormal];
        }
        if (i == 2) {
            [_thirdArrowView.leftArrowButton setTitle:[timeArray objectAtIndex:i] forState:UIControlStateNormal];
            [_thirdArrowView.rightArrowButton setTitle:[timeArray objectAtIndex:i]  forState:UIControlStateNormal];
        }
        if (i == 3) {
            [_fourthArrowView.leftArrowButton setTitle:[timeArray objectAtIndex:i] forState:UIControlStateNormal];
            [_fourthArrowView.rightArrowButton setTitle:[timeArray objectAtIndex:i]  forState:UIControlStateNormal];
        }
        if (i == 4) {
            [_fifthArrowView.leftArrowButton setTitle:[timeArray objectAtIndex:i] forState:UIControlStateNormal];
            [_fifthArrowView.rightArrowButton setTitle:[timeArray objectAtIndex:i]  forState:UIControlStateNormal];
        }
    }
    
    
    for (int i = 0; i < recordArray.count; i++) {
        if (i == 0) {
            _firstArrowView.speechPathUrl = [recordArray objectAtIndex:0];
            _firstArrowView.arowViewBeganBlocks = ^(){};
            _firstArrowView.arowViewOverBlocks = ^(){};
        }
        if (i == 1) {
            _secondArrowView.speechPathUrl = [recordArray objectAtIndex:1];
            _secondArrowView.arowViewBeganBlocks = ^(){};
            _secondArrowView.arowViewOverBlocks = ^(){};
        }
        if (i == 2) {
            _thirdArrowView.speechPathUrl = [recordArray objectAtIndex:2];
            _thirdArrowView.arowViewBeganBlocks = ^(){};
            _thirdArrowView.arowViewOverBlocks = ^(){};
        }
        if (i == 3) {
            _fourthArrowView.speechPathUrl = [recordArray objectAtIndex:3];
            _fourthArrowView.arowViewBeganBlocks = ^(){};
            _fourthArrowView.arowViewOverBlocks = ^(){};
        }
        if (i == 4) {
            _fifthArrowView.speechPathUrl = [recordArray objectAtIndex:4];
            _fifthArrowView.arowViewBeganBlocks = ^(){};
            _fifthArrowView.arowViewOverBlocks = ^(){};
        }
    }
    
    
    for (NSDictionary *dic in photoArray) {
        if ([[dic allKeys]containsObject:@"one"]) {
            NSArray *locationArray = [dic objectForKey:@"one"];
            _firstArrowView.frame = rect([[locationArray objectAtIndex:0]floatValue]*SCREEN_WIDTH - 56.0f , [[locationArray objectAtIndex:1]floatValue]*SCREEN_HEIGHT, 112+8, 50/2);
            _firstArrowView.hidden = NO;
            if ([[locationArray objectAtIndex:0]floatValue]-56.0f <= SCREEN_WIDTH/2) {
                _firstArrowView.rightArrowButton.hidden = YES;
            }else{
                _firstArrowView.leftArrowButton.hidden = YES;
            }
            _firstIsSuccessful = YES;
            _secondIsSuccessful = NO;
        }
        
        if ([[dic allKeys]containsObject:@"two"]) {
            NSArray *locationArray = [dic objectForKey:@"two"];
            _secondArrowView.frame = rect([[locationArray objectAtIndex:0]floatValue]*SCREEN_WIDTH-56.0f, [[locationArray objectAtIndex:1]floatValue]*SCREEN_HEIGHT, 112+8, 50/2);
            _secondArrowView.hidden = NO;
            if ([[locationArray objectAtIndex:0]floatValue]-56.0f <= SCREEN_WIDTH/2) {
                _secondArrowView.rightArrowButton.hidden = YES;
            }else{
                _secondArrowView.leftArrowButton.hidden = YES;
            }
//            _secondArrowView.arowViewBeganBlocks = ^(){};
//            _secondArrowView.arowViewOverBlocks = ^(){};
            _secondIsSuccessful = YES;
            _thirdIsSuccessful = NO;
        }
        
        if ([[dic allKeys]containsObject:@"three"]) {
            NSArray *locationArray = [dic objectForKey:@"three"];
            _thirdArrowView.frame = rect([[locationArray objectAtIndex:0]floatValue]*SCREEN_WIDTH - 56.0f, [[locationArray objectAtIndex:1]floatValue]*SCREEN_HEIGHT, 112+8, 50/2);
            _thirdArrowView.hidden = NO;
            if ([[locationArray objectAtIndex:0]floatValue]-56.0f <= SCREEN_WIDTH/2) {
                _thirdArrowView.rightArrowButton.hidden = YES;
            }else{
                _thirdArrowView.leftArrowButton.hidden = YES;
            }
//            _thirdArrowView.arowViewBeganBlocks = ^(){};
//            _thirdArrowView.arowViewOverBlocks = ^(){};
            _thirdIsSuccessful = YES;
            _fourthIsSuccessful = NO;
        }
        
        if ([[dic allKeys]containsObject:@"four"]) {
            NSArray *locationArray = [dic objectForKey:@"four"];
            _fourthArrowView.frame = rect([[locationArray objectAtIndex:0]floatValue]*SCREEN_WIDTH-56.0f, [[locationArray objectAtIndex:1]floatValue]*SCREEN_HEIGHT, 112+8, 50/2);
            _fourthArrowView.hidden = NO;
            if ([[locationArray objectAtIndex:0]floatValue]-56.0f <= SCREEN_WIDTH/2) {
                _fourthArrowView.rightArrowButton.hidden = YES;
            }else{
                _fourthArrowView.leftArrowButton.hidden = YES;
            }
//            _fourthArrowView.arowViewBeganBlocks = ^(){};
//            _fourthArrowView.arowViewOverBlocks = ^(){};
            _fourthIsSuccessful = YES;
            _fifthIsSuccessful = NO;
        }
        
        if ([[dic allKeys]containsObject:@"five"]) {
            NSArray *locationArray = [dic objectForKey:@"five"];
            _fifthArrowView.frame = rect([[locationArray objectAtIndex:0]floatValue]-56.0f, [[locationArray objectAtIndex:1]floatValue], 112+8, 50/2);
            _fifthArrowView.hidden = NO;
            if ([[locationArray objectAtIndex:0]floatValue]-56.0f <= SCREEN_WIDTH/2) {
                _fifthArrowView.rightArrowButton.hidden = YES;
            }else{
                _fifthArrowView.leftArrowButton.hidden = YES;
            }
//            _fifthArrowView.arowViewBeganBlocks = ^(){};
//            _fifthArrowView.arowViewOverBlocks = ^(){};
            _fifthIsSuccessful = YES;
            _fourthIsSuccessful = YES;
        }
        
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
