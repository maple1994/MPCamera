//
//  MPFilterHandler.h
//  MPCamera
//
//  Created by Maple on 2019/10/12.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPFilterHandler : NSObject

/// 是否开启美颜
@property (nonatomic, assign) BOOL beatuifyFilterEnable;
/// 美颜程度0~1，默认0.5
@property (nonatomic, assign) CGFloat beatuifyFilterDegree;
/// 滤镜链Source
@property (nonatomic, weak) GPUImageOutput *source;

- (GPUImageFilter *)firstFilter;
- (GPUImageFilter *)lastFilter;
/// 设置裁剪比例，用于设置特殊的相机比例
- (void)setCropRect: (CGRect)cropRect;
- (void)addFilter: (GPUImageFilter *)filter;
/// 设置效果滤镜
- (void)setEffectFilter: (nullable GPUImageFilter *)filter;

@end

NS_ASSUME_NONNULL_END
