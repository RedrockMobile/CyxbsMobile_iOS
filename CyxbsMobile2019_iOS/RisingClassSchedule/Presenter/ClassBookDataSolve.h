//
//  ClassBookDataSolve.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/13.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**这个类作为Presenter逻辑处理
 * 通过弱持有，所以强持有那边必须逻辑非常清晰
 * 这里将做所有的代理处理，以用于增加需求时的处理
 */

#import <Foundation/Foundation.h>

#import "ClassBookModel.h"

#import "ClassBookCollectionView.h"

#import "ClassBookFL.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ClassBookDataSolve

@interface ClassBookDataSolve : NSObject <
    ClassBookFLDelegate,
    ClassBookCollectionViewDelegate,
    UICollectionViewDataSource
>

/// 课表数据源
@property (nonatomic, weak) ClassBookModel *classBookModel;

/// 课表视图
@property (nonatomic, weak) ClassBookCollectionView *classBookCollectionView;

@end

NS_ASSUME_NONNULL_END
