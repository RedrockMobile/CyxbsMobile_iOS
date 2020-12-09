//
//  NewDetailViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewDetailViewController : UIViewController
@property (nonatomic, copy)NSString *NewsTime;
@property (nonatomic, copy)NSString *NewsTitle;
@property (nonatomic, copy)NSString *NewsID;
- (instancetype) initWithNewsTime: (NSString *)time NewsTitle: (NSString *)NewsTitle NewsID: (NSString *)NewsID;
@end

NS_ASSUME_NONNULL_END
