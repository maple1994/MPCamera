//
//  MPCameraManager.h
//  MPCamera
//
//  Created by Maple on 2019/10/12.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>
#import "MPFilterHandler.h"

typedef void (^TakePhotoResult)(UIImage *resultImage, NSError *error);
typedef void (^RecordVideoResult)(NSString *videoPath);

/// 闪光灯模式
typedef NS_ENUM(NSUInteger, MPCameraFlashMode) {
    /// 关闭
    MPCameraFlashModeOff,
    /// 开启
    MPCameraFlashModeOn,
    /// 自动
    MPCameraFlashModeAuto,
    /// 长亮
    MPCameraFlashModeTorch
};

/// 相机比例宽高比
typedef NS_ENUM(NSUInteger, MPCameraRatio) {
    /// 1:1
    MPCameraRatio1v1,
    /// 4:3
    MPCameraRatio4v3,
    /// 16:9
    MPCameraRatio16v9,
    /// 全屏
    MPCameraRatioFull
};

@interface MPCameraManager : NSObject

/// 相机
@property (nonatomic, strong, readonly) GPUImageStillCamera *camera;
/// 滤镜
@property (nonatomic, strong, readonly) MPFilterHandler *fileterHandler;
/// 闪光灯模式，默认off
@property (nonatomic, assign) MPCameraFlashMode flashMode;
/// 相机比例，默认MPCameraRatio16v9
@property (nonatomic, assign) MPCameraRatio ratio;
/// 对焦点
@property (nonatomic, assign) CGPoint focusPoint;
/// 通过调整焦距来实现视图放大缩小效果，最小是1
@property (nonatomic, assign) CGFloat videoScale;

+ (MPCameraManager *)shareManager;
/// 拍照
- (void)takePhotoWithCompletion: (TakePhotoResult)completion;
/// 录像
- (void)recordVideo;
/// 结束录制
- (void)stopRecordVideoWithCompletion: (RecordVideoResult)completion;
/// 添加图像输出控件，不会被持有
- (void)addOutputView: (GPUImageView *)outputView;
/// 开启相机，开启前请确保已经设置 outputView
- (void)startCapturing;
/// 切换摄像头
- (void)rotateCamera;
/// 刷新闪光灯
- (void)updateFlash;
/// 将缩放倍数转化到可用的范围
- (CGFloat)availableVideoScaleWithScale: (CGFloat)scale;
/// 正在录制中的视频时长
- (NSTimeInterval)currentDuration;
/// 根据选择的比例返回size
- (CGSize)videoSizeWithRatio: (MPCameraRatio)ratio;


@end

