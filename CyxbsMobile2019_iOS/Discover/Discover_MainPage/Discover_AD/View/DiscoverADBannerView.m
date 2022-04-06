//
//  DiscoverADCollectionView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverADBannerView.h"

#pragma mark - DiscoverADBannerViewDelegateFlags

typedef struct {
    
    /// discoverADBannerViewBeginScroll:
    BOOL beginScroll;
    
    /// discoverADBannerViewDidScroll:
    BOOL didScroll;
    
    /// discoverADBannerViewEndScroll:
    BOOL endScroll;
    
} DiscoverADBannerViewDelegateFlags;

#pragma mark - DiscoverADBannerView ()

@interface DiscoverADBannerView ()

/// 计时器控件
@property (nonatomic, weak) NSTimer *timer;

/// 是否在自动滚动
@property (nonatomic) BOOL isAutoScroll;

/// 关于delegateFlags
@property (nonatomic) DiscoverADBannerViewDelegateFlags delegateFlags;

@end

#pragma mark - DiscoverADBannerView

@implementation DiscoverADBannerView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self DiscoverADBannerView_initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**行0间距*/
    layout.minimumLineSpacing = 0;
    /**列0间距*/
    layout.minimumInteritemSpacing = 0;
    /**四周0*/
    layout.sectionInset = UIEdgeInsetsZero;
    /**方向右*/
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [self initWithFrame:frame collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self DiscoverADBannerView_initializer];
    }
    return self;
}

- (void)DiscoverADBannerView_initializer {
    self.backgroundColor = UIColor.grayColor;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.clipsToBounds = YES;
    
    self.delegate = self;
    self.pagingEnabled = YES;
    self.bounces = NO;
    
    [self registerClass:[DiscoverADItem class] forCellWithReuseIdentifier:DiscoverADItemReuseIdentifier];
    
    _isAutoScroll = YES;
}

#pragma mark - Lazy

- (void)setBannerDelegate:(id<DiscoverADBannerViewDelegate>)ssr_delegate {
    _bannerDelegate = ssr_delegate;
    
    [self set_DiscoverADBannerViewDelegate];
}

- (void)set_DiscoverADBannerViewDelegate {
    self->_delegateFlags.beginScroll = [self.bannerDelegate respondsToSelector:@selector(discoverADBannerViewBeginScroll:)];
    
    self->_delegateFlags.didScroll = [self.bannerDelegate respondsToSelector:@selector(discoverADBannerViewDidScroll:)];
    
    self->_delegateFlags.endScroll = [self.bannerDelegate respondsToSelector:@selector(discoverADBannerViewEndScroll:)];
}

- (void)setIsAutoScroll:(BOOL)isAutoScroll {
    _isAutoScroll = isAutoScroll;
    
    [self endTimer];
    
    if (_isAutoScroll) {
        [self startTimer];
    }
}

- (void)setAutoTimeInterval:(NSTimeInterval)autoTimeInterval {
    _autoTimeInterval = autoTimeInterval;
    
    [self setIsAutoScroll:self.isAutoScroll];
}

#pragma mark - Method

- (NSUInteger)currentPage {
    return self.contentOffset.x / self.bounds.size.width;
}

- (DiscoverADItem *)getReusableDiscoverADItem {
    DiscoverADItem *cell = [self dequeueReusableCellWithReuseIdentifier:DiscoverADItemReuseIdentifier forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    return cell.withDefaultStyle;
}

/**开启循环
 * 当用户停止手势，或视图被加载时开启
 */
- (void)startTimer {
    [self endTimer];
    
    NSTimer *timer =
    [NSTimer
     scheduledTimerWithTimeInterval:self.autoTimeInterval
     target:self
     selector:@selector(automaticScroll)
     userInfo:nil
     repeats:YES];
    
    _timer = timer;
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
}

/**结束timmer
 * 当用户开始手势，或视图将被移除时结束
 */
- (void)endTimer {
    [self.timer invalidate];
    self.timer = nil;
}

/**自动开始滑动
 * 会先判断是不是越界，越界会无animated滑到第0个
 * 然后再往后面一个去滑动就好了
 */
- (void)automaticScroll {
    NSUInteger currentPage = self.currentPage;
    if (currentPage >= self.ADsCount) {
        [self
         scrollToItemAtIndexPath:
             [NSIndexPath indexPathForItem:0 inSection:0]
         atScrollPosition:UICollectionViewScrollPositionNone
         animated:NO];
        return;
    }
    [self
     scrollToItemAtIndexPath:
         [NSIndexPath indexPathForItem:(currentPage + 1) inSection:0]
     atScrollPosition:UICollectionViewScrollPositionNone
     animated:YES];
}


#pragma mark - Life cycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // 离开时，应该将timmer停止
    if (!newSuperview) {
        [self endTimer];
    }
}

- (void)dealloc {
    // 为了防止timmer出现bug，这里的双代理要设置为nil
    self.delegate = nil;
    self.dataSource = nil;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bannerDelegate) {
        [self.bannerDelegate discoverADBannerView:self didSelectedAtItem:indexPath.item];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.size;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 用户开始手势，关闭timer
    if (self.isAutoScroll) {
        [self endTimer];
        self.isAutoScroll = NO;
    }
    // 为了和其他UI配合，外传
    if (self.delegateFlags.beginScroll) {
        [self.bannerDelegate discoverADBannerViewBeginScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 用户停止手势，开启timer
    if (!self.isAutoScroll) {
        [self startTimer];
        self.isAutoScroll = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 配合其他UI
    if (self.delegateFlags.didScroll) {
        [self.bannerDelegate discoverADBannerViewDidScroll:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 如果是用户停止的scroll，那就要开循环
    if (!self.isAutoScroll) {
        [self startTimer];
    }
    // 配合其他UI
    if (self.delegateFlags.endScroll) {
        [self.bannerDelegate discoverADBannerViewEndScroll:self];
    }
}

@end
