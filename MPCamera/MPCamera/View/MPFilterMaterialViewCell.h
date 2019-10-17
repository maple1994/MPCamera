//
//  MPFilterMaterialViewCell.h
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPFilterMaterialModel;
NS_ASSUME_NONNULL_BEGIN

@interface MPFilterMaterialViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) MPFilterMaterialModel *materialModel;

@end

NS_ASSUME_NONNULL_END
