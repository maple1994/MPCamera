//
//  MPCameraViewController.m
//  MPCamera
//
//  Created by Maple on 2019/10/11.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPCameraViewController.h"
#import <GPUImage.h>
#import "MPCameraManager.h"
#import "MPCapturingButton.h"
#import "MPPhotoResultViewController.h"
#import "MPCameraTopView.h"
#import "MPCapturingModeSwitchView.h"
#import "MPCamerVideoTimeLabel.h"

@interface MPCameraViewController ()<
    MPCameraTopViewDelegate,
    MPCapturingModeSwitchViewDelegate>

@property (nonatomic, strong) GPUImageView *cameraView;
@property (nonatomic, strong) MPCapturingButton *capturingButton;
@property (nonatomic, strong) MPCameraTopView *topView;
/// 设置比例时的毛玻璃View
@property (nonatomic, strong) UIView *ratioBlurView;
@property (nonatomic, assign) BOOL isChangingRatio;
@property (nonatomic, strong) UIView *focusView;
@property (nonatomic, assign) CGFloat currentVideoScale;
@property (nonatomic, strong) MPCapturingModeSwitchView *modeSwitchView;
@property (nonatomic, assign) BOOL isRecordingVideo;
@property (nonatomic, strong) MPCamerVideoTimeLabel *videoTimeLabel;
@property (nonatomic, strong) NSTimer *videoTimer;
@property (nonatomic, strong) NSDate *oldDate;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation MPCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
    [CSToastManager setDefaultDuration:1];
    [[MPCameraManager shareManager] addOutputView:self.cameraView];
    [[MPCameraManager shareManager] startCapturing];
    self.currentVideoScale = 1.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

// MARK: - UI
- (void)setupUI
{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCamera];
    self.capturingButton = [[MPCapturingButton alloc] init];
    [self.capturingButton addTarget:self action:@selector(captureAction) forControlEvents:UIControlEventTouchUpInside];
    self.topView = [[MPCameraTopView alloc] init];
    self.topView.delegate = self;
    self.ratioBlurView = ({
        UIBlurEffect *effct = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effct];
        view.hidden = YES;
        view;
    });
    self.focusView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 60, 60);
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 30;
        view.layer.masksToBounds = YES;
        view.alpha = 0;
        view;
    });
    self.modeSwitchView = ({
        MPCapturingModeSwitchView *switchView = [[MPCapturingModeSwitchView alloc] init];
        switchView.delegate = self;
        switchView;
    });
    self.nextButton = ({
        UIButton *btn = [[UIButton alloc] init];
        btn.alpha = 0;
        [btn setEnableDarkWithImageName:@"btn_next"];
        [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.videoTimeLabel = [[MPCamerVideoTimeLabel alloc] init];
    self.videoTimeLabel.alpha = 0;
    
    [self.view addSubview:self.ratioBlurView];
    [self.view addSubview:self.capturingButton];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.modeSwitchView];
    [self.view addSubview:self.videoTimeLabel];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.focusView];
    
    [self.ratioBlurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.cameraView);
    }];
    [self.capturingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        }else {
            make.bottom.equalTo(self.view).offset(-40);
        }
    }];
    CGFloat offset = (SCREEN_WIDTH * 0.5 - 40 - 35) * 0.5;
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.capturingButton);
        make.width.height.mas_equalTo(35);
        make.trailing.equalTo(self.view).offset(-offset);
    }];
    [self.modeSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.capturingButton);
        make.top.equalTo(self.capturingButton.mas_bottom);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [self.videoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.modeSwitchView);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else {
            make.top.equalTo(self.view);
        }
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
}

- (void)setupCamera
{
    self.cameraView = [[GPUImageView alloc] init];
    [self.view addSubview:self.cameraView];
    [self refreshCameraViewWithRatio:[MPCameraManager shareManager].ratio];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self.cameraView addGestureRecognizer:tap];
    [self.cameraView addGestureRecognizer:pinch];
}

- (void)showFocusViewWithLocation: (CGPoint)location
{
    self.focusView.center = location;
    self.focusView.transform = CGAffineTransformMakeScale(1.6, 1.6);
    [self.focusView setHidden:NO animated:YES completion:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.focusView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.2 delay:0.8 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            self.focusView.alpha = 0;
        } completion:nil];
    }];
}

- (void)changeViewToRatio: (MPCameraRatio)ratio animated: (BOOL)animated completion: (void(^)(void))completion
{
    if (self.isChangingRatio) {
        return;
    }
    if ([MPCameraManager shareManager].ratio == ratio) {
        if (completion) {
            completion();
        }
        return;
    }
    if (!animated) {
        [self refreshCameraViewWithRatio:ratio];
        if (completion) {
            completion();
        }
        return;
    }
    self.ratioBlurView.hidden = NO;
    self.isChangingRatio = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self refreshCameraViewWithRatio:ratio];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.ratioBlurView.hidden = YES;
            self.isChangingRatio = NO;
        });
        if (completion) {
            completion();
        }
    }];
}

- (void)updateDarkOrNormalModeWithRatio: (MPCameraRatio)ratio
{
    BOOL isIPhoneX = [UIDevice is_iPhoneX_Series];
    BOOL isTopBarDark = ratio == MPCameraRatio1v1 || (isIPhoneX && ratio != MPCameraRatioFull);
    [self.topView updateDarkMode:isTopBarDark];
    
    BOOL isBottomBarDatk = ratio == MPCameraRatio1v1 || ratio == MPCameraRatio4v3;
    self.modeSwitchView.isDarkMode = isBottomBarDatk;
}

- (void)updateRatioButtonWithRatio: (MPCameraRatio)ratio
{
    switch (ratio) {
        case MPCameraRatio1v1:
            [self.topView.ratioButton setEnableDarkWithImageName:@"btn_ratio_1v1"];
            break;
        case MPCameraRatio4v3:
            [self.topView.ratioButton setEnableDarkWithImageName:@"btn_ratio_3v4"];
            break;
        case MPCameraRatio16v9:
            [self.topView.ratioButton setEnableDarkWithImageName:@"btn_ratio_9v16"];
            break;
        case MPCameraRatioFull:
            [self.topView.ratioButton setEnableDarkWithImageName:@"btn_ratio_full"];
            break;
        default:
            break;
    }
}

- (void)updateFlashButtonWithFlashMode: (MPCameraFlashMode)mode
{
    switch (mode) {
        case MPCameraFlashModeOff:
            [self.topView.flashButton setEnableDarkWithImageName:@"btn_flash_off"];
            break;
        case MPCameraFlashModeOn:
            [self.topView.flashButton setEnableDarkWithImageName:@"btn_flash_on"];
            break;
        case MPCameraFlashModeAuto:
            [self.topView.flashButton setEnableDarkWithImageName:@"btn_flash_auto"];
            break;
        case MPCameraFlashModeTorch:
            [self.topView.flashButton setEnableDarkWithImageName:@"btn_flash_torch"];
            break;
        default:
            break;
    }
}

- (void)refreshUIWhenRecordVideo
{
    [self.topView refreshUIWithIsRecording:self.isRecordingVideo];
    [self.modeSwitchView setHidden:self.isRecordingVideo animated:YES completion:nil];
    [self.nextButton setHidden:YES animated:YES completion:nil];
}

- (void)refreshCameraViewWithRatio: (MPCameraRatio)ratio
{
    CGFloat cameraHeight = [self cameraViewHeightWithRatio:ratio];
    BOOL isIPhoneX = [UIDevice is_iPhoneX_Series];
    [self.cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (ratio == MPCameraRatioFull) {
            make.top.equalTo(self.view);
        }else {
           CGFloat topOffset = isIPhoneX || ratio == MPCameraRatio1v1 ? 60 : 0;
            if (@available(iOS 11.0, *)) {
                make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(topOffset);
            }else {
                make.top.equalTo(self.view).offset(topOffset);
            }
        }
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(cameraHeight);
    }];
}

// MARK: - Action
- (void)captureAction
{
    if (self.modeSwitchView.type == MPCapturingModeSwitchTypeImage) {
        [self takePhoto];
    }else {
        if (self.isRecordingVideo) {
            [self stopRecordVideo];
        }else {
            [self startRecordVideo];
        }
    }
}

- (void)takePhoto
{
    @weakify(self);
    [[MPCameraManager shareManager] takePhotoWithCompletion:^(UIImage *resultImage, NSError *error) {
        @strongify(self);
        MPPhotoResultViewController *resultVC = [[MPPhotoResultViewController alloc] init];
        resultVC.resultImage = resultImage;
        [self.navigationController pushViewController:resultVC animated:NO];
    }];
}

- (void)nextAction
{
    
}

- (void)tapAction: (UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.cameraView];
    [[MPCameraManager shareManager] setFocusPoint:location];
    [self showFocusViewWithLocation:location];
}

- (void)pinchAction: (UIPinchGestureRecognizer *)recognizer
{
    CGFloat scale = recognizer.scale * self.currentVideoScale;
    scale = [[MPCameraManager shareManager] availableVideoScaleWithScale:scale];
    [MPCameraManager shareManager].videoScale = scale;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.currentVideoScale = scale;
    }
}


- (void)startRecordVideo
{
    if (self.isRecordingVideo)
        return;
    self.isRecordingVideo = YES;
    self.capturingButton.capturingState = MPCapturingModeSwitchTypeVideo;
    [self refreshUIWhenRecordVideo];
    [self.topView.closeButton setHidden:YES animated:YES completion:nil];
    self.oldDate = [NSDate date];
    [self startVideoTimer];
}

- (void)stopRecordVideo
{
    if (!self.isRecordingVideo) {
        return;
    }
    self.isRecordingVideo = NO;
    self.capturingButton.capturingState = MPCapturingModeSwitchTypeImage;
    [self.topView.closeButton setHidden:NO animated:YES completion:nil];
    [self.nextButton setHidden:NO animated:YES completion:nil];
    [self endVideoTimer];
}

- (void)timerAction
{
    NSDate *current = [NSDate date];
    NSInteger timestamp = (NSInteger)[current timeIntervalSinceDate:self.oldDate];
    self.videoTimeLabel.timestamp = timestamp;
    [self.videoTimeLabel setHidden:NO animated:YES completion:nil];
}

- (void)startVideoTimer
{
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)endVideoTimer
{
    [self.videoTimer invalidate];
    self.videoTimer = nil;
}

// MARK: - MPCameraTopViewDelegate
- (void)cameraTopViewDidClickRotateButton: (MPCameraTopView *)cameraTopView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MPCameraManager shareManager] rotateCamera];
        self.currentVideoScale = 1.0;
    });
}

- (void)cameraTopViewDidClickFlashButton: (MPCameraTopView *)cameraTopView
{
    MPCameraFlashMode flashMode = [MPCameraManager shareManager].flashMode;
    flashMode = (flashMode + 1) % 4;
    [MPCameraManager shareManager].flashMode = flashMode;
    [self updateFlashButtonWithFlashMode:flashMode];
}

- (void)cameraTopViewDidClickRatioButton: (MPCameraTopView *)cameraTopView
{
    MPCameraRatio ratio = [MPCameraManager shareManager].ratio;
    NSInteger ratioCount = [UIDevice is_iPhoneX_Series] ? 4 : 3;
    MPCameraRatio nextRatio = (ratio + 1) % ratioCount;
    [self changeViewToRatio:nextRatio animated:YES completion:^{
        [MPCameraManager shareManager].ratio = nextRatio;
    }];
    [self updateRatioButtonWithRatio:nextRatio];
    [self updateDarkOrNormalModeWithRatio:nextRatio];
}

- (void)cameraTopViewDidClickCloseButton: (MPCameraTopView *)cameraTopView
{
    [self.topView.closeButton setHidden:YES animated:YES completion:nil];
    self.isRecordingVideo = NO;
    [self refreshUIWhenRecordVideo];
    self.videoTimeLabel.alpha = 0;
}

// MARK: - MPCapturingModeSwitchViewDelegate
- (void)capturingModeSwitchView:(MPCapturingModeSwitchView *)view didChangeType:(MPCapturingModeSwitchType)type
{
    
}

// MARK: - Utils
- (CGFloat)cameraViewHeightWithRatio: (MPCameraRatio)ratio
{
    CGFloat videoWidth = SCREEN_WIDTH;
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
            videoHeight = SCREEN_HEIGHT;
            break;
        default:
            break;
    }
    return videoHeight;
}

@end
