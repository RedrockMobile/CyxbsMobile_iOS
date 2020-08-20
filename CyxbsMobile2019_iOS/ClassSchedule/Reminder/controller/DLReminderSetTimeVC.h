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
///为你的行程添加标题时选择的标题
@property (nonatomic, strong) NSString *noticeString;

/// //为你的行程添加内容时输入的文字
@property (nonatomic, strong) NSString *detailString;

/// 选择时间的DLTimeSelectView和显示已选择时间的TimeSelectedBtnsView的代理属性，里面是已经选择的时间字典
/// ，结构：@{@"weekString":@"",  @"lessonString":@""}，代码把这个属性的alloc init
/// 放DLReminderSetTimeVC，对数组内部元素的增删操作都放在TimeSelectedBtnsView
@property(nonatomic,strong)NSMutableArray <NSDictionary*> *timeDictArray;
@end

NS_ASSUME_NONNULL_END
