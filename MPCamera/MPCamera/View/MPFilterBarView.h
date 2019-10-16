//
//  MPFilterBarView.h
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPFilterBarView;
@protocol MPFilterBarViewDelegate <NSObject>

@end

NS_ASSUME_NONNULL_BEGIN

@interface MPFilterBarView : UIView

@property (nonatomic, assign) BOOL showing;

@end

NS_ASSUME_NONNULL_END
