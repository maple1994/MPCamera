//
//  MPVideoModel.h
//  MPCamera
//
//  Created by Maple on 2019/10/15.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPVideoModel : NSObject

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) AVURLAsset *asset;

@end

NS_ASSUME_NONNULL_END
