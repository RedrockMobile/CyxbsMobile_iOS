//
//  VerticalScrollView.h
//  NewSearchSeconthTry
//
//  Created by 石子涵 on 2021/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 最底部的的垂直滑动的scrollView
@interface QAVerticalScrollView : UIScrollView<UIGestureRecognizerDelegate>
/// l是否可以滑动
@property (nonatomic, assign) BOOL canScroll;
@end

NS_ASSUME_NONNULL_END
