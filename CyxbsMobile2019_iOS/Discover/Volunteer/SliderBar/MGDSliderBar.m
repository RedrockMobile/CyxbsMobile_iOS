//
//  MGDSliderBar.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MGDSliderBar.h"
#import "MGDSliderBarItem.h"

#define DEVICE_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SLIDER_VIEW_HEIGHT 4

@interface MGDSliderBar()<MGDSliderBarItemDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIImageView *sliderView;

@property (nonatomic, strong) MGDSliderBarItem *selectedItem;
@property (nonatomic, strong) MGDSliderBarItemSelectedCallBack callback;

@end

@implementation MGDSliderBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"MGDBackViewColor"];
        } else {
            // Fallback on earlier versions
        }
//        self.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:249.0/255.0 blue:252.0/255.0 alpha:1];
//        self.layer.shadowColor = [UIColor colorWithRed:174/255.0 green:182/255.0 blue:211/255.0 alpha:0.16].CGColor;
        self.layer.shadowRadius = 20;
        self.layer.shadowOpacity = 1;
        
        _items = [NSMutableArray array];
        [self initScrollView];
        [self initSliderView];
    }
    return self;
}

- (void)setItemsTitle:(NSArray *)itemsTitle {
    _itemsTitle = itemsTitle;
    [self setupItems];
}

- (void)setItemColor:(UIColor *)itemColor {
    for (MGDSliderBarItem *item in _items) {
        [item setItemTitleColor:itemColor];
    }
}

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
}

- (void)initSliderView {
    _sliderView = [[UIImageView alloc] init];
    _sliderView.image = [UIImage imageNamed:@"分页滑条"];
    _sliderView.layer.masksToBounds = YES;
    _sliderView.layer.cornerRadius = 1;
    [_scrollView addSubview:_sliderView];
}

- (void)setupItems {
    CGFloat itemX = 0;
    for (NSString *title in _itemsTitle) {
        MGDSliderBarItem *item = [[MGDSliderBarItem alloc] init];
        item.delegate = self;
        // Init the current item's frame
        item.frame = CGRectMake(itemX, 0, _itemWidth, CGRectGetHeight(_scrollView.frame));
        [item setItemTitle:title];
        if (_itemFontSize>0) {
            [item setItemTitleFont:_itemFontSize];
        }
        [_items addObject:item];
        [_scrollView addSubview:item];
        // Caculate the origin.x of the next item
        itemX = CGRectGetMaxX(item.frame);
    }
    // Cculate the scrollView 's contentSize by all the items
    _scrollView.contentSize = CGSizeMake(itemX, -30);
    // Set the default selected item, the first item
    MGDSliderBarItem *firstItem = [self.items firstObject];
    firstItem.selected = YES;
    _selectedItem = firstItem;
    CGFloat itemW = [MGDSliderBarItem widthForTitle:_selectedItem.title];
    // Set the frame of sliderView by the selected item
    _sliderView.frame = CGRectMake((_itemWidth-itemW)/2, self.frame.size.height - SLIDER_VIEW_HEIGHT, itemW, SLIDER_VIEW_HEIGHT);
}

- (void)scrollToVisibleItem:(MGDSliderBarItem *)item {
    NSInteger selectedItemIndex = [self.items indexOfObject:_selectedItem];
    NSInteger visibleItemIndex = [self.items indexOfObject:item];
    
    // If the selected item is same to the item to be visible, nothing to do
    if (selectedItemIndex == visibleItemIndex) {
        return;
    }
    
    CGPoint offset = _scrollView.contentOffset;
    
    // If the item to be visible is in the screen, nothing to do
    if (CGRectGetMinX(item.frame) > offset.x && CGRectGetMaxX(item.frame) < (offset.x + CGRectGetWidth(_scrollView.frame))) {
        return;
    }
    
    // Update the scrollView's contentOffset according to different situation
    if (selectedItemIndex < visibleItemIndex) {
        // The item to be visible is on the right of the selected item and the selected item is out of screeen by the left, also the opposite case, set the offset respectively
        if (CGRectGetMaxX(_selectedItem.frame) < offset.x) {
            offset.x = CGRectGetMinX(item.frame);
        } else {
            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
        }
    } else {
        // The item to be visible is on the left of the selected item and the selected item is out of screeen by the right, also the opposite case, set the offset respectively
        if (CGRectGetMinX(_selectedItem.frame) > (offset.x + CGRectGetWidth(_scrollView.frame))) {
            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
        } else {
            offset.x = CGRectGetMinX(item.frame);
        }
    }
    _scrollView.contentOffset = offset;
}

- (void)addAnimationWithSelectedItem:(MGDSliderBarItem *)item isYes:(BOOL)isYes{
    // Caculate the distance of translation
    CGFloat dx = CGRectGetMidX(item.frame) - CGRectGetMidX(_selectedItem.frame);
    CGFloat positionX;//初始位移
    if (isYes) {
        positionX = dx;
    }else{
        positionX = 0;
    }
    _sliderView.layer.position = CGPointMake(_sliderView.layer.position.x + dx, _sliderView.layer.position.y);
    CGRect rect = _sliderView.layer.bounds;
    CGFloat itemW = [MGDSliderBarItem widthForTitle:item.title];
    rect.size.width = itemW;
    _sliderView.layer.bounds = rect;
}

- (void)sliderBarItemSelectedCallBack:(MGDSliderBarItemSelectedCallBack)callback {
    _callback = callback;
}

- (void)selectedBarItemAtIndex:(NSInteger)index {
    MGDSliderBarItem *item = [self.items objectAtIndex:index];
    if (item == _selectedItem) {
        return;
    }
    
    item.selected = YES;
    [self scrollToVisibleItem:item];
    [self addAnimationWithSelectedItem:item isYes:YES];//页面滚动
    self.selectedItem = item;
}

#pragma mark - FDSlideBarItemDelegate

- (void)sliderBarItemSelected:(MGDSliderBarItem *)item {
    if (item == _selectedItem) {
        return;
    }
    [self addAnimationWithSelectedItem:item isYes:NO];//点击slider
    self.selectedItem = item;
    _callback([self.items indexOfObject:item]);
}

@end
