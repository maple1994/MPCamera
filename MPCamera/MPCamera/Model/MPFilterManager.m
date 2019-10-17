//
//  MPFilterManager.m
//  MPCamera
//
//  Created by Maple on 2019/10/17.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPFilterManager.h"

static MPFilterManager *_manager;

@interface MPFilterManager ()

@property (nonatomic, strong, readwrite) NSArray<MPFilterMaterialModel *> *defaultFilters;
@property (nonatomic, strong, readwrite) NSArray<MPFilterMaterialModel *> *defineFilters;

@property (nonatomic, strong) NSDictionary *defaultFilterMaterialsInfo;
@property (nonatomic, strong) NSDictionary *defineFilterMaterialsInfo;

@property (nonatomic, strong) NSMutableDictionary *filterClassInfo;

@end

@implementation MPFilterManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MPFilterManager alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    [self setup];
    return self;
}

- (void)setup
{
    self.filterClassInfo = [NSMutableDictionary dictionary];
    [self setupDefineFiltersInfo];
    [self setupDefaultFiltersInfo];
}

- (void)setupDefaultFiltersInfo
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DefaultFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.defaultFilterMaterialsInfo = [info copy];
    for(NSDictionary *dict in info[@"Default"]) {
        self.filterClassInfo[dict[@"filter_id"]] = dict[@"filter_class"];
    }
}

- (void)setupDefineFiltersInfo
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DefineFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.defineFilterMaterialsInfo = [info copy];
    for(NSDictionary *dict in info[@"Default"]) {
        self.filterClassInfo[dict[@"filter_id"]] = dict[@"filter_class"];
    }
}

/// 根据滤镜IDh获取滤镜对象
- (GPUImageFilter *)filterWithFilterID: (NSString *)filterID
{
    NSString *className = self.filterClassInfo[filterID];
    Class filterClass = NSClassFromString(className);
    return [[filterClass alloc] init];
}

- (NSArray<MPFilterMaterialModel *> *)defaultFilters
{
    if (!_defaultFilters) {
        NSMutableArray *modelArr = [NSMutableArray array];
        for(NSDictionary *dict in self.defaultFilterMaterialsInfo[@"Default"]) {
            MPFilterMaterialModel *model = [[MPFilterMaterialModel alloc] init];
            model.filterID = dict[@"filter_id"];
            model.filterName = dict[@"filter_name"];
            
            [modelArr addObject:model];
        }
        _defaultFilters = [modelArr copy];
    }
    return _defaultFilters;
}

- (NSArray<MPFilterMaterialModel *> *)defineFilters
{
    if (!_defineFilters) {
        NSMutableArray *modelArr = [NSMutableArray array];
        for(NSDictionary *dict in self.defineFilterMaterialsInfo[@"Default"]) {
            MPFilterMaterialModel *model = [[MPFilterMaterialModel alloc] init];
            model.filterID = dict[@"filter_id"];
            model.filterName = dict[@"filter_name"];
            
            [modelArr addObject:model];
        }
        _defineFilters = [modelArr copy];
    }
    return _defineFilters;
}

@end
