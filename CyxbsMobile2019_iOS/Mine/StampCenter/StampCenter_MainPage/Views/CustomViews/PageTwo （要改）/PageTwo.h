//
//  PageTwo.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//

#import <UIKit/UIKit.h>
#import "UIView+XYView.h"
#import "PrefixHeader.pch"
#import "TableHeaderView.h"
#import "MyTableViewCell.h"
#import "MyTableViewCellWithProgress.h"
NS_ASSUME_NONNULL_BEGIN

@interface PageTwo : UIView

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) TableHeaderView *tableHeaderView;

@end

NS_ASSUME_NONNULL_END
