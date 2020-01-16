//
//  StoreyResultView.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreyResultView : UIView
@property (nonatomic, strong)UILabel *storeyLabel;//楼层标识
@property (nonatomic, strong)UIView *detailView;
@property (nonatomic, copy)NSArray *StoreyArray;//空房间数组
- (instancetype)initWithStoreyString:(NSString *)storeyString;
- (void)refreshUI;//更新UI
- (void)clearUI;//有上次查找残留的痕迹，那么清除他们
@end

NS_ASSUME_NONNULL_END
