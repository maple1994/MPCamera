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

@interface MPCameraViewController ()

@property (nonatomic, strong) GPUImageView *cameraView;
@property (nonatomic, strong) MPCapturingButton *capturingButton;

@end

@implementation MPCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [[MPCameraManager shareManager] addOutputView:self.cameraView];
    [[MPCameraManager shareManager] startCapturing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

// MARK: - UI
- (void)setupUI
{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCamera];
    self.capturingButton = [[MPCapturingButton alloc] init];
    [self.capturingButton addTarget:self action:@selector(captureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.capturingButton];
    [self.capturingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        }else {
            make.bottom.equalTo(self.view).offset(-40);
        }
    }];
}

- (void)setupCamera
{
    self.cameraView = [[GPUImageView alloc] init];
    [self.view addSubview:self.cameraView];
    [self refreshCameraViewWithRatio:[MPCameraManager shareManager].ratio];
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

- (void)startRecordVideo
{
    
}

- (void)stopRecordVideo
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
