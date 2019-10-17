//
//  MPFilterBarView.h
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPFilterBarView;
@class MPFilterMaterialModel;
@protocol MPFilterBarViewDelegate <NSObject>

- (void)filterBarView: (MPFilterBarView *)filterBarView categoryDidScrollToIndex: (NSInteger)index;
- (void)filterBarView: (MPFilterBarView *)filterBarView materiaDidScrollToIndex:(NSInteger)index;
- (void)filterBarView: (MPFilterBarView *)filterBarView beautifySwitchIsOn: (BOOL)isOn;
- (void)filterBarView: (MPFilterBarView *)filterBarView beautifySliderChangeValue: (CGFloat)value;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MPFilterBarView : UIView

@property (nonatomic, assign) BOOL showing;
@property (nonatomic, weak) id<MPFilterBarViewDelegate> delegate;

/// GPUImage 自带滤镜列表
@property (nonatomic, copy) NSArray<MPFilterMaterialModel *> *defaultFilters;
/// GPUImage 自定义滤镜列表
@property (nonatomic, copy) NSArray<MPFilterMaterialModel *> *defineFilters;
- (NSInteger)currentCategoryIndex;

@end

NS_ASSUME_NONNULL_END
