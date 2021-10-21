//
//  ToDoEmptyCell.h
//  ZY
//
//  Created by 欧紫浩 on 2021/8/12.
//

#import <UIKit/UIKit.h>
#import "TodoDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ToDoEmptyCell : UITableViewCell
/// 根据type来展示是哪一个分区的空白缺省页
@property(nonatomic,assign)NSInteger type;
@end

NS_ASSUME_NONNULL_END
