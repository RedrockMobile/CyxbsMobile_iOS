//
//  MainScrollView.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StampCenterCollectionHeaderView.h"
#import "TableHeaderView.h"


NS_ASSUME_NONNULL_BEGIN
///主左右划view
@interface MainScrollView : UIScrollView 

///collection
@property (nonatomic,strong) UICollectionView *collection;
///collection头视图
@property (nonatomic,strong) StampCenterCollectionHeaderView *collectionHeaderView;
///table
@property (nonatomic,strong) UITableView *table;



@end

NS_ASSUME_NONNULL_END
