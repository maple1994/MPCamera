//
//  MPCapturingButton.m
//  MPCamera
//
//  Created by Maple on 2019/10/14.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPCapturingButton.h"

@interface MPCapturingButton ()

/// 录制视频暂停控件
@property (nonatomic, strong) UIView *recordStopView;

@end

@implementation MPCapturingButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.capturingState = MPCapturingButtonStateNormal;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self setImage:[UIImage imageNamed:@"btn_capture"] forState:UIControlStateNormal];
    self.recordStopView = ({
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = NO;
        view.alpha = 0;
        view.layer.cornerRadius = 5;
        view.backgroundColor = ThemeColor;
        view;
    });
    [self addSubview:self.recordStopView];
    [self.recordStopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)setCapturingState:(MPCapturingButtonState)capturingState
{
    _capturingState = capturingState;
    [self.recordStopView setHidden:capturingState == MPCapturingButtonStateNormal animated:YES completion:NULL];
}

@end
