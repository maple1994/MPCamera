//
//  MPVideoResultViewController.m
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPVideoResultViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage.h>
#import "MPFileHelper.h"
#import "MPCameraManager.h"
#import "MPAssetHelper.h"
#import "MPVideoModel.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@interface MPVideoResultViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) CALayer *lastPlayerLayer; // 为了避免两段切换的时候出现短暂白屏
@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) NSInteger currentVideoIndex;

@end

@implementation MPVideoResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self showPreview];
    [self playVideoWithIndex:self.currentVideoIndex];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setup
{
    [self setupUI];
    [self updateDarkOrNormalMode];
    [self.view layoutIfNeeded];
    self.currentVideoIndex = 0;
}

- (void)playVideoWithIndex: (NSInteger)index
{
    NSString *path = self.videos[index].filePath;
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    self.player = [AVPlayer playerWithURL:videoURL];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.playerContainerView.bounds;
    [self.playerContainerView.layer addSublayer:self.playerLayer];
    [self.player play];
    [self addObserverForPlayerItem:self.player.currentItem];
}

// MARK: - Action
- (void)confirmAction:(id)sender
{
    [self.view makeToastActivity:CSToastPositionCenter];
    void (^saveBlock)(NSString *) = ^(NSString *path){
        @weakify(self);
        [self saveVideo:path completion:^(BOOL success) {
            @strongify(self);
            if (success) {
                [self backAction:nil];
                [self.view hideToastActivity];
                [self.view.window makeToast:@"保存成功"];
            }else {
                [self.view hideToastActivity];
                [self.view.window makeToast:@"保存失败"];
            }
        }];
    };
    if (self.videos.count == 1) {
        NSString *path = [self.videos firstObject].filePath;
        saveBlock(path);
    }else {
        NSMutableArray *videoPaths = [NSMutableArray array];
        for (MPVideoModel *model in self.videos) {
            [videoPaths addObject:model.filePath];
        }
        NSString *exportPath = [MPFileHelper randomFilePathInTmpWithSuffix:@".m4v"];
        [MPAssetHelper mergeVideos:videoPaths toExporePath:exportPath completion:^{
            saveBlock(exportPath);
        }];
    }
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveVideo: (NSString *)path completion: (void(^)(BOOL success))completion
{
    NSURL *url = [NSURL fileURLWithPath:path];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:url];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue()
                       , ^{
            if (completion) {
                completion(success);
            }
        });
    }];
}

- (void)stopVideo {
    [self removeObserverForPlayerItem:self.player.currentItem];
    [self.player pause];
    [self.lastPlayerLayer removeFromSuperlayer];
    self.lastPlayerLayer = self.playerLayer;
    self.player = nil;
}

/// 添加播放结束监听
- (void)addObserverForPlayerItem:(AVPlayerItem *)playerItem {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
}

/// 移除播放结束监听
- (void)removeObserverForPlayerItem:(AVPlayerItem *)playerItem {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:playerItem];
}

- (void)playbackFinished:(NSNotification *)notification {
    [self stopVideo];
    self.currentVideoIndex = (self.currentVideoIndex + 1) % self.videos.count;
    [self playVideoWithIndex:self.currentVideoIndex];
}

// MARK: - UI
- (void)showPreview
{
    NSURL *url = [NSURL fileURLWithPath:self.videos.firstObject.filePath];
    UIImage *previewImage = [MPAssetHelper videoPreviewImageWithUrl:url];
    self.lastPlayerLayer = [CALayer layer];
    self.lastPlayerLayer.frame = self.playerContainerView.bounds;
    [self.playerContainerView.layer addSublayer:self.lastPlayerLayer];
    self.lastPlayerLayer.contents = (id)(previewImage.CGImage);
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.playerContainerView = [[UIView alloc] init];
    self.confirmButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"btn_confirm"]
                            forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.backButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setEnableDarkWithImageName:@"btn_back"];
        [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:self.playerContainerView];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.backButton];
    
    MPCameraRatio ratio = [MPCameraManager shareManager].ratio;
    CGFloat cameraHeight = [self cameraViewHeightWithRatio: ratio];
    BOOL isIPhoneX = [UIDevice is_iPhoneX_Series];
    
    [self.playerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ratio == MPCameraRatioFull) {
            make.top.equalTo(self.view);
        }else {
            CGFloat topOffset = isIPhoneX || ratio == MPCameraRatio1v1 ? 60 : 0;
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(topOffset);
            }else {
                make.top.equalTo(self.view).offset(topOffset);
            }
        }
        make.leading.trailing.equalTo(self.view);
        make.height.mas_offset(cameraHeight);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        }else {
            make.bottom.equalTo(self.view).offset(-40);
        }
    }];
    CGFloat leftOffset = (SCREEN_WIDTH * 0.5 - 0.5 - 40 - 35) * 0.5;
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.centerY.equalTo(self.confirmButton);
        make.leading.equalTo(self.view).offset(leftOffset);
    }];
}

/// 刷新黑暗模式或正常模式
- (void)updateDarkOrNormalMode
{
    MPCameraRatio ratio = [MPCameraManager shareManager].ratio;
    BOOL isBottomBarDark = ratio == MPCameraRatio1v1 || ratio == MPCameraRatio4v3;
    
    [self.backButton setIsDarkMode:isBottomBarDark];
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

#pragma clang diagnostic pop
