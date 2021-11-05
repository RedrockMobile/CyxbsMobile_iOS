//
//  MainScrollView.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MainScrollView.h"
#import "MyCollectionViewCell.h"
#import "SecondHeaderView.h"
@implementation MainScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.tag = 123;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collection];
        [self addSubview:self.table];
    }
    return self;
}

#pragma mark - getter
- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.024*SCREEN_WIDTH;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 1);
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-Bar_H) collectionViewLayout:layout];
        _collection.showsVerticalScrollIndicator = NO;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.bounces = NO;
        _collection.backgroundColor = [UIColor colorNamed:@"#FBFCFF"];
        [_collection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collection registerClass:[SecondHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionHeaderView = [[CollectionHeaderView alloc]initWithFrame:CGRectMake(0, 215, SCREEN_WIDTH, COLLECTIONHEADER_H)];
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215+65)];
        v.backgroundColor = [UIColor colorNamed:@"#F2F3F8"];
        [v addSubview:_collectionHeaderView];
        [_collection addSubview: v];
    }
    return _collection;
}

- (UITableView *)table{
    if (!_table) {
        _tableHeaderView = [[TableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 86-8)];
        _table = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-Bar_H)];
        _table.showsVerticalScrollIndicator = NO;
        _table.showsHorizontalScrollIndicator = NO;
        _table.contentInset = UIEdgeInsetsMake(215, 0, 0, 0);
        _table.bounces = NO;
        _table.backgroundColor = [UIColor colorNamed:@"#F2F3F8"];
        _table.tableHeaderView = _tableHeaderView;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    return _table;
}

@end
