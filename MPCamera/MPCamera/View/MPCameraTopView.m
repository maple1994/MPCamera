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
    [self addSubview:self.ratioButton];
    [self.ratioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.center.equalTo(self);
    }];
}

// MARK: - Action
- (void)ratioAction
{
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickRatioButton:)]) {
        [self.delegate cameraTopViewDidClickRatioButton:self];
    }
}


@end
