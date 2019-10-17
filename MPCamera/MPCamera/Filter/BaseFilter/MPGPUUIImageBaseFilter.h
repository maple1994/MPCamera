//
//  MPGPUUIImageBaseFilter.h
//  MPCamera
//
//  Created by Maple on 2019/10/17.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPGPUUIImageBaseFilter : GPUImageFilter

@property (nonatomic, assign) GLint timeUniform;
@property (nonatomic, assign) GLfloat time;
// 滤镜开始应用的时间
@property (nonatomic, assign) GLfloat beginTime;

@end

NS_ASSUME_NONNULL_END
