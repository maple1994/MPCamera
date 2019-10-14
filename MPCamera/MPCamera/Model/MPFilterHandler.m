//
//  MPFilterHandler.m
//  MPCamera
//
//  Created by Maple on 2019/10/12.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPFilterHandler.h"

@interface MPFilterHandler ()

@property (nonatomic, strong) NSMutableArray<GPUImageFilter *> *filters;
@property (nonatomic, strong) GPUImageCropFilter *currentCropFilter;
@property (nonatomic, weak) GPUImageFilter *currentBeautifyFilter;
@property (nonatomic, weak) GPUImageFilter *currentEffectFilter;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation MPFilterHandler

- (instancetype)init
{
    if (self = [super init]) {
        self.filters = [NSMutableArray array];
        [self addCropFilter];
    }
    return self;
}

- (GPUImageFilter *)firstFilter
{
    return self.filters.firstObject;
}

- (GPUImageFilter *)lastFilter
{
    return self.filters.lastObject;
}

/// 设置裁剪比例，用于设置特殊的相机比例
- (void)setCropRect: (CGRect)cropRect
{
    self.currentCropFilter.cropRegion = cropRect;
}

- (void)addFilter: (GPUImageFilter *)filter
{
    NSArray *targets = self.filters.lastObject.targets;
    [self.filters.lastObject removeAllTargets];
    [self.filters.lastObject addTarget:filter];
    for (id<GPUImageInput> input in targets) {
        [filter addTarget:input];
    }
    [self.filters addObject:filter];
}

/// 设置效果滤镜
- (void)setEffectFilter: (GPUImageFilter *)filter
{
    
}

- (void)addCropFilter
{
    self.currentCropFilter = [[GPUImageCropFilter alloc] init];
    [self addFilter:self.currentCropFilter];
}

@end
