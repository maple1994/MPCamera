//
//  MPCameraTopView.m
//  MPCamera
//
//  Created by Maple on 2019/10/14.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPCameraTopView.h"

@interface MPCameraTopView ()

@property (nonatomic, strong, readwrite) UIButton *rotateButton;
@property (nonatomic, strong, readwrite) UIButton *flashButton;
@property (nonatomic, strong, readwrite) UIButton *ratioButton;
@property (nonatomic, strong, readwrite) UIButton *closeButton;
@property (nonatomic, assign) BOOL isRotating;

@end

@implementation MPCameraTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.ratioButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(ratioAction) forControlEvents:UIControlEventTouchUpInside];
        [btn setEnableDarkWithImageName:@"btn_ratio_9v16"];
        btn;
    });
    self.rotateButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(rotateAction) forControlEvents:UIControlEventTouchUpInside];
        [btn setEnableDarkWithImageName:@"btn_rotato"];
        btn;
    });
    self.flashButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(flashAction) forControlEvents:UIControlEventTouchUpInside];
        [btn setEnableDarkWithImageName:@"btn_flash_off"];
        btn;
    });
    
    [self addSubview:self.ratioButton];
    [self addSubview:self.rotateButton];
    [self addSubview:self.flashButton];
    
    [self.ratioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.center.equalTo(self);
    }];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-20);
    }];
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(20);
    }];
}

// MARK: - Action
- (void)ratioAction
{
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickRatioButton:)]) {
        [self.delegate cameraTopViewDidClickRatioButton:self];
    }
}

- (void)flashAction
{
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickFlashButton:)]) {
        [self.delegate cameraTopViewDidClickFlashButton:self];
    }
}

- (void)rotateAction
{
    if (self.isRotating) {
        return;
    }
    self.isRotating = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.rotateButton.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        self.isRotating = NO;
        self.rotateButton.transform = CGAffineTransformIdentity;
    }];
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickRotateButton:)]) {
        [self.delegate cameraTopViewDidClickRotateButton:self];
    }
}

@end
