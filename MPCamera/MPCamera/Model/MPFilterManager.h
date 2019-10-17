//
//  MPFilterManager.h
//  MPCamera
//
//  Created by Maple on 2019/10/17.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPFilterMaterialModel.h"
#import <GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPFilterManager : NSObject

/// GPUImage 自带滤镜列表
@property (nonatomic, strong, readonly) NSArray<MPFilterMaterialModel *> *defaultFilters;
/// GPUImage 自定义滤镜列表
@property (nonatomic, strong, readonly) NSArray<MPFilterMaterialModel *> *defineFilters;

+ (instancetype)shareManager;

/// 根据滤镜IDh获取滤镜对象
- (GPUImageFilter *)filterWithFilterID: (NSString *)filterID;

@end

NS_ASSUME_NONNULL_END
