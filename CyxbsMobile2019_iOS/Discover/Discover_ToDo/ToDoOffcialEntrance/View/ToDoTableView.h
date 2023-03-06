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
 数据源为table自身，代理则设置为VC，将数据源从VC中抽离出来
 */
@interface ToDoTableView : UITableView

@end

NS_ASSUME_NONNULL_END
