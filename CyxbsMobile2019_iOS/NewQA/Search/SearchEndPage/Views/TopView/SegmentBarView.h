//
//  SegmentBarView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 标识选中哪个table的segmentBar
 */
@interface SegmentBarView : UIView

/// 初始化方法，根据传入的文字数组，创建出对应的segmentBarBtn
/// @param textAry 传入的按钮文字数组
- (instancetype)initWithFrame:(CGRect)frame AndTextAry:(NSArray *)textAry;

/// segmentBatBtn被选中时下方的小滑条
@property (nonatomic, strong) UIImageView *selectedImageView;

/// 按钮文字数组
@property (nonatomic, copy) NSArray <NSString *>*btnTextAry;

/// 自身的高度
@property (nonatomic, assign) CGFloat viewHeight;
@end

NS_ASSUME_NONNULL_END
