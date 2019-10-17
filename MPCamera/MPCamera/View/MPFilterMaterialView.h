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

@class MPFilterMaterialView;

@protocol MPFilterMaterialViewDelegate <NSObject>

- (void)filterMaterialView: (MPFilterMaterialView *)materialView didScrollToIndex: (NSUInteger)index;

@end

/// 选择滤镜的View
@interface MPFilterMaterialView : UIView

@property (nonatomic, strong) NSArray<MPFilterMaterialModel *> *filterList;
@property (nonatomic, weak) id<MPFilterMaterialViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
