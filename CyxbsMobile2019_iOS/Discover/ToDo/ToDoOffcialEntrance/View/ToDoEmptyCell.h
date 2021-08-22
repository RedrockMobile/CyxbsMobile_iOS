//
//  ToDoEmptyCell.h
//  ZY
//
//  Created by 欧紫浩 on 2021/8/12.
//

#import <UIKit/UIKit.h>
#import "TODOModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ToDoEmptyCell : UITableViewCell
@property(nonatomic,assign)NSInteger type;
///cell里的事件
@property (nonatomic,strong) UILabel *todo_thing;
///cell里的时间
@property (nonatomic,strong) UILabel *todo_time;

@property (nonatomic,strong) TODOModel *model;

@end

NS_ASSUME_NONNULL_END
