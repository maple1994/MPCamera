//
//  MPPhotoResultViewController.m
//  MPCamera
//
//  Created by Maple on 2019/10/14.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPPhotoResultViewController.h"
#import "MPCameraManager.h"
#import <Photos/Photos.h>

@interface MPPhotoResultViewController ()

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation MPPhotoResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.contentImageView.image = self.resultImage;
}

- (void)setupUI
{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentImageView = [[UIImageView alloc] init];
    MPCameraRatio ratio = [MPCameraManager shareManager].ratio;
    CGFloat contentH = [self cameraViewHeightWithRatio:ratio];
    BOOL isIphoneX = [UIDevice is_iPhoneX_Series];
    self.confirmButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.backButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    [self.view addSubview:self.contentImageView];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.backButton];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ratio == MPCameraRatioFull) {
            make.top.equalTo(self.view);
        }else {
            CGFloat topOffset = isIphoneX || ratio == MPCameraRatio1v1 ? 60 : 0;
            if (@available(iOS 11.0, *)) {
                make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(topOffset);
            }else {
                make.top.equalTo(self.view).offset(topOffset);
            }
        }
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(contentH);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        }else {
            make.bottom.equalTo(self.view).offset(-40);
        }
    }];
    CGFloat leftOffset = (SCREEN_WIDTH * 0.5 - 40 - 35) * 0.5;
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.confirmButton);
        make.height.width.mas_equalTo(35);
        make.leading.equalTo(self.view).offset(leftOffset);
    }];
}

- (void)updateDarkOrNormalMode
{
    MPCameraRatio ratio = [MPCameraManager shareManager].ratio;
    BOOL isBottomBarDark = ratio == MPCameraRatio1v1 || ratio == MPCameraRatio4v3;
    [self.backButton setIsDarkMode:isBottomBarDark];
}

- (void)confirmAction
{
    @weakify(self);
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        @strongify(self);
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.resultImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self backAction];
            [self.view.window makeToast:@"保存成功"];
        });
    }];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}

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
