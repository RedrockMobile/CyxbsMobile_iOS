//
//  SegmentView.h
//  Details
//
//  Created by Edioth Jin on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SegmentView;
@protocol SegmentViewDelegate <NSObject>

- (void)segmentView:(SegmentView *)segmentView
     alertWithIndex:(NSInteger)index;

@end

/**
 * 分隔栏视图
 * 初始化输入 titles
 * 或者先传入 titles 再设置 frame
 */
@interface SegmentView : UIView

@property (nonatomic, weak) id <SegmentViewDelegate> delegate;
/// 所有的标题
@property (nonatomic, copy) NSArray <NSString *> * titles;
/// 选中的button
@property (nonatomic, assign) NSInteger selectedIndex;

+ (instancetype)segmentViewWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
