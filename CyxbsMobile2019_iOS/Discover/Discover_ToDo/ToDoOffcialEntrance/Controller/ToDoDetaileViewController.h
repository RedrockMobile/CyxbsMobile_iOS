//
//  ToDoDetaileViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoDataModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^reloadDataBlock)(void);
@interface ToDoDetaileViewController : UIViewController
/// 从展示页面传入的model
@property (nonatomic, strong) TodoDataModel *model;
/// 通知上一个页面尽心数据刷新的操作
@property (nonatomic, copy) reloadDataBlock block;
@end

NS_ASSUME_NONNULL_END
