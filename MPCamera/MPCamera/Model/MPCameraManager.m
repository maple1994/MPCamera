//
//  MPCameraManager.m
//  MPCamera
//
//  Created by Maple on 2019/10/12.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPCameraManager.h"

static CGFloat const kMaxVideoScale = 6.0;
static CGFloat const kMinVideoScale = 1.0;
static MPCameraManager *_cameraManager;

@interface MPCameraManager ()

@property (nonatomic, strong, readwrite) GPUImageStillCamera *camera;
@property (nonatomic, strong, readwrite) MPFilterHandler *fileterHandler;
@property (nonatomic, weak) GPUImageView *outputView;
@property (nonatomic, strong) GPUImageMovieWriter *movieWrite;
@property (nonatomic, copy) NSString *currentTmpVideoPath;
@property (nonatomic, assign) CGSize videoSize;

@end

@implementation MPCameraManager

// MARK: - Public
+ (MPCameraManager *)shareManager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cameraManager = [[MPCameraManager alloc] init];
    });
    return _cameraManager;
}

/// 拍照
- (void)takePhotoWithCompletion: (TakePhotoResult)completion
{
    GPUImageFilter *lastFilter = [self.fileterHandler lastFilter];
    [self.camera capturePhotoAsImageProcessedUpToFilter:lastFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (error && completion) {
            completion(nil, error);
        }else {
            if (completion) {
                completion(processedImage, nil);
            }
        }
    }];
}

/// 录像
- (void)recordVideo
{
    
}

/// 结束录制
- (void)stopRecordVideoWithCompletion: (RecordVideoResult)completion
{
    
}

/// 添加图像输出控件，不会被持有
- (void)addOutputView: (GPUImageView *)outputView
{
    self.outputView = outputView;
}

/// 开启相机，开启前请确保已经设置 outputView
- (void)startCapturing
{
    if (!self.outputView) {
        NSAssert(NO, @"output未赋值");
        return;
    }
    [self setupCamera];
    [self.camera addTarget:[self.fileterHandler firstFilter]];
    [[self.fileterHandler lastFilter] addTarget:self.outputView];
    [self.camera startCameraCapture];
}

/// 切换摄像头
- (void)rotateCamera
{
    
}

/// 刷新闪光灯
- (void)updateFlash
{
    
}

/// 将缩放倍数转化到可用的范围
- (CGFloat)availableVideoScaleWithScale: (CGFloat)scale
{
    return 0;
}

/// 正在录制中的视频时长
- (NSTimeInterval)currentDuration
{
    return 0;
}

// MARK: - Private
- (instancetype)init
{
    if (self = [super init]) {
        [self commondInit];
    }
    return self;
}

- (void)commondInit
{
    self.videoScale = 1;
    self.flashMode = MPCameraFlashModeOff;
    self.ratio = MPCameraRatio16v9;
    self.videoSize = [self videoSizeWithRatio:self.ratio];
    self.fileterHandler = [[MPFilterHandler alloc] init];
    [self setupFilterHandler];
}

- (void)setupFilterHandler
{
    
}

/// 初始化相机
- (void)setupCamera
{
    self.camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
    [self.camera addAudioInputsAndOutputs];
}

- (CGSize)videoSizeWithRatio: (MPCameraRatio)ratio
{
    CGFloat videoWidth = SCREEN_WIDTH * SCREEN_SCALE;
    CGFloat videoHeight;
    switch (ratio) {
        case MPCameraRatio1v1:
            videoHeight = videoWidth;
            break;
        case MPCameraRatio4v3:
            videoHeight = videoWidth / 3.0 * 4.0;
            break;
        case MPCameraRatio16v9:
            videoHeight = videoWidth / 9.0 * 16.0;
            break;
        case MPCameraRatioFull:
            videoHeight = SCREEN_HEIGHT / SCREEN_SCALE;
            break;
        default:
            break;
    }
    return CGSizeMake(videoWidth, videoHeight);
}

- (void)setRatio:(MPCameraRatio)ratio
{
    _ratio = ratio;
    CGRect rect = CGRectMake(0, 0, 1, 1);
    switch (ratio) {
        case MPCameraRatio1v1:
            self.camera.captureSessionPreset = AVCaptureSessionPreset640x480;
            CGFloat space = (4 - 3) / 4.0; // 竖直方向应该裁剪掉的空间
            rect = CGRectMake(0, space / 2, 1, 1 - space);
            break;
        case MPCameraRatio4v3:
            self.camera.captureSessionPreset = AVCaptureSessionPreset640x480;
            break;
        case MPCameraRatio16v9:
            self.camera.captureSessionPreset = AVCaptureSessionPreset1280x720;
            break;
        case MPCameraRatioFull:
            self.camera.captureSessionPreset = AVCaptureSessionPreset1280x720;
            CGFloat currentRatio = SCREEN_HEIGHT / SCREEN_WIDTH;
            if (currentRatio > 16.0 / 9.0) { // 需要在水平方向裁剪
                CGFloat resultWidth = 16.0 / currentRatio;
                CGFloat space = (9.0 - resultWidth) / 9.0;
                rect = CGRectMake(space / 2, 0, 1 - space, 1);
            } else { // 需要在竖直方向裁剪
                CGFloat resultHeight = 9.0 * currentRatio;
                CGFloat space = (16.0 - resultHeight) / 16.0;
                rect = CGRectMake(0, space / 2, 1, 1 - space);
            }
            break;
        default:
            break;
    }
    [self.fileterHandler setCropRect:rect];
    self.videoSize = [self videoSizeWithRatio:ratio];
}

@end
