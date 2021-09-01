//
//  TodoTableViewCell.h
//  ZY
//
//  Created by 欧紫浩 on 2021/8/13.
//

#import <UIKit/UIKit.h>
#import "TodoDataModel.h"
NS_ASSUME_NONNULL_BEGIN
@class TodoTableViewCell;
@protocol TodoTableViewCellDelegate <NSObject>

@optional
///点击已经完成的cell,将状态改变成未完成
- (void)doneCellDidClickedThroughCell:(TodoTableViewCell *)doneCell;
///点击待办事项的cell，状态改为完成
- (void)toDoCellDidClickedThroughCell:(TodoTableViewCell *)toDoCell;
@end

@interface TodoTableViewCell : UITableViewCell
/// 最前面点击的button
@property(nonatomic, strong) UIButton *circlebtn;

/// 标题
@property(nonatomic, strong) UILabel *titleLbl;

///cell的model
@property(nonatomic, strong) TodoDataModel *model;

@property(nonatomic, weak) id<TodoTableViewCellDelegate> delegate;
- (void)setDataWithModel:(TodoDataModel *)model;
@end

NS_ASSUME_NONNULL_END
