//
//  MPCapturingModeSwitchView.h
//  MPCamera
//
//  Created by Maple on 2019/10/15.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MPCapturingModeSwitchType) {
    MPCapturingModeSwitchTypeImage,
    MPCapturingModeSwitchTypeVideo
};

@class MPCapturingModeSwitchView;

@protocol MPCapturingModeSwitchViewDelegate <NSObject>

- (void)capturingModeSwitchView: (MPCapturingModeSwitchView *)view didChangeType: (MPCapturingModeSwitchType)type;

@end

@interface MPCapturingModeSwitchView : UIView

@property (nonatomic, assign, readonly) MPCapturingModeSwitchType type;
@property (nonatomic, assign) BOOL isDarkMode;
@property (nonatomic, weak) id<MPCapturingModeSwitchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
