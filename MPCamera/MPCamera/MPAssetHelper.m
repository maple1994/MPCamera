//
//  MPAssetHelper.m
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPAssetHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation MPAssetHelper

/// 获取视频的第一帧
+ (UIImage *)videoPreviewImageWithUrl: (NSURL *)url
{
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CGImageRef imageRef = [generator copyCGImageAtTime:time actualTime:nil error:&error];
    if (error) {
        NSAssert(NO, error.localizedDescription);
    }
    UIImage *videoImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return videoImage;
}

/// 合并视频
+ (void)mergeVideos: (NSArray *)videoPaths toExporePath: (NSString *)exportPath completion:(void (^)(void))completion
{
    AVComposition *composition = [self compositionWithVideos:videoPaths];
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    session.outputURL = [NSURL fileURLWithPath:exportPath];
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = YES;

    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

+ (AVComposition *)compositionWithVideos: (NSArray *)videoPaths
{
    return [self compositionWithVideos:videoPaths needsAudioTracks:YES];
}


/// 获取合并视频后的Composition
+ (AVComposition *)compositionWithVideos:(NSArray *)videoPaths needsAudioTracks:(BOOL)needsAudioTracks
{
    AVMutableComposition *mergeComposition = [AVMutableComposition composition];
    CMTime time = kCMTimeZero;

    // 视频轨道
    NSMutableArray *compositionVideoTracks = [NSMutableArray array];
    AVMutableCompositionTrack *compositionVideoTrack = [mergeComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTracks addObject:compositionVideoTrack];

    // 音频轨道
    NSMutableArray *compositionAudioTracks = nil;
    if (needsAudioTracks) {
        compositionAudioTracks = [NSMutableArray array];
        AVMutableCompositionTrack *compositionAudioTrack = [mergeComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTracks addObject:compositionAudioTrack];
    }

    for (int index = 0; index < videoPaths.count; index++) {
        NSString *videoPath = videoPaths[index];
        NSDictionary *inputOptions = @{AVURLAssetPreferPreciseDurationAndTimingKey : @(YES)};
        NSURL *url = [NSURL fileURLWithPath:videoPath];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:inputOptions];

        // 视频轨道
        NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        NSInteger videoDelta = videoTracks.count - compositionVideoTracks.count;
        if (videoDelta > 0) {
            // 对齐
            for(int i = 0; i < videoDelta; i++) {
                AVMutableCompositionTrack *insertCompositionVideoTrack = [mergeComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
                [compositionVideoTracks addObject:insertCompositionVideoTrack];
            }
        }
        // 将当前视频的轨道，插入合并的轨道中
        for (int i = 0; i < videoTracks.count; i++) {
            AVAssetTrack *videoTrack = videoTracks[i];
            AVMutableCompositionTrack *currentVideoCompositionTrack = compositionVideoTracks[i];
            [currentVideoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:time error:nil];
            if (index == 0) {
                [currentVideoCompositionTrack setPreferredTransform:videoTrack.preferredTransform];
            }
        }
        if (needsAudioTracks) {
            NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
            NSInteger audioDelta = audioTracks.count - compositionAudioTracks.count;
            if (audioDelta > 0) {
                // 对齐
                for (int i = 0; i < audioDelta; i++) {
                    AVMutableCompositionTrack *insertionCompositionAudioTrack = [mergeComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                    [compositionAudioTracks addObject:insertionCompositionAudioTrack];
                }
            }
            // 将当前的音频轨道，插入合并的轨道中
            for (int i = 0; i < audioTracks.count; i++) {
                AVAssetTrack *audioTrack = audioTracks[i];
                AVMutableCompositionTrack *currentAudioCompositionTrack = compositionAudioTracks[i];
                [currentAudioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioTrack atTime:time error:nil];
            }
        }
        time = CMTimeAdd(time, asset.duration);
    }
    return mergeComposition;
}

@end
