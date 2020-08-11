//
//  QAAskNextStepView.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QAAskIntegralPickerView;
@interface QAAskNextStepView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
- (void)setupView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *questionmarkBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *timePickerVIew;
@property (weak, nonatomic) IBOutlet UIView *integralPickBackgroundView;
@property (strong, nonatomic) QAAskIntegralPickerView *integralPickView;
@property (weak, nonatomic) IBOutlet UILabel *integralNumLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property(strong,nonatomic)NSMutableArray *timePickViewContent;
@property (weak, nonatomic) IBOutlet UILabel *integralSettingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DDLLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardLabel;

//选中的时间
@property (copy,nonatomic)NSString *time;
//@property (copy,nonatomic)NSString *integralNum;
@end

NS_ASSUME_NONNULL_END
