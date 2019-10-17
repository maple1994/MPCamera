//
//  MPGPUUIImageBaseFilter.m
//  MPCamera
//
//  Created by Maple on 2019/10/17.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPGPUImageBaseFilter.h"

@implementation MPGPUImageBaseFilter

- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString
            fragmentShaderFromString:(NSString *)fragmentShaderString {
    self = [super initWithVertexShaderFromString:vertexShaderString fragmentShaderFromString:fragmentShaderString];
    self.timeUniform = [filterProgram uniformIndex:@"time"];
    self.time = 0.0f;
    return self;
}

- (void)setTime:(GLfloat)time
{
    _time = time;
    [self setFloat:time forUniform:self.timeUniform program:filterProgram];
}

@end
