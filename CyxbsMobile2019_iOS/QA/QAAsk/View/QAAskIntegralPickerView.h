//
//  QAAskIntegralPickerView.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAAskIntegralPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPickerView *integralPickView;
@property (strong,nonatomic)NSMutableArray *integralPickViewContent;
@property (copy,nonatomic)NSString *integralNum;
@end

NS_ASSUME_NONNULL_END
