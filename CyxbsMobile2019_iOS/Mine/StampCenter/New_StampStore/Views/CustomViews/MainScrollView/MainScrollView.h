//
//  MainScrollView.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionHeaderView.h"
#import "TableHeaderView.h"


NS_ASSUME_NONNULL_BEGIN

@interface MainScrollView : UIScrollView 

@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,strong) CollectionHeaderView *collectionHeaderView;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) TableHeaderView *tableHeaderView;
@property (nonatomic,copy) NSArray *goodsAry;
@property (nonatomic,copy) NSArray *section2GoodsAry;
@property (nonatomic,copy) NSArray *taskAry;

@end

NS_ASSUME_NONNULL_END
