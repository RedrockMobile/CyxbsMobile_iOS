//
//  DynamicDetailTopBarView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DynamicDetailTopBarViewDelegate <NSObject>

/// 返回到上个界面
- (void)pop;

@end
/**
 动态详情页的顶部视图
 包含一个透明的返回按钮，一个返回的图片框，一个标题的lael,一个底部分割线
 */
@interface DynamicDetailTopBarView : UIView
@property (nonatomic, weak) id <DynamicDetailTopBarViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
