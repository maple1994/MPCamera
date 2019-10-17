//
//  MPFilterBarView.m
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPFilterBarView.h"
#import "MPFilterCategoryView.h"
#import "MPFilterMaterialView.h"

static CGFloat const kFilterMatrialViewHeight = 100.0f;

@interface MPFilterBarView ()

@property (nonatomic, strong) MPFilterMaterialView *filterMaterialView;
@property (nonatomic, strong) MPFilterCategoryView *filterCategoryView;
@property (nonatomic, strong) UISwitch *beautifySwitch;
@property (nonatomic, strong) UISlider *beautifySlider;

@end

@implementation MPFilterBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setupUI];
    return self;
}

- (void)setupUI
{
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.filterMaterialView = [[MPFilterMaterialView alloc] init];
    self.filterCategoryView = ({
        MPFilterCategoryView *view = [[MPFilterCategoryView alloc] init];
        view.itemNormalColor = [UIColor whiteColor];
        view.itemSelectColor = ThemeColor;
        view.itemList = @[@"内置", @"自定义"];
        view.itemFont = [UIFont systemFontOfSize:14];
        view.itemWidth = 65;
        view.bottomLineWidth = 30;
        view;
    });
    self.beautifySwitch = [[UISwitch alloc] init];
    self.beautifySwitch.onTintColor = ThemeColor;
    self.beautifySwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self.beautifySwitch addTarget:self
                            action:@selector(beautifySwitchValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    self.beautifySlider = [[UISlider alloc] init];
    self.beautifySlider.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.beautifySlider.minimumTrackTintColor = [UIColor whiteColor];
    self.beautifySlider.maximumTrackTintColor = RGBA(255, 255, 255, 0.6);
    self.beautifySlider.value = 0.5;
    self.beautifySlider.alpha = 0;
    [self.beautifySlider addTarget:self
                            action:@selector(beautifySliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    UILabel *switchLabel = [[UILabel alloc] init];
    switchLabel.textColor = [UIColor whiteColor];
    switchLabel.font = [UIFont systemFontOfSize:12];
    switchLabel.text = @"美颜";
       
    [self addSubview:self.filterMaterialView];
    [self addSubview:self.filterCategoryView];
    [self addSubview:self.beautifySwitch];
    [self addSubview:self.beautifySlider];
    [self addSubview:switchLabel];
    
    [self.filterCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(35);
    }];
    [self.filterMaterialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self).offset(50);
        make.height.mas_equalTo(kFilterMatrialViewHeight);
    }];
    [self.beautifySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(8);
        make.top.equalTo(self.filterMaterialView.mas_bottom).offset(8);
    }];
    [switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.beautifySwitch.mas_trailing).offset(3);
        make.centerY.equalTo(self.beautifySwitch);
    }];
    [self.beautifySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.beautifySwitch.mas_trailing).offset(30);
        make.centerY.equalTo(self.beautifySwitch);
        make.trailing.equalTo(self).offset(-10);
    }];
}

- (void)beautifySwitchValueChanged: (UISwitch *)sender
{
    [self.beautifySlider setHidden:!sender.isOn animated:YES completion:nil];
}

- (void)beautifySliderValueChanged: (UISlider *)slider
{
    
}

@end
