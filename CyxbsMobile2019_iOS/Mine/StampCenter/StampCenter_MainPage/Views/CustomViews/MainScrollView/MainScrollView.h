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
///主左右划view
@interface MainScrollView : UIScrollView 

///collection
@property (nonatomic,strong) UICollectionView *collection;
///collection头视图
@property (nonatomic,strong) CollectionHeaderView *collectionHeaderView;
///table
@property (nonatomic,strong) UITableView *table;
///table头视图
@property (nonatomic,strong) TableHeaderView *tableHeaderView;


@end

NS_ASSUME_NONNULL_END
