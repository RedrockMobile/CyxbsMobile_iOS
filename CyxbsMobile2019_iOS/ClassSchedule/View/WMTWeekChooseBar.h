//
//  WMTWeekChooseBar.h
//  MoblieCQUPT_iOS
//
//  Created by wmt on 2019/11/3.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMTWeekChooseBar : UIView
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSInteger index;
-(instancetype)initWithFrame:(CGRect)frame nowWeek:(NSNumber *)nowWeek;
-(void)changeIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
