//
//  MPCameraTopView.h
//  MPCamera
//
//  Created by Maple on 2019/10/14.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MPCameraTopView;
@protocol MPCameraTopViewDelegate <NSObject>

- (void)cameraTopViewDidClickRotateButton: (MPCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickFlashButton: (MPCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickRatioButton: (MPCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickCloseButton: (MPCameraTopView *)cameraTopView;

@end

@interface MPCameraTopView : UIView

@property (nonatomic, strong, readonly) UIButton *rotateButton;
@property (nonatomic, strong, readonly) UIButton *flashButton;
@property (nonatomic, strong, readonly) UIButton *ratioButton;
@property (nonatomic, strong, readonly) UIButton *closeButton;
@property (nonatomic, weak) id<MPCameraTopViewDelegate> delegate;

- (void)refreshUIWithIsRecording: (BOOL)isRecording;
- (void)updateDarkMode: (BOOL)isDark;

@end

NS_ASSUME_NONNULL_END
