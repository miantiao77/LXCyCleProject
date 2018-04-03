//
//  LXCycleView.m
//  002-RunTime运行时初探
//
//  Created by lx on 2018/4/2.
//  Copyright © 2018年 yintu. All rights reserved.
//

#import "LXCycleView.h"
#import "LXCycleCell.h"

static const CGFloat second = 2.0;
@interface LXCycleView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView   *collectionView;
@property (nonatomic,strong) NSArray   *datas;
@property (nonatomic,strong) NSTimer   *timer;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@end
@implementation LXCycleView
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame datas:(NSArray *)datas
{
    LXCycleView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.datas = [NSMutableArray arrayWithArray:datas];
    [cycleScrollView.collectionView reloadData];
    return cycleScrollView;
}
#pragma mark - init 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization:frame];
        [self startTimer];
    }
    return self;
}
- (void)initialization:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = frame.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout = layout;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:_layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[LXCycleCell class] forCellWithReuseIdentifier:NSStringFromClass([LXCycleCell class])];
    [self addSubview:_collectionView];
}
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        _layout.scrollDirection = _scrollDirection;
    }
}
#pragma mark - Timer
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(scrollViewToNext) userInfo:nil repeats:NO];
}
- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // self.datas.count * 2      防止 第一个往左轮播时数组越界
    // self.datas.count * 2 + 1  防止 最后一个往右轮播时数组越界
    return self.datas.count * 2 + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LXCycleCell class]) forIndexPath:indexPath];
    NSInteger item = indexPath.item % self.datas.count;
    if (item < self.datas.count) {
        [cell.imgView setImage:[UIImage imageNamed:self.datas[item]]];
    }
    return cell;
}
#pragma mark - ScrollView Scroll
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollToNextDone];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToNextDone];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint target = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = target.x;
    targetContentOffset->y = target.y;
}
- (void)scrollViewToNext
{
    CGPoint center = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.center.x, self.collectionView.center.y);
    NSIndexPath *nowIndexPath = [self.collectionView indexPathForItemAtPoint:center];
    if (nowIndexPath.item  < [self.collectionView numberOfItemsInSection:0]) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:(nowIndexPath.item + 1) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
- (void)scrollToNextDone
{
    [self stopTimer];
    [self startTimer];
    CGPoint center = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.center.x, self.collectionView.center.y);
    NSIndexPath *nowIndexPath = [self.collectionView indexPathForItemAtPoint:center];
    if (nowIndexPath && self.datas.count != 0) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:(nowIndexPath.item % self.datas.count + self.datas.count) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = self.collectionView.frame.size.width;
    CGFloat preFixSize = pageSize - (CGRectGetWidth(self.collectionView.frame) - pageSize) / 2;
    NSInteger page  = round((offset.x - preFixSize)/ pageSize);
    CGFloat targetX = page * pageSize;
    return CGPointMake(targetX + preFixSize, offset.y);
}
@end
