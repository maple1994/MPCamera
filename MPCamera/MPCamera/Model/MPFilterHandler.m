//
//  MPFilterHandler.m
//  MPCamera
//
//  Created by Maple on 2019/10/12.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPFilterHandler.h"
#import "MPGPUUIImageBaseFilter.h"

@interface MPFilterHandler ()

@property (nonatomic, strong) NSMutableArray<GPUImageFilter *> *filters;
@property (nonatomic, strong) GPUImageCropFilter *currentCropFilter;
@property (nonatomic, weak) GPUImageFilter *currentBeautifyFilter;
@property (nonatomic, weak) GPUImageFilter *currentEffectFilter;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation MPFilterHandler

- (void)dealloc
{
    [self endDisplayLink];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.filters = [NSMutableArray array];
        [self addCropFilter];
        [self setupDisplayLink];
        _beatuifyFilterDegree = 0.5f;
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
    if (!filter) {
        filter = [[GPUImageFilter alloc] init];
    }
    if (!self.currentEffectFilter) {
        [self addFilter:filter];
    }else {
        NSInteger index = [self.filters indexOfObject:self.currentEffectFilter];
        GPUImageOutput *source = index == 0 ? self.source : self.filters[index - 1];
        for (id<GPUImageInput> input in self.currentEffectFilter.targets) {
            [filter addTarget:input];
        }
        [source removeTarget:self.currentEffectFilter];
        [self.currentEffectFilter removeAllTargets];
        [source addTarget:filter];
        self.filters[index] = filter;
    }
    self.currentEffectFilter = filter;
    if ([self.currentEffectFilter isKindOfClass:[MPGPUUIImageBaseFilter class]]) {
         MPGPUUIImageBaseFilter *filter = (MPGPUUIImageBaseFilter *)self.currentEffectFilter;
        filter.beginTime = self.displayLink.timestamp;
    }
}

- (void)addCropFilter
{
    self.currentCropFilter = [[GPUImageCropFilter alloc] init];
    [self addFilter:self.currentCropFilter];
}

- (void)setupDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayAction
{
    if ([self.currentEffectFilter isKindOfClass:[MPGPUUIImageBaseFilter class]]) {
        MPGPUUIImageBaseFilter *filter = (MPGPUUIImageBaseFilter *)self.currentEffectFilter;
        filter.time = self.displayLink.timestamp - filter.beginTime;
    }
}

- (void)endDisplayLink
{
    [self.displayLink invalidate];
}

@end
