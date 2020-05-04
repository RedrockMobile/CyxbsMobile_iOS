//
//  IntegralStoreContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IntegralStoreContentViewDelegate <NSObject>

/// dismiss手势
- (void)dismissWithGesture:(UIPanGestureRecognizer *)gesture;

/// 按钮
- (void)myGoodsButtonTouched;

@end


@interface IntegralStoreContentView : UIView

@property (nonatomic, weak) id<IntegralStoreContentViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate> delegate;

@property (nonatomic, weak) UIView *storeView;
@property (nonatomic, weak) UICollectionView *storeCollectionView;
@property (nonatomic, weak) UILabel *scoreLabel;

@end

NS_ASSUME_NONNULL_END
