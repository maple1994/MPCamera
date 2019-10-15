//
//  MPCamerVideoTimeLabel.m
//  MPCamera
//
//  Created by Maple on 2019/10/15.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPCamerVideoTimeLabel.h"

@interface MPCamerVideoTimeLabel ()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MPCamerVideoTimeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self updateDarkMode];
    [self updateTimeLabel];
}

- (void)updateDarkMode {
    self.timeLabel.textColor = self.isDarkMode ? [UIColor blackColor] : [UIColor whiteColor];
    
    if (self.isDarkMode) {
        [self clearShadow];
    } else {
        [self setDefaultShadow];
    }
}

- (void)updateTimeLabel {
    self.timeLabel.text = [self timeStringWithTimestamp:self.timestamp];
}

- (void)resetTime
{
    self.timestamp = 0;
}

- (void)setTimestamp:(NSInteger)timestamp
{
    _timestamp = timestamp;
    [self updateTimeLabel];
}

- (void)setIsDarkMode:(BOOL)isDarkMode
{
    _isDarkMode = isDarkMode;
    [self updateDarkMode];
}

- (NSString *)timeStringWithTimestamp:(NSInteger)timestamp {
    NSInteger second = timestamp % 60;
    NSInteger minute = (timestamp / 60) % 60;
    NSInteger hour = timestamp / 60 / 60;
    
    NSString *result = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    if (hour > 0) {
        result = [NSString stringWithFormat:@"%02ld:%@", hour, result];
    }
    return result;
}

@end
