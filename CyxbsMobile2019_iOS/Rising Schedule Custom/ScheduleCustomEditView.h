//
//  ScheduleCustomEditView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/2/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCustomEditView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic) NSInteger inWeek;

@property (nonatomic) NSIndexSet *sections;

@property (nonatomic) NSRange period;

@end

NS_ASSUME_NONNULL_END
