//
//  ToDoTableView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 这是放置ToDo事项的table
 数据源为本table，代理则设置为VC，将数据源从VC中抽离出来
 */
@interface ToDoTableView : UITableView
/// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataSourceAry;
/// 是否折叠已完成的分区
@property (nonatomic ,assign) BOOL isFoldTwoSection;
@end

NS_ASSUME_NONNULL_END
