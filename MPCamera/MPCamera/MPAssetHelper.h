//
//  MPAssetHelper.h
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPAssetHelper : NSObject

/// 获取视频的第一帧
+ (UIImage *)videoPreviewImageWithUrl: (NSURL *)url;
/// 合并视频
+ (void)mergeVideos: (NSArray *)videoPaths toExporePath: (NSString *)exportPath completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
