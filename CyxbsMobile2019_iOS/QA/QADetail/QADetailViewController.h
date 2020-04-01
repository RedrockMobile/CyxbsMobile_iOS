//
//  QADetailViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QADetailViewController : QABaseViewController
-(instancetype)initViewWithId:(NSNumber *)question_id title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
