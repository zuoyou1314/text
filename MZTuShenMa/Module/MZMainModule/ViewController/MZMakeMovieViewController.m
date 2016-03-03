//
//  MZMakeMovieViewController.m
//  MZTuShenMa
//
//  Created by zuo on 16/1/12.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZMakeMovieViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MZUploadMovieModel.h"
#import "MZUploadMovieManager.h"
#import "OKNetworkingManager.h"
#import "MBProgressHUD.h"
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height
#define MOVIEPATH @"myMovie100.mov"
#define limitTime 10
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface MZMakeMovieViewController ()<AVCaptureFileOutputRecordingDelegate,UIAlertViewDelegate>
{
    NSTimer *_lightTimer;
    BOOL _isDismiss;
    NSString *_movPath;
    NSString *_mp4Path;
    /**
     *  进度条
     */
    MBProgressHUD *_progress;
}
//界面控件
@property (weak, nonatomic) IBOutlet UIView *viewContrain;
//聚焦光标
@property (weak, nonatomic) IBOutlet UIImageView *focusCursor;
//指示灯
@property (weak, nonatomic) IBOutlet UIImageView *indicatorLightImage;
////进度条
//@property (nonatomic, strong) UIProgressView *prog;
//自定义进度条
@property (nonatomic, strong) UIView *progressView;
//录视频Button
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
//播放Button
@property (weak, nonatomic) IBOutlet UIButton *playButton;
//重拍Button
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
//取消Button
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
//使用视频Button
@property (weak, nonatomic) IBOutlet UIButton *sendButton;


//AVFoundation

/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* captureSession;
/**
 *  输入设备 视频输入对象
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoCaptureDeviceInput;
/**
 *  输入设备 音频输入对象
 */
@property (nonatomic, strong) AVCaptureDeviceInput* audioCaptureDeviceInput;
/**
 *  拍摄视频输出对象
 */
@property (nonatomic, strong) AVCaptureMovieFileOutput* captureMovieFileOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* captureVideoPreviewLayer;
/**
 *  后台任务标识
 */
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
/**
 *  播放器
 */
@property (nonatomic,strong) AVPlayer  *player;
/**
 *  播放器的图层
 */
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation MZMakeMovieViewController


- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZMakeMovieViewController" owner:self options:nil] lastObject];
        [self initUI];
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authstatus == AVAuthorizationStatusRestricted || authstatus == AVAuthorizationStatusDenied) //用户关闭了权限
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私-相机”选项中,允许图什么访问你的相机。" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        alertView.delegate = self;
        [alertView show];
    }
    else if (authstatus == AVAuthorizationStatusNotDetermined) //第一次使用，则会弹出是否打开权限
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted)
            {
//                _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
                NSLog(@"第一次使用");
            }
        }];
    }
    else if (authstatus == AVAuthorizationStatusAuthorized)
    {
//        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
          NSLog(@"哈哈哈哈");
    }

    
}


- (void)initUI
{
    
    _isDismiss = YES;
    _replayButton.hidden = YES;
    _sendButton.hidden = YES;
    
    //创建会话 (AVCaptureSession) 对象
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        // 设置会话的 sessionPreset 属性, 这个属性影响视频的分辨率  AVCaptureSessionPreset640x480
        [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    
    //获取摄像头输入设备， 创建 AVCaptureDeviceInput 对象
    //在获取摄像头的时候，摄像头分为前后摄像头，我们创建了一个方法通过用摄像头的位置来获取摄像头
    AVCaptureDevice *videoCaptureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!videoCaptureDevice) {
        NSLog(@"---- 取得后置摄像头时出现问题---- ");
        return;
    }
    
    //添加一个音频输入设备
    //直接可以拿数组中的数组中的第一个
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    
    NSError *error = nil;
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    _videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&error];
    if (error) {
        NSLog(@"---- 取得设备输入对象时出错 ------ %@",error);
        return;
    }
    
    //音频输入对象
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错 ------ %@",error);
        return;
    }
    
    
    //拍摄视频输出对象
    //初始化输出设备对象，用户获取输出数据
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    //限制录视频时间
    _captureMovieFileOutput.maxRecordedDuration = CMTimeMakeWithSeconds(limitTime,32);
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoCaptureDeviceInput]) {
        [_captureSession addInput:_videoCaptureDeviceInput];
    }
    
    // 将音频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_audioCaptureDeviceInput]) {
        [_captureSession addInput:_audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        // 标识视频录入时稳定音频流的接受，我们这里设置为自动
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    
    // 通过会话 (AVCaptureSession) 创建预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    // 显示在视图表面的图层
    CALayer *layer = self.viewContrain.layer;
    layer.masksToBounds = YES;
    
//    _captureVideoPreviewLayer.frame = layer.bounds;
    // CGRectMake(0, 0, preLayerWidth, preLayerHeight);
    _captureVideoPreviewLayer.frame = rect(0, 0, kMainScreenWidth, kMainScreenHeight-86-155);
    _captureVideoPreviewLayer.masksToBounds = YES;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    [layer addSublayer:_captureVideoPreviewLayer];
    
    
    if (iPhone5) {
        _progressView = [[UIView alloc]initWithFrame:CGRectMake(-kMainScreenWidth, kMainScreenHeight-160.0f, kMainScreenWidth, 5.0f)];
    }
    
    if (iPhone6) {
        _progressView = [[UIView alloc]initWithFrame:CGRectMake(-kMainScreenWidth, kMainScreenHeight-185.0f, kMainScreenWidth, 5.0f)];
    }
    
    if (iPhone6P) {
        _progressView = [[UIView alloc]initWithFrame:CGRectMake(-kMainScreenWidth, kMainScreenHeight-205.0f, kMainScreenWidth, 5.0f)];
    }
    
    //创建进度条
//    _progressView = [[UIView alloc]initWithFrame:CGRectMake(-kMainScreenWidth, kMainScreenHeight-185.0f, kMainScreenWidth, 5.0f)];
    _progressView.backgroundColor = UIColorFromRGB(0x308afc);
    [self.view addSubview:_progressView];
    
    //更改进度条高度
    //    _prog = [[UIProgressView alloc] init];
    //    _prog.progressTintColor = [UIColor colorWithRed:57/255.0 green:214/255.0 blue:218/255.0 alpha:1.000];
    //    _prog.trackTintColor = [UIColor clearColor];
    //    _prog.progress =0;
    //    _prog.translatesAutoresizingMaskIntoConstraints = NO;
    //    CGFloat w = kMainScreenWidth;
    //    CGFloat h = 5;
    //    [_prog addConstraint:[NSLayoutConstraint constraintWithItem:_prog attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w]];
    //    [_prog addConstraint:[NSLayoutConstraint constraintWithItem:_prog attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h]];
    //    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0,kMainScreenHeight-160.0f,w,h)];
    //    [v addSubview:_prog];
    //    [v addConstraint:[NSLayoutConstraint constraintWithItem:_prog attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:v attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //    [v addConstraint:[NSLayoutConstraint constraintWithItem:_prog attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:v attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //    v.clipsToBounds = YES;
    ////    v.layer.cornerRadius = 4;
    //    [self.view addSubview:v];
    
    
    //让会话（AVCaptureSession）勾搭好输入输出，然后把视图渲染到预览层上
    [_captureSession startRunning];
    [self addNotificationToCaptureDevice:videoCaptureDevice];
    //[self addGenstureRecognizer];
    
}

#pragma mark ---- respone method

//切换前后摄像头
- (IBAction)didClickChangeCameraPosition:(id)sender {
    AVCaptureDevice *currentDevice=[_videoCaptureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:_videoCaptureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        _videoCaptureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//按下录制按钮(开始视频拍摄)
- (IBAction)didLongPressRecordingButtonAction:(id)sender {

    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 开启视频防抖模式
    AVCaptureVideoStabilizationMode stabilizationMode = AVCaptureVideoStabilizationModeCinematic;
    if ([self.videoCaptureDeviceInput.device.activeFormat isVideoStabilizationModeSupported:stabilizationMode]) {
        [captureConnection setPreferredVideoStabilizationMode:stabilizationMode];
    }
    
    //如果支持多任务则开始多任务
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    
    // 预览图层和视频方向保持一致,这个属性设置很重要，如果不设置，那么出来的视频图像可以是倒向左边的。
    captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
    
    

    // 设置视频输出的文件路径，这里设置为 temp 文件
    NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:MOVIEPATH];
    NSLog(@"save path is :%@",outputFielPath);
    
    //路径转换成 URL 要用这个方法，用 NSBundle 方法转换成 URL 的话可能会出现读取不到路径的错误
    NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
    // 往路径的 URL 开始写入录像 Buffer ,边录边写
    [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    
    //     _prog.progress =(1.0+_captureMovieFileOutput.recordedDuration.value/_captureMovieFileOutput.recordedDuration.timescale)/15.0;
}
//松开录制完成 (取消视频拍摄)
- (IBAction)didClickRecordingButtonAction:(id)sender {
    [self.captureMovieFileOutput stopRecording];
    [self.captureSession stopRunning];
    self.recordButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.replayButton.hidden = NO;
    self.sendButton.hidden = NO;
//    [self begainLayer:_progressView.layer];
    [_progressView.layer removeAnimationForKey:@"basic"];
    [_playerLayer removeFromSuperlayer];
}

//播放录制好的视频
- (IBAction)didClickPlayButtonAction:(id)sender {
    
    [_player seekToTime:CMTimeMake(0, 1)];
    
    if ([_mp4Path isEqualToString:@""] || _mp4Path == nil) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"播放视频出错,请您再试一次." delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }else{
        
        NSURL *saveUrl=[NSURL fileURLWithPath:_mp4Path];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:saveUrl];
        _player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
        // 1.创建播放层
        
        
        // 完成后不断播放
        _captureVideoPreviewLayer.frame = CGRectMake(0-kMainScreenWidth, 0, kMainScreenWidth, kMainScreenWidth);
        
        // 播放视频
        // 1.创建播放层
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            _playerLayer.frame = _viewContrain.bounds;
            _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
            [_viewContrain.layer addSublayer:_playerLayer];
            [self.player play];
            [self addNotification];
        });

        
    }
}

//重新拍摄
- (IBAction)didClickReplyButtonAction:(id)sender {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player pause];
    }
    [self begainLayer:_progressView.layer];
    [_playerLayer removeFromSuperlayer];
    _captureVideoPreviewLayer.frame = self.viewContrain.layer.bounds;
    [_captureSession startRunning];
    self.recordButton.hidden = NO;
    self.cancelButton.hidden = NO;
    self.replayButton.hidden = YES;
    self.sendButton.hidden = YES;
    
}


//使用视频
- (IBAction)didClickSendButtonAction:(id)sender {
    NSLog(@"上传视频");

    if ([OKNetworkingManager sharedInstance].netStatus == OKNetworkStatusViaWWAN) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前并非wifi条件，是否继续上传？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        [alert show];
    }else{
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self.player pause];
        }
        
        MZUploadMovieModel *uploadMovieModel = [[MZUploadMovieModel alloc]init];
        uploadMovieModel.album_id = _album_id;
        uploadMovieModel.type = @"3";
        
        if (self.albumType == MZMakeMovieViewControllerTypePublicAlbum) {
            uploadMovieModel.upload_type = @"common";
        }else{
            uploadMovieModel.upload_type = @"";
        }

        if ([_mp4Path isEqualToString:@""] || _mp4Path == nil) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"上传视频出错,请您再试一次." delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
        }else{
            uploadMovieModel.mp4Url = [NSURL fileURLWithPath:_mp4Path];
            [[MZUploadMovieManager manager]uploadPhotoWithModel:uploadMovieModel];
            [MZUploadMovieManager manager].uploadBlocks = ^(){
                [self dismissViewControllerAnimated:YES completion:nil];
                [userdefaultsDefine setObject:@"publish" forKey:@"publish"];
            };
        }
    }
}


#pragma mark ---- UIAlerViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (buttonIndex == 1) {
         
         if (self.player.status == AVPlayerStatusReadyToPlay) {
             [self.player pause];
         }
         
         /**
          *  加载一个正在上传的菊花
          */
         _progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         _progress.mode = MBProgressHUDModeDeterminateHorizontalBar;
         _progress.alpha = 0.8f;
         _progress.labelText = @"正在上传";

         
//         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             _progress.detailsLabelText = @"2/2";
             _progress.progress = (float)2/(float)2;
             NSLog(@"_progress.progress == %f",_progress.progress);
//         });
    
         MZUploadMovieModel *uploadMovieModel = [[MZUploadMovieModel alloc]init];
         uploadMovieModel.album_id = _album_id;
         uploadMovieModel.type = @"3";
         
         if ([_mp4Path isEqualToString:@""] || _mp4Path == nil) {
             UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"上传视频出错,请您再试一次." delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
             [alertView show];
         }else{
             uploadMovieModel.mp4Url = [NSURL fileURLWithPath:_mp4Path];
             [[MZUploadMovieManager manager]uploadPhotoWithModel:uploadMovieModel];
             [MZUploadMovieManager manager].uploadBlocks = ^(){
                 [_progress removeFromSuperview];
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [userdefaultsDefine setObject:@"publish" forKey:@"publish"];
             };
         }

     }
}




#pragma mark ---- AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"---- 开始录制 ----");
    _lightTimer=[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(changeLightStatus) userInfo:self repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_lightTimer forMode:NSDefaultRunLoopMode];
    [_lightTimer fire];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = @(-kMainScreenWidth/2);
    animation.toValue = @(kMainScreenWidth/2);
    animation.duration = 11;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_progressView.layer addAnimation:animation forKey:@"basic"];
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"---- 录制结束 ----");
    [_lightTimer invalidate];
    _lightTimer = nil;
    
//    //暂停动画
//    [self pauseLayer:_progressView.layer];
    
    if (captureOutput.recordedDuration.value/captureOutput.recordedDuration.timescale == 10) {
        [self.captureMovieFileOutput stopRecording];
        [self.captureSession stopRunning];
    }
    //    _prog.progress =(1.0+_captureMovieFileOutput.recordedDuration.value/_captureMovieFileOutput.recordedDuration.timescale)/15.0;
    NSLog(@"captureOutput.recordedDuration.value == %lld",captureOutput.recordedDuration.value/captureOutput.recordedDuration.timescale);
    
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier=self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
    
    // 写完后复制 temp 文件到 cache 文件内保存，作为缓存之用
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath=[cachePath stringByAppendingPathComponent:MOVIEPATH];
    NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    // 判断文件是否存在，如果存在，就删除
    BOOL isExistsFile = [fileManger fileExistsAtPath:savePath];
    if (isExistsFile) {
        [fileManger removeItemAtURL:saveUrl error:&error];
    }
    
    // 复制文件
    BOOL result = [[NSFileManager defaultManager] copyItemAtURL:outputFileURL toURL:saveUrl error:&error];
    if (error) {
        NSLog(@"复制文件出现错误 ----- %@",error);
    }
    if (lastBackgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
    }
    if (result) {
        // 将 temp 文件内的数据删掉
        NSError *error = nil;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:MOVIEPATH];
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [fileManger removeItemAtURL:fileUrl error:&error];
        [self getfileSize:savePath];
    }
    
    //异步执行压缩视频
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新一下显示包的大小
        [self compressionMovie];
    });
}

//暂停动画
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//恢复开始动画
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil]-pausedTime;
    layer.beginTime = timeSincePause;
}

//从新开始动画
- (void)begainLayer:(CALayer *)layer
{
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.beginTime = timeSincePause;
}




#pragma mark ---- 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}



//取消按钮
- (IBAction)didClickCancelButtonAction:(id)sender {
    if (_isDismiss == YES) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
    [_playerLayer removeFromSuperlayer];
    [_captureSession startRunning];
    //        _prog.progress =0;
    _progressView.frame = CGRectMake(-kMainScreenWidth, kMainScreenHeight-160.0f, kMainScreenWidth, 5.0f);
    //    [self resumeLayer:_progressView.layer];
//    [self begainLayer:_progressView.layer];
    [_progressView.layer removeAnimationForKey:@"basic"];
}


- (void)changeLightStatus
{
    _indicatorLightImage.alpha = 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        _indicatorLightImage.alpha = 1.0f;
    }];
    
    //    NSLog(@"==== %f",(1.0+_captureMovieFileOutput.recordedDuration.value/_captureMovieFileOutput.recordedDuration.timescale)/15.0);
    //    _prog.progress =(1.0+_captureMovieFileOutput.recordedDuration.value/_captureMovieFileOutput.recordedDuration.timescale)/15.0;
    
    //    CGAffineTransform  transform = CGAffineTransformTranslate(_progressView.transform,kMainScreenWidth*(1.0+_captureMovieFileOutput.recordedDuration.value/_captureMovieFileOutput.recordedDuration.timescale)/15.0,0);
    //    [UIView beginAnimations:@"Translate" context:nil];
    //    [UIView setAnimationDuration:0.5f];
    //    [_progressView setTransform:transform];
    //    [UIView commitAnimations];
}

#pragma mark ---- Private Methods
/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

//计算录制出来的视频有多大
- (CGFloat)getfileSize:(NSString *)path
{
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog (@"file size: %f", (unsigned long long)[outputFileAttributes fileSize]/1024.00/1024.00);
    return (CGFloat)[outputFileAttributes fileSize]/1024.00 /1024.00;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    
    AVCaptureDevice *captureDevice= [self.videoCaptureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContrain addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.viewContrain];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置闪光灯按钮状态
 */
//-(void)setFlashModeButtonStatus{
//    AVCaptureDevice *captureDevice=[self.captureDeviceInput device];
//    AVCaptureFlashMode flashMode=captureDevice.flashMode;
//    if([captureDevice isFlashAvailable]){
//        self.flashAutoButton.hidden=NO;
//        self.flashOnButton.hidden=NO;
//        self.flashOffButton.hidden=NO;
//        self.flashAutoButton.enabled=YES;
//        self.flashOnButton.enabled=YES;
//        self.flashOffButton.enabled=YES;
//        switch (flashMode) {
//            case AVCaptureFlashModeAuto:
//                self.flashAutoButton.enabled=NO;
//                break;
//            case AVCaptureFlashModeOn:
//                self.flashOnButton.enabled=NO;
//                break;
//            case AVCaptureFlashModeOff:
//                self.flashOffButton.enabled=NO;
//                break;
//            default:
//                break;
//        }
//    }else{
//        self.flashAutoButton.hidden=YES;
//        self.flashOnButton.hidden=YES;
//        self.flashOffButton.hidden=YES;
//    }
//}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
}

//播放录制的视频
//- (void)completeHandle
//{
//    // 完成后不断播放
////    [_captureVideoPreviewLayer removeFromSuperlayer];
//    _captureVideoPreviewLayer.frame = CGRectMake(0-kMainScreenWidth, 0, kMainScreenWidth, kMainScreenWidth);
//    
//    // 播放视频
//    // 1.创建播放层
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//        _playerLayer.frame = _viewContrain.bounds;
//        _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
//        [_viewContrain.layer addSublayer:_playerLayer];
////        [self.player play];
//        [self addNotification];
//    });
//}


#pragma mark - KVC
#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}


/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    
    
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    //    [_player seekToTime:CMTimeMake(0, 1)];
    //    [_player play];
}

#pragma mark - getter
- (AVPlayer *)player
{
    if (!_player) {
        AVPlayerItem *playerItem = [self getPlayItem];
        _player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
//        [self addObserverToPlayerItem:playerItem];
    }
    return _player;
}

- (AVPlayerItem *)getPlayItem
{
    
//    // 设置视频输出的文件路径，这里设置为 temp 文件
//    NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:MOVIEPATH];
//    NSLog(@"save path is :%@",outputFielPath);
//    
//    //路径转换成 URL 要用这个方法，用 NSBundle 方法转换成 URL 的话可能会出现读取不到路径的错误
//    NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
    
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath=[cachePath stringByAppendingPathComponent:MOVIEPATH];
    NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
    NSLog(@"saveUrl == %@",saveUrl);
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:saveUrl];
    
    return playerItem;
}

#pragma mark - KVO
//-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
//    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
//    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    //监控网络加载情况属性
//    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//}
//
//-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
//    [playerItem removeObserver:self forKeyPath:@"status"];
//    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    AVPlayerItem *playerItem=object;
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
//        if(status==AVPlayerStatusReadyToPlay){
//            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
//        }
//    }
//    else if([keyPath isEqualToString:@"loadedTimeRanges"])
//    {
//        NSArray *array=playerItem.loadedTimeRanges;
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
//        float startSeconds = CMTimeGetSeconds(timeRange.start);
//        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
//        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"共缓冲：%.2f",totalBuffer);
//    }
//}


//压缩视频
- (void)compressionMovie
{
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath=[cachePath stringByAppendingPathComponent:MOVIEPATH];
    NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
    
    // 通过文件的 url 获取到这个文件的资源
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:saveUrl options:nil];
    // 用 AVAssetExportSession 这个类来导出资源中的属性
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // 压缩视频
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) { // 导出属性是否包含低分辨率
        // 通过资源（AVURLAsset）来定义 AVAssetExportSession，得到资源属性来重新打包资源 （AVURLAsset, 将某一些属性重新定义
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        // 设置导出文件的存放路径
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSDate    *date = [[NSDate alloc] init];
        NSString *outPutPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:date]]];
        exportSession.outputURL = [NSURL fileURLWithPath:outPutPath];
        
        // 是否对网络进行优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        // 转换成MP4格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        // 开始导出,导出后执行完成的block
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新一下显示包的大小
                    _mp4Path = outPutPath;
                    NSLog(@"更新一下显示包的大小 :%@",[NSString stringWithFormat:@"%f MB",[self getfileSize:_mp4Path]]);
                    NSLog(@"outPutPath == %@",_mp4Path);
                });
            }
        }];
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
