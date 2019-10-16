//
//  MPFileHelper.h
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPFileHelper : NSObject

/// 返回tmp文件夹
+ (NSString *)temporaryDirectory;
/// 通过文件名返回tmp文件夹中的文件路径
+ (NSString *)filePathInTmpWithName: (NSString *)name;
/// 通过后缀，返回tmp文件夹中的一个随机路径
+ (NSString *)randomFilePathInTmpWithSuffix: (NSString *)suffix;

@end

NS_ASSUME_NONNULL_END
