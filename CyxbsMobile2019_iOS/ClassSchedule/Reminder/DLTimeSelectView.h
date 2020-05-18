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
@property (nonatomic, strong) UIPickerView *timePiker;
@property (nonatomic, strong) UIButton *addButton;

- (void)initTimePickerView;
@end

NS_ASSUME_NONNULL_END
