//
//  MPVideoResultViewController.h
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MPVideoModel;

@interface MPVideoResultViewController : UIViewController

@property (nonatomic, copy) NSArray<MPVideoModel *>*videos;

@end

NS_ASSUME_NONNULL_END
