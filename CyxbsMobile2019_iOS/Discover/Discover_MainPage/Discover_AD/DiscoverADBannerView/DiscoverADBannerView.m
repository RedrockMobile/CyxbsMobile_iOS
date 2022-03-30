//
//  DiscoverADCollectionView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverADBannerView.h"

#pragma mark - _DiscoverADBannerViewDelegate

struct {
    
    /// discoverADBannerViewBeginScroll:
    unsigned int beginScroll : 1;
    
    /// discoverADBannerViewDidScroll:
    unsigned int didScroll : 1;
    
    /// discoverADBannerViewEndScroll:
    unsigned int endScroll : 1;
    
} _DiscoverADBannerViewDelegate;

#pragma mark - DiscoverADBannerView ()

@interface DiscoverADBannerView ()

/// 计时器控件
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic) BOOL isAutoScroll;

@end

#pragma mark - DiscoverADBannerView

@implementation DiscoverADBannerView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializer];
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
        [self initializer];
    }
    return self;
}

- (void)initializer {
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

- (void)setSsr_delegate:(id<DiscoverADBannerViewDelegate>)ssr_delegate {
    _ssr_delegate = ssr_delegate;
    
    [self set_DiscoverADBannerViewDelegate];
}

- (void)set_DiscoverADBannerViewDelegate {
    _DiscoverADBannerViewDelegate.beginScroll = [self.ssr_delegate respondsToSelector:@selector(discoverADBannerViewBeginScroll:)];
    
    _DiscoverADBannerViewDelegate.didScroll = [self.ssr_delegate respondsToSelector:@selector(discoverADBannerViewDidScroll:)];
    
    _DiscoverADBannerViewDelegate.endScroll = [self.ssr_delegate respondsToSelector:@selector(discoverADBannerViewEndScroll:)];
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
    
    return cell.Default;
}

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

- (void)endTimer {
    [self.timer invalidate];
    self.timer = nil;
}

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
    if (!newSuperview) {
        [self endTimer];
    }
}

- (void)dealloc {
    self.delegate = nil;
    self.dataSource = nil;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ssr_delegate) {
        [self.ssr_delegate discoverADBannerView:self didSelectedAtItem:indexPath.item];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.size;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isAutoScroll) {
        [self endTimer];
    }
    
    if (_DiscoverADBannerViewDelegate.beginScroll) {
        [self.ssr_delegate discoverADBannerViewBeginScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isAutoScroll) {
        [self startTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.ADsCount) {
        return;
    }
    
    if (_DiscoverADBannerViewDelegate.endScroll) {
        [self.ssr_delegate discoverADBannerViewEndScroll:self];
    }
}

@end
