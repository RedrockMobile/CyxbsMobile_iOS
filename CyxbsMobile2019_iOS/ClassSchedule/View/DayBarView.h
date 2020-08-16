//
//  DayBarView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DAY_BAR_ITEM_H (MAIN_SCREEN_H*0.0616)
#define DAY_BAR_ITEM_W (MAIN_SCREEN_W*0.1227)
#define MONTH_ITEM_W (MAIN_SCREEN_W*0.088)
#define DAYBARVIEW_DISTANCE (MAIN_SCREEN_W*0.00885)
NS_ASSUME_NONNULL_BEGIN

@interface DayBarView : UIView
//dataArray是一周7天的日期信息
- (instancetype)initWithDataArray:(NSArray*)dataArray;
//整学期
- (instancetype)initForWholeTerm;
@end

NS_ASSUME_NONNULL_END
