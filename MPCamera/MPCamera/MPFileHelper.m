//
//  MPFileHelper.m
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPFileHelper.h"

@implementation MPFileHelper

/// 返回tmp文件夹
+ (NSString *)temporaryDirectory
{
    return NSTemporaryDirectory();
}

/// 通过文件名返回tmp文件夹中的文件路径
+ (NSString *)filePathInTmpWithName: (NSString *)name
{
    return [[self temporaryDirectory] stringByAppendingPathComponent:name];
}

/// 通过后缀，返回tmp文件夹中的一个随机路径
+ (NSString *)randomFilePathInTmpWithSuffix: (NSString *)suffix
{
    long random = [[NSDate date] timeIntervalSince1970] * 1000;
    return [[self filePathInTmpWithName:[NSString stringWithFormat:@"%ld", random]] stringByAppendingString:suffix];
}

@end
