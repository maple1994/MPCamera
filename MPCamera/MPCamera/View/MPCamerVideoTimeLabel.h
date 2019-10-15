//
//  MPCamerVideoTimeLabel.h
//  MPCamera
//
//  Created by Maple on 2019/10/15.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPCamerVideoTimeLabel : UIView

@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, assign) BOOL isDarkMode;

// 重置时间
- (void)resetTime;

@end

NS_ASSUME_NONNULL_END
