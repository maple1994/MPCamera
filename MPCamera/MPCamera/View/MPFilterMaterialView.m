//
//  MPFilterMaterialView.m
//  MPCamera
//
//  Created by Maple on 2019/10/16.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPFilterMaterialView.h"
#import "MPFilterMaterialViewCell.h"

static NSString * const kCCFilterMaterialViewReuseIdentifier = @"CCFilterMaterialViewReuseIdentifier";

@interface MPFilterMaterialView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) MPFilterMaterialModel *selectMaterialModel;

@end

@implementation MPFilterMaterialView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup
{
    [self createCollectionViewLayout];
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[self bounds] collectionViewLayout:_collectionViewLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[MPFilterMaterialViewCell class] forCellWithReuseIdentifier:kCCFilterMaterialViewReuseIdentifier];
        collectionView;
    });
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)createCollectionViewLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置间距
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 0;
    
    //设置item尺寸
    CGFloat itemW = 60;
    CGFloat itemH = 100;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    // 设置水平滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionViewLayout = flowLayout;
}

- (void)selectIndex:(NSIndexPath *)indexPath {
    MPFilterMaterialViewCell *lastSelectCell = (MPFilterMaterialViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    MPFilterMaterialViewCell *currentSelectCell = (MPFilterMaterialViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    lastSelectCell.isSelect = NO;
    currentSelectCell.isSelect = YES;
    
    self.currentIndex = indexPath.row;
    self.selectMaterialModel = self.filterList[self.currentIndex];

    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if ([self.delegate respondsToSelector:@selector(filterMaterialView:didScrollToIndex:)]) {
        [self.delegate filterMaterialView:self didScrollToIndex:self.currentIndex];
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPFilterMaterialViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCFilterMaterialViewReuseIdentifier forIndexPath:indexPath];
    cell.materialModel = self.filterList[indexPath.row];
    cell.isSelect = cell.materialModel == self.selectMaterialModel;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectIndex:indexPath];
}

- (void)setFilterList:(NSArray<MPFilterMaterialModel *> *)filterList
{
    _filterList = filterList;
    [self.collectionView reloadData];
    if ([filterList containsObject:self.selectMaterialModel]) {
        NSInteger index = [filterList indexOfObject:self.selectMaterialModel];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else {
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

@end
