//
//  QAReviewReportView.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/4/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAReviewReportView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *reportBtnCollection;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (void)setupView;
@end

NS_ASSUME_NONNULL_END
