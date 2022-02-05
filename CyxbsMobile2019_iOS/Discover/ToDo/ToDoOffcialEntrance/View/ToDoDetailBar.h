//
//  ToDoDetailBar.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ToDoDetailBarDelegate <NSObject>
/// 跳回到上一个VC
- (void)popVC;

/// 保存对当前页面的所有更改
- (void)saveChanges;

@end

/// todo事项详情页的顶部的bar，自定义navBar太麻烦了，所以自定义View
@interface ToDoDetailBar : UIView
@property (nonatomic, weak) id<ToDoDetailBarDelegate> delegate;

///保存的按钮
@property (nonatomic, strong) UIButton *saveBtn;

/// 保存的label
@property (nonatomic, strong) UILabel *saveLbl;

@end

NS_ASSUME_NONNULL_END
