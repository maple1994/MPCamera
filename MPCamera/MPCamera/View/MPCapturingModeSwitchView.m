//
//  MPCapturingModeSwitchView.m
//  MPCamera
//
//  Created by Maple on 2019/10/15.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPCapturingModeSwitchView.h"

@interface MPCapturingModeSwitchView ()

@property (nonatomic, assign, readwrite) MPCapturingModeSwitchType type;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UILabel *videoLabel;

@end

@implementation MPCapturingModeSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.type = MPCapturingModeSwitchTypeImage;
    self.imageLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"拍照";
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.tag = 101;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
        [label addGestureRecognizer:tap];
        label;
    });
    self.videoLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"录制";
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.textColor = RGBA(255, 255, 255, 0.6);
        label.font = [UIFont boldSystemFontOfSize:12];
        label.tag = 102;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
        [label addGestureRecognizer:tap];
        label;
    });
    [self addSubview:self.imageLabel];
    [self addSubview:self.videoLabel];
    [self.imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
}

- (void)tapLabel: (UITapGestureRecognizer *)recognizer
{
    MPCapturingModeSwitchType newType = MPCapturingModeSwitchTypeImage;
    NSUInteger index = recognizer.view.tag - 100;
    if (index == 1) {
        // 拍照
        newType = MPCapturingModeSwitchTypeImage;
    }else if (index == 2) {
        // 录制
        newType = MPCapturingModeSwitchTypeVideo;
    }
    if (newType == self.type)
        return;
    self.type = newType;
    [self updateDarkMode];
    if ([self.delegate respondsToSelector:@selector(capturingModeSwitchView:didChangeType:)]) {
        [self.delegate capturingModeSwitchView:self didChangeType:self.type];
    }
}

- (void)updateDarkMode
{
    UILabel *selectedLabel = nil;
    UILabel *normalLabel = nil;
    if (self.type == MPCapturingModeSwitchTypeImage) {
        selectedLabel = self.imageLabel;
        normalLabel = self.videoLabel;
    } else {
        selectedLabel = self.videoLabel;
        normalLabel = self.imageLabel;
    }
    selectedLabel.font = [UIFont boldSystemFontOfSize:12];
    normalLabel.font = [UIFont systemFontOfSize:12];
    selectedLabel.textColor = self.isDarkMode ? [UIColor blackColor] : [UIColor whiteColor];
    normalLabel.textColor = self.isDarkMode ? RGBA(0, 0, 0, 0.6) : RGBA(255, 255, 255, 0.6);
    if (self.isDarkMode) {
        [self clearShadow];
    } else {
        [self setDefaultShadow];
    }
}

- (void)setIsDarkMode:(BOOL)isDarkMode
{
    _isDarkMode = isDarkMode;
    [self updateDarkMode];
}

@end
