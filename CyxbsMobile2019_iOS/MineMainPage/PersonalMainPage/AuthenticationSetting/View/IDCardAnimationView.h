//
//  IDCardAnimationView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#define idCardAnimationTime 0.5

NS_ASSUME_NONNULL_BEGIN

@class IDCardAnimationView;
@class IDModel;

//手势执行前后吸附状态的变化，U表示UnLock，L表示Lock
typedef enum : NSUInteger {
    IDCardViewStateOptionU2U,
    IDCardViewStateOptionU2L,
    // 目前没有身份下拉的需求
//    IDCardViewStateOptionL2U,
//    IDCardViewStateOptionL2L
} IDCardViewStateOption;

// 身份 tableView 的类型
//typedef enum : NSUInteger {
//    // 认证身份
//    IDTableViewTypeAut,
//    // 个性身份
//    IDTableViewTypeCus,
//} IDTableViewType;
//

@protocol IDCardViewDelegate <NSObject>
/// 获取分页 view 的页号
- (NSInteger)currentSegmentViewIndex:(IDCardAnimationView*)view;
- (UITableView*)currentTableView:(IDCardAnimationView*)view;
- (IDModel*)getModelforIndexPath:(NSIndexPath*)indexPath pageIndex:(NSInteger)index :(IDCardAnimationView*)view;

- (void)insertCellWithModel:(IDModel*)model atIndexPath:(NSIndexPath*)idxPath :(IDCardAnimationView*)view;
- (void)setIDCardAsDisplayedWithModel:(IDModel*)model :(IDCardAnimationView*)view;
@end


@interface IDCardAnimationView : UIView

@property(nonatomic, unsafe_unretained)id <IDCardViewDelegate> delegate;

/// 认证身份页的tableView
@property (nonatomic, unsafe_unretained)UITableView *autTableView;

/// 个性身份页的tableView
@property (nonatomic, unsafe_unretained)UITableView *cusTableView;

- (void)setAsDisplayWith:(IDModel*)model;

/// 指定的初始化方法
/// @param tp 目标点
/// @param cellHeight cell 高度
- (instancetype)initWithTargetPoint:(CGPoint)tp cellHeight:(CGFloat)cellHeight;

- (void)cleanData;
@end

NS_ASSUME_NONNULL_END

