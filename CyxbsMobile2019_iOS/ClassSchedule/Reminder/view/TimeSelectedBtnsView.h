//
//  TimeSelectedBtnsView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TimeSelectedBtnsViewDeleget <NSObject>

@property(nonatomic,strong)NSMutableArray <NSDictionary*> *timeDictArray;

@end

/// 显示已经选择过的那些时间段的view
@interface TimeSelectedBtnsView : UIView

/// 添加已选时间的按钮
/// @param str 时间字符串
- (void)addBtnWithString:(NSString*)str;
- (void)loadSelectedButtonsWithTimeDict:(NSDictionary*)timeDict;
@property(nonatomic,weak)id<TimeSelectedBtnsViewDeleget>delegate;
@end

NS_ASSUME_NONNULL_END
