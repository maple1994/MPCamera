//
//  MPCapturingButton.h
//  MPCamera
//
//  Created by Maple on 2019/10/14.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MPCapturingButtonState) {
    MPCapturingButtonStateNormal,
    MPCapturingButtonStateRecording
};

@interface MPCapturingButton : UIButton

@property (nonatomic, assign) MPCapturingButtonState capturingState;

@end

NS_ASSUME_NONNULL_END
