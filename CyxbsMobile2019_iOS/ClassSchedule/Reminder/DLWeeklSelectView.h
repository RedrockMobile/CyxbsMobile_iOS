//
//  DLWeeklSelectView.h
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WeekSelectDelegate <NSObject>

- (void)selectedWeekArrayAtIndex:(NSInteger)index;

@end
@interface DLWeeklSelectView : UIView
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, weak) id<WeekSelectDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
