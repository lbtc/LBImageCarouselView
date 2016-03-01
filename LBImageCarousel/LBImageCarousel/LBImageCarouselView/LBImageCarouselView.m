//
//  LBImageCarouselView.m
//  图片轮播器
//
//  Created by 李斌 on 15/11/26.
//  Copyright © 2015年 Libin. All rights reserved.
//

#import "LBImageCarouselView.h"

@interface LBImageCarouselView  ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSArray *modelArray;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,copy) NSString *CellID;
//当前需要显示的图片的索引
@property (nonatomic,assign) NSInteger currentIndex;
//需要轮播的图片的总数
@property (nonatomic,assign) NSInteger imageCount;
//定时器
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation LBImageCarouselView

#pragma mark- 初始化设置方法
- (instancetype)initWithFrame:(CGRect)frame AndWithModelArray:(NSArray *)modelArray AndWithClassNameOfCell:(NSString *)cellClassName AndWithCellType:(LBCellType)cellType AndWithTimeInterval:(NSTimeInterval)timeInterval{
    if (self = [super initWithFrame:frame collectionViewLayout:self.flowLayout]) {
        //存储模型数据
        _modelArray = modelArray;
        _imageCount = _modelArray.count;
        _currentIndex = 0;
        _timeInterval = timeInterval;
        //设置collectionView的各种属性
        [self settingCollectionView];
        //注册cell,兼容代码，xib，storyboard三种形式
        [self settingCollectionViewCellWithClassName:cellClassName AndWithCellType:cellType];
        // collectionView默认滚动到第一个cell
        [self scrollToFirstItem];
        //添加定时器使图片默认自动滚动
        [self addTimer];
    }
    return self;
}

- (void)settingCollectionView{
    //关闭弹簧效果
    self.bounces = NO;
    //设置分页效果
    self.pagingEnabled = YES;
    //设置是滚动条
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    //设置代理
    self.delegate = self;
    self.dataSource = self;
}

//注册cell,兼容代码，xib，storyboard三种形式
- (void)settingCollectionViewCellWithClassName:(NSString *)cellClassName AndWithCellType:(LBCellType)cellType{
    self.CellID = cellClassName;
    if (self.CellID == nil) {
        cellType = 0;
    }
    //设置cell的大小
    _flowLayout.itemSize = self.bounds.size;
    switch (cellType) {
        case LBCording:{
            //代码
            [self registerClass:NSClassFromString(cellClassName) forCellWithReuseIdentifier:self.CellID];
        }
            break;
        case LBXib:{
            //xib
            UINib *nib = [UINib nibWithNibName:self.CellID bundle:nil];
            [self registerNib:nib forCellWithReuseIdentifier:self.CellID];
        }
            break;
        case LBStoryboard:{
            //storyboard
            NSLog(@"暂时不支持storyboard直接创建的cell");
            self.CellID = @"LBDefultImageCell";
            [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:self.CellID];
        }
            break;
        default:{
            NSLog(@"您没有自定义cell，将自动创建系统默认cell");
            self.CellID = @"LBDefultImageCell";
            [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:self.CellID];
        }
            break;
    }
}

#pragma mark- 处理定时器滚动图片的方法
//添加定时器
- (void)addTimer{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//移除定时器
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

//让定时器去控制滚动页面
- (void)nextPage{
    CGFloat offsetX = 2 * self.frame.size.width;
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark- 处理图片滚动的方法
//collectionView滚动到第一个cell
- (void)scrollToFirstItem{
    NSIndexPath *path = [NSIndexPath indexPathForItem:1 inSection:0];
    [self scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
//使第一个cell显示滚动后的图片，并且滚动到第一个cell
- (void)displayNextPageInFirstCell:(UIScrollView *)scrollView{
    // 当滚到第0个cell时offset.x = 0 计算后得到 -1
    // 当滚动到第2个cell时offset.x / collectionView的宽 = 2 - 1 = 1
    NSInteger offset = scrollView.contentOffset.x / scrollView.bounds.size.width - 1;
    // 如果滚动完之后再还是在第一个cell的位置直接返回
    if (offset == 0) {
        return;
    }
    // 计算当前应该显示第几张图片
    // 如果向右滚时 (0 + -1 + 9) % 9 = 8 显示第8张图片;
    // 如果向左滚时 (0 +  1 + 9) % 9 = 1 显示第1张图片;
    NSInteger page = (self.currentIndex + offset + _imageCount) % _imageCount;
    //只有当确定翻页时才改变currentIndex
    self.currentIndex = page;
    // 让当前任务在主线程执行,如果主线程当前有任务，就不执行调度任务,等待前面执行完成之后再执行
    dispatch_async(dispatch_get_main_queue(), ^{
        //默认滚动到第1个cell,等待前面的线程执行完成再执行滚动到第一个cell,如果不开线程会导致滚动完成切到第一个cell时不会进行复用
        [self scrollToFirstItem];
        [self updatePageOfPageControl];
    });
}

#pragma mark- 处理pageControl的滚动
//重写setter方法，设置pageControl的page总数
- (void)setPageControl:(UIPageControl *)pageControl{
    _pageControl = pageControl;
    if (_pageControl) {
        _pageControl.numberOfPages = self.imageCount;
        _pageControl.enabled = NO;
    }
}
//更新pageControl的当前页
- (void)updatePageOfPageControl{
    if (_pageControl) {
        _pageControl.currentPage = _currentIndex;
    }
}

#pragma mark- scrollView的代理方法
/*
 用定时器实现滚动时调：scrollViewDidEndScrollingAnimation
 手动拖动滚动时调：scrollViewDidEndDecelerating
只有用[self setContentOffset:CGPointMake(offsetX, 0) animated:YES];这个方法滚动，结束后才会调用scrollViewDidEndScrollingAnimation方法，手动滚动不会调用
 */
 //结束动画滚动时调用，用来实现定时器滚动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self displayNextPageInFirstCell:scrollView];
}
// 当降速完成时调用，用来实现手动滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self displayNextPageInFirstCell:scrollView];
}
//开始拖拽时调用，停止定时器，避免手动拖拽和定时器拖拽冲突
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
//停止拖拽的时候调用, 重新开启定时器，进行自动滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //停止拖拽后应该延迟1秒再加定时器自动滚动
    [self addTimer];
}

#pragma mark- collectionView代理方法
//设置cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
//设置cell,当有一个新的cell进入可视范围时就来调用此方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.CellID forIndexPath:indexPath];
    /*
     当前显示图片索引 = (item - 1 + 图片数量 + 当前应该显示图片的索引) % 图片数量
     最初状态
     (1 - 1 + 9 + 0) % 9  = 0;
     从第0页向前翻页到第8页:
     (0 - 1 + 9 + 0) % 9  = 8;
     从第8页向后翻到第0页
     (2 - 1 + 9 + 8) % 9 = 0;
     indexPath.item从1到2时为向前翻页（2 - 1 ＝1），
     从1到0时为向后翻页（0-1 ＝ －1）
     由于当2-1+9+8时为第8张往后翻页的情况应该跳到第0张，18%9为0，消除越界的情况否则2-1+8 ＝ 9会越界（0-8）*/
    NSInteger index = (indexPath.item - 1 + _imageCount + self.currentIndex) % _imageCount;
//   当是用户自定义的cell时, 这里不知道cell的类型和属性，将cell和model传递到controller中进行设置
    if (self.setCellModelBlock && ![self.CellID isEqualToString:@"LBDefultImageCell"]) {
        self.setCellModelBlock(cell,self.modelArray[index]);
    }else{
        //如果用户没有设置用来设置cell模型的block，默认给cell设置彩色背景
        cell.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(356)/355.0) green:((float)arc4random_uniform(356)/355.0) blue:((float)arc4random_uniform(356)/355.0) alpha:1.0f];
    }
    return cell;
}

#pragma mark- 懒加载（layout布局属性）
- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置最小行间距
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        //设置collectionView为水平滚动
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}




@end
