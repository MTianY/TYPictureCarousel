//
//  TYHomeViewController.m
//  TYPictureCarousel
//
//  Created by 马天野 on 2017/6/10.
//  Copyright © 2017年 MTY. All rights reserved.
//

#import "TYHomeViewController.h"
#import "TYCollectionViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

static NSString *const cellID = @"cellID";
@interface TYHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) CGFloat curContentOffset_X;
@property (nonatomic, assign) CGFloat curPage;

@end

@implementation TYHomeViewController

#pragma mark - 懒加载

- (UICollectionViewFlowLayout *)flowLayout {
    if (nil == _flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.collectionView.bounds.size;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (nil == _collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 150) collectionViewLayout:self.flowLayout];
//        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (NSArray *)imageNames {
    if (nil == _imageNames) {
        _imageNames = [NSArray array];
        _imageNames = @[@"1",@"2",@"3",@"4",@"5"];
    }
    return _imageNames;
}

- (UIPageControl *)pageControl {
    if (nil == _pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.imageNames.count;
        _pageControl.pageIndicatorTintColor = [UIColor greenColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.frame = CGRectMake(kScreenWidth - 50, 150, 0, 0);
    }
    return _pageControl;
}

- (NSTimer *)timer {
    if (nil == _timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(observeTimerMethod) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - View 的生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [self.collectionView registerClass:[TYCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    // 1.添加 collectionView
    [self.view addSubview:self.collectionView];
    // 2.添加 pageControl
    [self.view addSubview:self.pageControl];
    // 3.开启定时器
    [self startTimer];
    
    self.curContentOffset_X = 0;
    
}

- (void)dealloc {
    [self stopTimer];
}

#pragma mark - 业务逻辑

// 开启定时器
- (void)startTimer {
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 关闭定时器
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

// 监听定时器事件
- (void)observeTimerMethod {
    // 1.更新 collectionView 的 X 的偏移量
    self.curContentOffset_X = self.curContentOffset_X + kScreenWidth;
    if (self.curContentOffset_X > kScreenWidth * (self.imageNames.count - 1)) {
        self.curContentOffset_X = 0;
    }
    // 2.根据偏移量改变 collectionView 显示的 cell
    [self.collectionView setContentOffset:CGPointMake(self.curContentOffset_X, 0) animated:NO];
    // 3.改变 pageControl 当前页数
    self.curPage = self.curPage + 1;
    if (self.curPage > (self.imageNames.count - 1)) {
        self.curPage = 0;
    }
    self.pageControl.currentPage = self.curPage;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.pictureName = self.imageNames[indexPath.row];
    return cell;
}

#pragma mark - UIScrollDelegate

// 用户即将拖拽时,关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

// 用户停止拖拽时,开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

// 拖拽时改变 pageControl 页码显示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 计算页码
    int page = (int)(self.collectionView.contentOffset.x / self.collectionView.frame.size.width) + 0.5;
    self.pageControl.currentPage = page;
}

@end
