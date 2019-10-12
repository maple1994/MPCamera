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

@interface MPCameraViewController ()

@property (nonatomic, strong) GPUImageView *cameraView;

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

- (void)setupUI
{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCamera];
}

- (void)setupCamera
{
    self.cameraView = [[GPUImageView alloc] init];
    [self.view addSubview:self.cameraView];
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
