//
//  MPCameraManager.h
//  MPCamera
//
//  Created by Maple on 2019/10/12.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TakePhotoResult)(UIImage *resultImage, NSError *error);
typedef void (^RecordVideoResult)(NSString *videoPath);

NS_ASSUME_NONNULL_BEGIN

@interface MPCameraManager : NSObject



@end

NS_ASSUME_NONNULL_END
