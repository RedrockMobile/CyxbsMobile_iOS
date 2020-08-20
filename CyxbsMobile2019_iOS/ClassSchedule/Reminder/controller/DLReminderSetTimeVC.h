//
//  DLReminderSetTimeVC.h
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/10.
//  Copyright © 2020 Redrock. All rights reserved.
//最终编辑备忘时间的页面

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLReminderSetTimeVC : UIViewController
@property (nonatomic, strong) NSString *noticeString;
@property (nonatomic, strong) NSString *detailString;
@property(nonatomic,strong)NSMutableArray <NSDictionary*> *timeDictArray;
@end

NS_ASSUME_NONNULL_END
