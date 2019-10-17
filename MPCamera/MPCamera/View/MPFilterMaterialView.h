//
//  MPFilterMaterialView.h
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFilterMaterialModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 选择滤镜的View
@interface MPFilterMaterialView : UIView

@property (nonatomic, strong) NSArray<MPFilterMaterialModel *> *filterList;

@end

NS_ASSUME_NONNULL_END
