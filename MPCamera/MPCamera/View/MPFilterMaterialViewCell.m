//
//  MPFilterMaterialViewCell.m
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPFilterMaterialViewCell.h"
#import <GPUImage.h>

@interface MPFilterMaterialViewCell ()

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) UIView *selectView;

@end

@implementation MPFilterMaterialViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.picture removeAllTargets];
    self.selectView.hidden = YES;
}

- (void)setupUI
{
    self.imageView = [[GPUImageView alloc] init];
    self.picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"samperTeture.jpg"]];
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label;
    });
    self.selectView = ({
        UIView *view = [[UIView alloc] init];
        view.hidden = YES;
        view.backgroundColor = ThemeColorA(0.8);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_select"]];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        view;
    });
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(80);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageView);
    }];
    
    self.titleLabel.text = @"素描";
    GPUImageFilter *filter = [[GPUImageFilter alloc] init];
    [self.picture addTarget:filter];
    [filter addTarget:self.imageView];
    if (!self.superview) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.picture processImage];
        });
    }else {
        [self.picture processImage];
    }
    
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    
    self.selectView.hidden = !isSelect;
    self.titleLabel.textColor = isSelect ? ThemeColor : [UIColor whiteColor];
}

@end
