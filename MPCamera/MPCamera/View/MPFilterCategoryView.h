//
//  MPFilterCategoryView.h
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 选择内置滤镜或自定义滤镜的View
@interface MPFilterCategoryView : UIView

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, assign) CGFloat bottomLineWidth;
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong) NSArray <NSString *> *itemList;

- (void)scrollToIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
