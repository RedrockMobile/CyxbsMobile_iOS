//
//  TodoTableViewCell.h
//  ZY
//
//  Created by 欧紫浩 on 2021/8/13.
//

#import <UIKit/UIKit.h>
#import "TodoDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TodoTableViewCellDelegate <NSObject>

@optional
//- (void)todoCellDidClickedDoneButton:(TodoTableViewCell *)todoCell;

@end

@interface TodoTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel *nameL;
@property(nonatomic, strong) UILabel *timeL;
@property(nonatomic, strong) TodoDataModel *model;
@property(nonatomic, weak) id<TodoTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
