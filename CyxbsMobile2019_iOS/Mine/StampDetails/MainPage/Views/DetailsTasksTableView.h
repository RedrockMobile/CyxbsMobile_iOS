//
//  DetailsTasksTableView.h
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 任务记录的视图
 * 使用 dataMAry的setter方法更新数据
 */
@interface DetailsTasksTableView : UITableView

/// 展示的数据
@property (nonatomic, copy) NSArray * dataAry;

@end

NS_ASSUME_NONNULL_END
