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

@interface MPCameraViewController ()<MPCameraTopViewDelegate>

@property (nonatomic, strong) GPUImageView *cameraView;
@property (nonatomic, strong) MPCapturingButton *capturingButton;
@property (nonatomic, strong) MPCameraTopView *topView;
/// 设置比例时的毛玻璃View
@property (nonatomic, strong) UIView *ratioBlurView;
@property (nonatomic, assign) BOOL isChangingRatio;
@property (nonatomic, strong) UIView *focusView;

@end

@implementation MPCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
    [CSToastManager setDefaultDuration:1];
    [[MPCameraManager shareManager] addOutputView:self.cameraView];
    [[MPCameraManager shareManager] startCapturing];
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
    [self.view addSubview:self.ratioBlurView];
    [self.view addSubview:self.capturingButton];
    [self.view addSubview:self.topView];
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
    [self.topView.flashButton setIsDarkMode:isTopBarDark];
    [self.topView.ratioButton setIsDarkMode:isTopBarDark];
    [self.topView.rotateButton setIsDarkMode:isTopBarDark];
    [self.topView.closeButton setIsDarkMode:isTopBarDark];
    
//    BOOL isBottomBarDatk = ratio == MPCameraRatio1v1 || ratio == MPCameraRatio4v3;
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
    [self takePhoto];
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

- (void)tapAction: (UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.cameraView];
    [[MPCameraManager shareManager] setFocusPoint:location];
    [self showFocusViewWithLocation:location];
}

- (void)pinchAction: (UIPinchGestureRecognizer *)recognizer
{
    
}


- (void)startRecordVideo
{
    
}

- (void)stopRecordVideo
{
    
}

// MARK: - MPCameraTopViewDelegate
- (void)cameraTopViewDidClickRotateButton: (MPCameraTopView *)cameraTopView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MPCameraManager shareManager] rotateCamera];
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
