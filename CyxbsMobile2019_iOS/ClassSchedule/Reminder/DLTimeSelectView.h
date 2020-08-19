//
//  DLTimeSelectView.h
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLTimeSelectView : UIView

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIPickerView *weekPicker;
@property (nonatomic, strong) UIPickerView *lessonPicker;
//- (void)initTimePickerView;
@end

NS_ASSUME_NONNULL_END
